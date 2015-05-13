//
//  ViewController.m
//  DBFM
//
//  Created by chenzhipeng on 15/5/6.
//  Copyright (c) 2015年 chenzhipeng. All rights reserved.
//

#import "ViewController.h"
#import "ExImageView.h"
#import "FMChannelData.h"
#import "FMSongData.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "ExButton.h"
#import "MBProgressHUD.h"
#import "ExOrderButton.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *play_bg;
@property (weak, nonatomic) IBOutlet ExImageView *play_exView;
@property (weak, nonatomic) IBOutlet UITableView *play_listView;
@property (weak, nonatomic) IBOutlet UILabel *play_timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *play_progressBackView;
@property (weak, nonatomic) IBOutlet UIImageView *play_progressView;

@property (strong, nonatomic) HttpController *httpController;
@property (strong, nonatomic) MPMoviePlayerController *audioPlayer;
@property (weak, nonatomic) IBOutlet ExButton *playButton;
@property (strong, nonatomic) NSTimer *playTimer;
@property (weak, nonatomic) IBOutlet ExOrderButton *playOrder;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    m_channelArray = [[NSMutableArray alloc] init];
    m_songArray = [[NSMutableArray alloc] init];
    m_imageChacheDic = [[NSMutableDictionary alloc] init];
    m_songUrlArray = [[NSMutableArray alloc] init];
    self.audioPlayer = [[MPMoviePlayerController alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playFinish) name:MPMoviePlayerPlaybackDidFinishNotification object:self.audioPlayer];
    
    [self.play_exView sizeToFit];
    
    self.httpController = [[HttpController alloc] init];
    self.httpController.m_delegate = self;
    
    // 请求频道数据
    [self.httpController requestJsonData:@"http://www.douban.com/j/app/radio/channels"];
    // 请求频道为0的数据
    [self channelChange:@"0"];
    
    isNormalFinish = YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    [self.play_exView startRotation];
    
    //设置背景模糊
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    [self.play_bg layoutIfNeeded];
    blurView.frame = self.view.frame;
    [self.play_bg addSubview:blurView];
    
    self.play_listView.delegate = self;
    self.play_listView.dataSource = self;
    self.play_listView.backgroundColor = [UIColor clearColor];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ChanelController *ctr = (ChanelController *)segue.destinationViewController;
    ctr.m_channelArray = m_channelArray;
    ctr.m_delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 *  @author chen_zhipeng, 15-05-13
 *
 *  播放/暂停按钮 点击事件
 *  @param sender 播放/暂停按钮
 */
- (IBAction)onChangePlayStatus:(id)sender
{
    ExButton *playButton = (ExButton *)sender;
    
    //当前是否正在播放
    if([playButton isPlaying])
    {
        [self.audioPlayer pause];
        [self showToast:@"暂停"];
        isNormalFinish = NO;
    }else{
        [self.audioPlayer play];
        [self showToast:@"播放"];
    }
    
    // 更新按钮状态
    [playButton changePlayStatus];
}

/**
 *  @author chen_zhipeng, 15-05-13
 *
 *  播放上一首歌曲
 *  @param sender 上一首按钮
 */
- (IBAction)playPre:(id)sender {
    
    if (sender)
    {
        isNormalFinish = NO;
    }
    
    if ([m_songArray count]>0)
    {
        // 当前播放的是列表的第一个时, 点上一首时播放最后一首
        if (m_currentPalyIndex == 0)
        {
            [self onRowSelected:[m_songArray count]-1];
        }else{
            [self onRowSelected:m_currentPalyIndex-1];
        }
    }
    
    // 更新播放按钮
    [self.playButton changePlayStyle:YES];
    [self showToast:@"上一首"];
}

/**
 *  @author chen_zhipeng, 15-05-13
 *
 *  播放下一首
 *  @param sender 下一首按钮
 */
- (IBAction)playNext:(id)sender {
    if (sender)
    {
        isNormalFinish = NO;
    }
    
    if ([m_songArray count]>0)
    {
        // 当前播放的是最后一首，点下一首时播第一首
        if (m_currentPalyIndex == [m_songArray count]-1)
        {
            [self onRowSelected:0];
        }else{
            [self onRowSelected:m_currentPalyIndex+1];
        }
    }
    
    // 更新播放按钮
    [self.playButton changePlayStyle:YES];
    [self showToast:@"下一首"];
}

/**
 *  @author chen_zhipeng, 15-05-13
 *
 *  播放模式切换处理
 *  @param sender 播放模式切换按钮
 */
