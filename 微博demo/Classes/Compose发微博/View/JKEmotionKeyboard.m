//
//  JKEmotionKeyboard.m
//  微博demo
//
//  Created by 史江凯 on 15/7/8.
//  Copyright (c) 2015年 史江凯. All rights reserved.
//

#import "JKEmotionKeyboard.h"
#import "JKEmotionTabBar.h"
#import "JKEmotionListView.h"
#import "JKEmotion.h"
#import "MJExtension.h"
#import "JKEmotionTool.h"

@interface JKEmotionKeyboard () <JKEmotionTabBarDelegate>

@property (nonatomic, weak) JKEmotionTabBar *emotionTabBar;

//当前正在显示的表情键盘
@property (nonatomic, weak) JKEmotionListView *showingListView;

//四类表情键盘
@property (nonatomic, strong) JKEmotionListView *recentListView;
@property (nonatomic, strong) JKEmotionListView *defaultListView;
@property (nonatomic, strong) JKEmotionListView *emojiListView;
@property (nonatomic, strong) JKEmotionListView *lxhListView;


@end

@implementation JKEmotionKeyboard

//四类表情键盘的懒加载
- (JKEmotionListView *)recentListView
{
    if (!_recentListView) {
        self.recentListView = [[JKEmotionListView alloc] init];
        self.recentListView.emotions = [JKEmotionTool recentEmotions];
    }
    return _recentListView;
}

- (JKEmotionListView *)defaultListView
{
    if (!_defaultListView) {
        self.defaultListView = [[JKEmotionListView alloc] init];
        self.defaultListView.emotions = [JKEmotionTool defaultEmotions];
    }
    return _defaultListView;
}

- (JKEmotionListView *)emojiListView
{
    if (!_emojiListView) {
        self.emojiListView = [[JKEmotionListView alloc] init];
        self.emojiListView.emotions = [JKEmotionTool emojiEmotions];
    }
    return _emojiListView;
}

- (JKEmotionListView *)lxhListView
{
    if (!_lxhListView) {
        self.lxhListView = [[JKEmotionListView alloc] init];
        self.lxhListView.emotions = [JKEmotionTool lxhEmotions];
    }
    return _lxhListView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        JKEmotionTabBar *emotionTabBar = [[JKEmotionTabBar alloc] init];
        [self addSubview:emotionTabBar];
        self.emotionTabBar = emotionTabBar;
        self.emotionTabBar.delegate = self;
        
        //监听选中表情时的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emotionDidSelect) name:JKEmotionDidSelectNotification object:nil];
    }
    return self;
}

- (void)emotionDidSelect
{
    //选中表情时，再设置一次最近表情的数组，等于实时刷新
    self.recentListView.emotions = [JKEmotionTool recentEmotions];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.emotionTabBar.width = self.width;
    self.emotionTabBar.height = 37;
    self.emotionTabBar.x = 0;
    self.emotionTabBar.y = self.height - self.emotionTabBar.height;
    
    self.showingListView.width = self.width;
    self.showingListView.height = self.emotionTabBar.y;
    self.showingListView.x = 0;
    self.showingListView.y = 0;
}

//切换不同的表情
- (void)emotionTabBar:(JKEmotionTabBar *)JKEmotionTabBar didClickBtnofType:(JKEmotionTabBarButtonType)type
{
    //先移除当前显示的表情键盘
    [self.showingListView removeFromSuperview];
    switch (type) {

        case JKEmotionTabBarButtonTypeRecent:
            [self addSubview: self.recentListView];
            break;
        
        case JKEmotionTabBarButtonTypeDefault:
            [self addSubview: self.defaultListView];
            break;

        case JKEmotionTabBarButtonTypeEmoji:
            [self addSubview: self.emojiListView];
            break;

        case JKEmotionTabBarButtonTypeLxh:
            [self addSubview: self.lxhListView];
            break;
            
        default:
            break;
    }
    //切换后，将其记为当前的表情键盘
    self.showingListView = [self.subviews lastObject];
    //给它设置frame
    [self setNeedsLayout];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
