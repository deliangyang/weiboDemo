//
//  JKDropDownMenu.h
//  微博demo
//
//  Created by 史江凯 on 15/7/1.
//  Copyright (c) 2015年 史江凯. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JKDropDownMenu;

@protocol JKDropDownMenuDelegate <NSObject>

@optional
//下拉菜单已经显示
- (void)didShowDropDownMenu:(JKDropDownMenu *)dropDownMenu;
//下拉菜单已经消失
- (void)didDismissDropDownMenu:(JKDropDownMenu *)dropDownMenu;
@end

@interface JKDropDownMenu : UIView

//下拉菜单容器，一般是一张图片
@property (nonatomic, weak) UIImageView *containerView;
//弹出的下拉菜单要显示的内容
@property (nonatomic, strong) UIView *content;
//内容控制器
@property (nonatomic, strong) UIViewController *contentController;

@property (nonatomic, weak) id <JKDropDownMenuDelegate> delegate;

+ (instancetype)menu;
- (void)showFrom:(UIView *)from;
- (void)dismiss;
@end
