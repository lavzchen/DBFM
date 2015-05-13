//
//  ExOrderButton.h
//  DBFM
//
//  Created by chenzhipeng on 15/5/11.
//  Copyright (c) 2015年 chenzhipeng. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum
{
    Play_Order_List = 0,
    Play_Order_Random,
    Play_Order_Single,
}Play_Order_Mode;

@interface ExOrderButton : UIButton
{
    NSArray *m_imageArry;
    Play_Order_Mode m_orderMode;
}

-(Play_Order_Mode)currentOrderMode;
@end
