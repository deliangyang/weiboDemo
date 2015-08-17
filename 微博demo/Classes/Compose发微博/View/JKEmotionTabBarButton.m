//
//  JKEmotionTabBarButton.m
//  微博demo
//
//  Created by 史江凯 on 15/7/9.
//  Copyright (c) 2015年 史江凯. All rights reserved.
//  JKEmotionTabBar里用到的自定义button，默认设置了字体大小，两种状态下的字体颜色

#import "JKEmotionTabBarButton.h"

@implementation JKEmotionTabBarButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 默认设置了字体大小，两种状态下的字体颜色
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateDisabled];
        self.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted
{
//    高亮时什么都不做
}

@end
