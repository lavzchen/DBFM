//
//  ChanelController.m
//  DBFM
//
//  Created by chenzhipeng on 15/5/6.
//  Copyright (c) 2015年 chenzhipeng. All rights reserved.
//

#import "ChanelController.h"
#import "FMChannelData.h"

@interface ChanelController ()
@property (weak, nonatomic) IBOutlet UITableView *play_chanelView;

@end

@implementation ChanelController
@synthesize m_channelArray, m_delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.alpha = 0.8;
    // Do any additional setup after loading the view.
}
/**
 *  @author chen_zhipeng, 15-05-13
 *
 *  取消处理
 *  @param sender 取消按钮
 */
- (IBAction)cancelOnClick:(id)sender {
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return m_channelArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"chanel"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"chanel"];
    }
    
    FMChannelData *channel = (FMChannelData *)[m_channelArray objectAtIndex:indexPath.row];
    cell.textLabel.text = channel.m_name;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FMChannelData *channel = (FMChannelData *)[m_channelArray objectAtIndex:indexPath.row];
    NSString *channelID = channel.m_channel_id;
    if([channel.m_channel_id integerValue] == 0)
    {
        channelID = @"0";
    }
    if (m_delegate && [m_delegate respondsToSelector:@selector(channelChange:)])
    {
        [m_delegate channelChange:channelID];
        [self dismissViewControllerAnimated:YES
                                 completion:nil];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
