//
//  ViewController.h
//  DBFM
//
//  Created by chenzhipeng on 15/5/6.
//  Copyright (c) 2015年 chenzhipeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HttpController.h"
#import "ChanelController.h"

@interface ViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, HttpCtrDelegate, ChannelCtrDelegate>
{
    NSMutableArray *m_channelArray;
    NSMutableArray *m_songArray;
    NSMutableDictionary *m_imageChacheDic;
    NSMutableArray *m_songUrlArray;
    
    NSInteger m_currentPalyIndex;
    
    BOOL isNormalFinish;
}

@end

