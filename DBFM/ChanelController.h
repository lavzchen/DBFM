//
//  ChanelController.h
//  DBFM
//
//  Created by chenzhipeng on 15/5/6.
//  Copyright (c) 2015年 chenzhipeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChannelCtrDelegate <NSObject>

-(void)channelChange:(NSString *)channelID;

@end

@interface ChanelController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) id<ChannelCtrDelegate> m_delegate;
@property (strong, nonatomic) NSArray *m_channelArray;

@end