- (IBAction)changePlayMode:(id)sender {
    
    ExOrderButton *orderButton = (ExOrderButton *)sender;
    NSString *message= nil;
    switch ([orderButton currentOrderMode])
    {
        case Play_Order_List:
            message = @"顺序播放";
            break;
        case Play_Order_Random:
            message = @"随机播放";
            break;
        case Play_Order_Single:
            message = @"单曲循环";
            break;
        default:
            message = @"不存在艾!";
            break;
    }
    
    [self showToast:message];
}

/**
 *  @author chen_zhipeng, 15-05-13
 *
 *  通过URL播放音乐
 *  @param musicUrl 音乐地址
 */
- (void)playMusic:(NSString *)musicUrl
{
    // 停止当前的播放
    [self.audioPlayer stop];
    // 设置在线播放地址
    [self.audioPlayer setContentURL:[NSURL URLWithString:musicUrl]];
    // 开始播放
    [self.audioPlayer play];
    
    // 重置Timer
    if (self.playTimer)
    {
        [self.playTimer invalidate];
    }
    
    // 启动计时器
    self.playTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(onUpdatePlayTime) userInfo:nil repeats:YES];
}

/**
 *  @author chen_zhipeng, 15-05-13
 *
 *  更新界面的播放时间
 */
-(void)onUpdatePlayTime
{
    // 获取当前播放进度
    NSTimeInterval currentTime = self.audioPlayer.currentPlaybackTime;
    if(currentTime>0)
    {
        int minute = (int)currentTime/60;   // 分
        int second = (int)currentTime%60;   // 秒
        NSMutableString *timeStr = [[NSMutableString alloc] init];
        
        // 个位数时, 前面补0
        if (minute < 10)
        {
            [timeStr appendString:[NSString stringWithFormat:@"0%d:",minute]];
        }else{
            [timeStr appendString:[NSString stringWithFormat:@"%d:",minute]];
        }
        
        // 个位数时, 前面补0
        if (second < 10)
        {
            [timeStr appendString:[NSString stringWithFormat:@"0%d",second]];
        }else{
            [timeStr appendString:[NSString stringWithFormat:@"%d",second]];
        }
        
        // 更新显示的播放时间
        [self.play_timeLabel setText:timeStr];
        
        // 计算进度百分比
        double percent = currentTime /self.audioPlayer.duration;
        
        // 更新播放进度条
        self.play_progressView.frame = CGRectMake(self.play_progressView.frame.origin.x, self.play_progressView.frame.origin.y, self.play_progressBackView.frame.size.width*percent, self.play_progressView.frame.size.height);
    }else{
        [self.play_timeLabel setText:@"00:00"];
        
        self.play_progressView.frame = CGRectMake(self.play_progressView.frame.origin.x, self.play_progressView.frame.origin.y, 0, self.play_progressView.frame.size.height);
    }
}

/**
 *  @author chen_zhipeng, 15-05-13
 *
 *  当前音乐播放结束处理
 */
-(void)playFinish
{
    if (!isNormalFinish)
    {
        return;
    }
    
    // 根据播放模式, 执行下一步操作
    switch ([self.playOrder currentOrderMode])
    {
        case Play_Order_List:   // 顺序播放
            [self playNext:nil];
            break;
        case Play_Order_Random: // 随机播放
            [self onRowSelected:(arc4random()%[m_songArray count]-1)];
            break;
        case Play_Order_Single: // 单曲循环
            [self onRowSelected:m_currentPalyIndex];
            break;
        default:
            break;
    }
}

/**
 *  @author chen_zhipeng, 15-05-13
 *
 *  显示Toast消息
 *  @param message 需要显示的内容
 */
-(void)showToast:(NSString *)message
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = message;
    hud.margin = 5.0f;  // 内容距离边框的距离
    hud.cornerRadius = 5.0f;    // 边角幅度
    hud.yOffset = self.view.frame.size.height/2-30; // Y轴距离中点偏移量
    hud.userInteractionEnabled = NO;    // 背景视图可以响应
    [hud hide:YES afterDelay:2];    // 延时关闭
    
    /*
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });*/
}

#pragma mark - UITableView delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return m_songArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 根据标识获取Cell
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"douban"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"douban"];
    }
    cell.backgroundColor = [UIColor clearColor];
    
    // 获取当前cell对应的歌曲信息
    FMSongData *song = (FMSongData *)[m_songArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = song.m_title;
    cell.detailTextLabel.text = song.m_artist;
    
    // 根据URL, 获取图片资源
    UIImage *image = [self imageByUrl:song.m_picture];
    if (!image) {
        image = [UIImage imageNamed:@"play_default_icon"];
    }
    cell.imageView.image = image;
    
    // 设置cell显示动画
    cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1);
    [UIView animateWithDuration:0.25 animations:^(void){
         cell.layer.transform = CATransform3DMakeScale(1, 1, 1);
    }];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self onRowSelected:indexPath.row];
    isNormalFinish = NO;
}

