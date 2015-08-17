//
//  JKTextView.h
//  微博demo
//
//  Created by 史江凯 on 15/7/7.
//  Copyright (c) 2015年 史江凯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JKTextView : UITextView

//占位文本
@property (nonatomic, copy) NSString *placeholder;

//占位文本的颜色
@property (nonatomic, strong) UIColor *placeholderColor;
@end
