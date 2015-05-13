//
//  ExButton.h
//  DBFM
//
//  Created by chenzhipeng on 15/5/8.
//  Copyright (c) 2015年 chenzhipeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExButton : UIButton
{
    BOOL isPlay;
    UIImage *playImage;
    UIImage *pauseImage;
}

-(BOOL)isPlaying;
-(void)changePlayStatus;
-(void)changePlayStyle:(BOOL)toPlay;
@end
