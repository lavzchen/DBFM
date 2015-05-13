//
//  ExButton.m
//  DBFM
//
//  Created by chenzhipeng on 15/5/8.
//  Copyright (c) 2015年 chenzhipeng. All rights reserved.
//

#import "ExButton.h"

@implementation ExButton

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        isPlay = YES;
        playImage = [UIImage imageNamed:@"play_start"];
        pauseImage = [UIImage imageNamed:@"play_pause"];
    }
    return self;
}

-(void)changePlayStatus
{
    isPlay  = !isPlay;
    [self setImage:isPlay?pauseImage:playImage forState:UIControlStateNormal];
}

-(void)changePlayStyle:(BOOL)toPlay
{
    isPlay = toPlay;
    [self setImage:isPlay?pauseImage:playImage forState:UIControlStateNormal];
}

-(BOOL)isPlaying
{
    return isPlay;
}

@end
