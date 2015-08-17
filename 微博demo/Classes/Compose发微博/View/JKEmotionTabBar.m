//
//  JKEmotionTabBar.m
//  微博demo
//
//  Created by 史江凯 on 15/7/8.
//  Copyright (c) 2015年 史江凯. All rights reserved.
//

#import "JKEmotionTabBar.h"
#import "JKEmotionTabBarButton.h"

@interface JKEmotionTabBar ()

@property (nonatomic, weak) JKEmotionTabBarButton *selectedBtn;

@end

@implementation JKEmotionTabBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //初始化四个按钮
        [self setupBtn:@"最近" type:JKEmotionTabBarButtonTypeRecent];
        [self setupBtn:@"默认" type:JKEmotionTabBarButtonTypeDefault];
        [self setupBtn:@"Emoji" type:JKEmotionTabBarButtonTypeEmoji];
        [self setupBtn:@"浪小花" type:JKEmotionTabBarButtonTypeLxh];
    }
    return self;
}

//初始化四个按钮
- (JKEmotionTabBarButton *)setupBtn:(NSString *)title type:(JKEmotionTabBarButtonType)type
{
    JKEmotionTabBarButton *btn = [[JKEmotionTabBarButton alloc] init];
    btn.tag = type;
    //让‘默认按钮‘是选中状态，这里并不能弹出表情键盘，因为delegate值为空，要改写setDelegate：方法
//    if (type == JKEmotionTabBarButtonTypeDefault) {
//        [self btnClick:btn];
//    }
    [btn setTitle:title forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:btn];
   
    //第二，第三个按钮的图片和高亮图片，另外设置了高亮时按钮不再响应点击
    NSString *image = @"compose_emotion_table_mid_normal";
    NSString *highImage = @"compose_emotion_table_mid_selected";
    
    if (self.subviews.count == 1) {//第一个按钮
        image = @"compose_emotion_table_left_normal";
        highImage = @"compose_emotion_table_left_selected";
        
    } else if (self.subviews.count == 4) {//第四个按钮
        image = @"compose_emotion_table_right_normal";
        highImage = @"compose_emotion_table_right_selected";
    }
    [btn setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:highImage] forState:UIControlStateDisabled];

    return btn;
}

- (void)setDelegate:(id<JKEmotionTabBarDelegate>)delegate
{
    _delegate = delegate;
    //拿到‘默认按钮’，从而弹出表情键盘时，就点击了一次‘默认按钮’
    JKEmotionTabBarButton *btn = (JKEmotionTabBarButton *)[self viewWithTag:JKEmotionTabBarButtonTypeDefault];
    [self btnClick:btn];
}

//只高亮当前选中的按钮，并且高亮的按钮不能在响应点击，
- (void)btnClick:(JKEmotionTabBarButton *)btn
{
    self.selectedBtn.enabled = YES;
    btn.enabled = NO;
    self.selectedBtn = btn;
    if ([self.delegate respondsToSelector:@selector(emotionTabBar:didClickBtnofType:)]) {
        [self.delegate emotionTabBar:self didClickBtnofType:btn.tag];
    }
}

//布局子控件（四个按钮），和JKStatusCellToolbar里的layoutSubviews相似
- (void)layoutSubviews
{
    [super layoutSubviews];
    NSUInteger btnCount = self.subviews.count;
    CGFloat btnW = self.width / btnCount;
    CGFloat btnH = self.height;
    for (int i = 0; i < btnCount; i++) {
        JKEmotionTabBarButton *btn = self.subviews[i];
        btn.x = i * btnW;
        btn.y = 0;
        btn.width = btnW;
        btn.height = btnH;
    }
}

@end