// 下拉刷新的原理
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    // 下拉80像素执行刷新
    if (scrollView.contentOffset.y < - 80) {
        
        [UIView animateWithDuration:1.0 animations:^{
            // 设置加载样式
        } completion:^(BOOL finished) {
            
            /**
             *  发起网络请求,请求刷新数据
             */
            [self channelChange:@"0"];
        }];
    }
}

/**
 *  @author chen_zhipeng, 15-05-13
 *
 *  Cell点击处理
 *  @param index 点击的索引
 */
-(void)onRowSelected:(NSInteger)index
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.play_listView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    
    FMSongData *song = (FMSongData *)[m_songArray objectAtIndex:index];
    
    // 设置当前播放的歌曲图片
    [self onSetImage:song.m_picture];
    if(song.m_url && song.m_url.length > 0)
    {
        // 播放歌曲
        [self playMusic:song.m_url];
        m_currentPalyIndex = index;
    }
}

/**
 *  @author chen_zhipeng, 15-05-13
 *
 *  设置播放图片和背景图片
 *  @param imageUrl 图片URL
 */
-(void)onSetImage:(NSString *)imageUrl
{
    UIImage *image = [self imageByUrl:imageUrl];
    
    if (!image) {
        image = [UIImage imageNamed:@"play_default_icon"];
    }
    
    [self.play_exView setImage:image];
    [self.play_bg setImage:image];
}

/**
 *  @author chen_zhipeng, 15-05-13
 *
 *  根据图片URL,获取图片资源
 *  @param url 图片URL
 *  @return UIImage
 */
-(UIImage *)imageByUrl:(NSString *)url
{
    UIImage *image = nil;
    if (url)
    {
        // 从本地缓存获取
        image = (UIImage *)[m_imageChacheDic objectForKey:url];
        
        // 本地缓存不存在
        if (!image)
        {
            // 通过网络请求获取数据
            NSData *imageData = [self.httpController requestData:url];
            
            if (imageData)
            {
                // 将网络数据转化成图片
                image = [UIImage imageWithData:imageData scale:[UIScreen mainScreen].scale];
                if (image)
                {
                    // 保存图片资源到本地缓存
                    [m_imageChacheDic setObject:image forKey:url];
                }
            }
        }
    }
    
    return image;
}
#pragma mark  - HttpCtrDelegate
/**
 *  @author chen_zhipeng, 15-05-13
 *
 *  网络请求成功回调
 *  @param data 网络数据
 */
-(void)receiveResponseData:(id)data
{
    if([data isKindOfClass:[NSDictionary class]]){
        // 豆瓣FM频道数据
        if ([data objectForKey:@"channels"])
        {
            NSArray *array = (NSArray *)[data objectForKey:@"channels"];
            [m_channelArray removeAllObjects];
            for (NSDictionary *dic in array)
            {
                FMChannelData *channel = [[FMChannelData alloc] init];
                [channel parseDicToData:dic];
                [m_channelArray addObject:channel];
            }
        // 豆瓣FM歌曲数据
        }else if ([data objectForKey:@"song"]){
            NSArray *array = (NSArray *)[data objectForKey:@"song"];
            [m_songArray removeAllObjects];
            for (NSDictionary *dic in array)
            {
                FMSongData *song = [[FMSongData alloc] init];
                [song parseDicToData:dic];
                [m_songArray addObject:song];
                [m_songUrlArray addObject:song.m_url];
            }
            
            [self.play_listView reloadData];
            if (m_songArray.count > 0)
            {
                [self onRowSelected:0];
            }else{
                [self onSetImage:nil];
            }
        }else{
            NSLog(@"error response!!!!");
        }
    }
}

/**
 *  @author chen_zhipeng, 15-05-13
 *
 *  网络请求失败回调
 */
-(void)responseDidFailed
{
    [self showToast:@"网络罢工，无法获取数据!!!!\n!!!!!!!!!!!!!!!!!!!!!!!!!"];
}
#pragma mark - ChannelCtrDelegate
/**
 *  @author chen_zhipeng, 15-05-13
 *
 *  根据频道ID更新歌曲
 *  @param channelID 频道ID
 */
-(void)channelChange:(NSString *)channelID
{
    [self.httpController requestJsonData:[NSString stringWithFormat:@"http://douban.fm/j/mine/playlist?type=n&channel=%@&from=mainsite", channelID]];
}
@end
