//
//  ExImageView.m
//  DBFM
//
//  Created by chenzhipeng on 15/5/6.
//  Copyright (c) 2015年 chenzhipeng. All rights reserved.
//

#import "ExImageView.h"
#define ViewAnimaRotation (@"paly_rotation")
@implementation ExImageView

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        // 设置视图为圆形
        self.clipsToBounds = YES;
        self.layer.cornerRadius = self.frame.size.width/2;
        
        // 设置视图边框样式
        self.layer.borderColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.7].CGColor;
        self.layer.borderWidth = 4;
    }
    return self;
}

-(void)startRotation
{
    // 定义旋转动画
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    // 开始角度
    animation.fromValue = [NSNumber numberWithFloat:0];
    // 结束角度
    animation.toValue = [NSNumber numberWithFloat:M_PI*2.0];
    // 执行时间
    animation.duration = 10;
    // 循环次数
    animation.repeatCount = 10000;
    
    // 添加动画到视图
    [self.layer addAnimation:animation forKey:ViewAnimaRotation];
}

-(void)stopRotation
{
    [self.layer removeAnimationForKey:ViewAnimaRotation];
}
@end
