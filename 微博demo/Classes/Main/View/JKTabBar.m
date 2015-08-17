//
//  JKTabBar.m
//  微博demo
//
//  Created by 史江凯 on 15/7/1.
//  Copyright (c) 2015年 史江凯. All rights reserved.
//

#import "JKTabBar.h"

@interface JKTabBar()

@property (nonatomic, weak) UIButton *plusBtn;

@end

@implementation JKTabBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //tabBar正中间发微博的按钮
        UIButton *plusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //设置发微博按钮不同状态下的backgroundImage和image
        [plusBtn setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button"] forState:UIControlStateNormal];
        [plusBtn setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button_highlighted"] forState:UIControlStateSelected];
        [plusBtn setImage:[UIImage imageNamed:@"tabbar_compose_icon_add"] forState:UIControlStateNormal];
        [plusBtn setImage:[UIImage imageNamed:@"tabbar_compose_icon_add_highlighted"] forState:UIControlStateSelected];
        //设置发微博按钮的尺寸大小
        plusBtn.size = plusBtn.currentBackgroundImage.size;

        [plusBtn addTarget:self action:@selector(plusBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:plusBtn];
        self.plusBtn = plusBtn;
    }
    return self;
}

- (void)plusBtnClick
{
    if ([self.delegate respondsToSelector:@selector(didClickPlusButtonInTabBar:)]) {
        [self.delegate didClickPlusButtonInTabBar:(self)];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //设置发微博按钮的位置
    self.plusBtn.centerX = self.size.width * 0.5;
    self.plusBtn.centerY = self.size.height * 0.5;

    int tabBarButtonIndex = 0;
    for (UIView *child in self.subviews) {
        if ([child isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            //self.subviews有一个背景view，有一个分割线view，需要去掉，如果是UITabBarButton类型，需要重新layout
            child.width = self.width / (self.subviews.count - 2);
            child.x = tabBarButtonIndex * child.width;
            tabBarButtonIndex++;
        }
        //跳过发微博按钮
        if (tabBarButtonIndex == 2) {
            tabBarButtonIndex++;
        }
    }
}

@end
