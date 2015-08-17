//
//  JKStatusCellToolbar.h
//  微博demo
//
//  Created by 史江凯 on 15/7/5.
//  Copyright (c) 2015年 史江凯. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JKStatus;
@interface JKStatusCellToolbar : UIView

//需要用到微博模型设置toolbar的三个按钮
@property (nonatomic, strong) JKStatus *status;

+ (instancetype)toolbar;
@end
