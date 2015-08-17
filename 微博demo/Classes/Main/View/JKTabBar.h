//
//  JKTabBar.h
//  微博demo
//
//  Created by 史江凯 on 15/7/1.
//  Copyright (c) 2015年 史江凯. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JKTabBar;
@protocol JKTabBarDelegate <UITabBarDelegate>

@optional
- (void)didClickPlusButtonInTabBar:(JKTabBar *)tabBar;
@end

@interface JKTabBar : UITabBar

@property (nonatomic, weak) id <JKTabBarDelegate> delegate;

@end


