//
//  JKEmotionPopView.m
//  微博demo
//
//  Created by 史江凯 on 15/7/10.
//  Copyright (c) 2015年 史江凯. All rights reserved.
//

#import "JKEmotionPopView.h"
#import "JKEmotion.h"
#import "JKEmotionButton.h"

@interface JKEmotionPopView ()

@end

@implementation JKEmotionPopView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (instancetype)popView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"JKEmotionPopView" owner:nil options:nil] lastObject];
}

- (void)showFrom:(JKEmotionButton *)btn
{
    if (!btn)   return;//btn为空，直接返回，不添加popView
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    [window addSubview:self];
    self.emotionButton.emotion = btn.emotion;
    CGRect convertedFrame = [btn convertRect:btn.bounds toView:window];
    self.centerX = CGRectGetMidX(convertedFrame);
    self.y = CGRectGetMidY(convertedFrame) - self.height;
}

@end
