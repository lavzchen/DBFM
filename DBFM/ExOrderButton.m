//
//  ExOrderButton.m
//  DBFM
//
//  Created by chenzhipeng on 15/5/11.
//  Copyright (c) 2015年 chenzhipeng. All rights reserved.
//

#import "ExOrderButton.h"

@implementation ExOrderButton

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        m_imageArry = [NSArray arrayWithObjects:[UIImage imageNamed:@"play_order1"], [UIImage imageNamed:@"play_order2"], nil];
        
        m_orderMode = Play_Order_List;
        
        [self addTarget:self action:@selector(onClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)onClick
{
    m_orderMode++;
    
    if (m_orderMode>[m_imageArry count]-1)
    {
        m_orderMode = Play_Order_List;
    }
    
    [self setImage:[m_imageArry objectAtIndex:m_orderMode] forState:UIControlStateNormal];
}

-(Play_Order_Mode)currentOrderMode
{
    return m_orderMode;
}
@end
