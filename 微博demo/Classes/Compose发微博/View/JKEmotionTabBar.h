//
//  JKEmotionTabBar.h
//  微博demo
//
//  Created by 史江凯 on 15/7/8.
//  Copyright (c) 2015年 史江凯. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    JKEmotionTabBarButtonTypeRecent,
    JKEmotionTabBarButtonTypeDefault,
    JKEmotionTabBarButtonTypeEmoji,
    JKEmotionTabBarButtonTypeLxh,
} JKEmotionTabBarButtonType;

@class JKEmotionTabBar;

@protocol JKEmotionTabBarDelegate <NSObject>

@optional
//让代理处理JKEmotionTabBar内自定义按钮的点击，即切换不同类型的表情
- (void)emotionTabBar:(JKEmotionTabBar *)JKEmotionTabBar didClickBtnofType:(JKEmotionTabBarButtonType)type;
@end

@interface JKEmotionTabBar : UIView
@property (nonatomic, weak) id <JKEmotionTabBarDelegate> delegate;
@end
