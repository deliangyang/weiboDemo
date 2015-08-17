//
//  JKIconView.h
//  微博demo
//
//  Created by 史江凯 on 15/7/7.
//  Copyright (c) 2015年 史江凯. All rights reserved.
//  用户头像

#import <UIKit/UIKit.h>
@class JKUser;
@interface JKIconView : UIImageView
@property (nonatomic, strong) JKUser *user;
@end
