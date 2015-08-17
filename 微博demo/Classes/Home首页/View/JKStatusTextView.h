//
//  JKStatusTextView.h
//  微博demo
//
//  Created by 史江凯 on 15/7/17.
//  Copyright (c) 2015年 史江凯. All rights reserved.

//  显示微博正文的textView

#import <UIKit/UIKit.h>

@interface JKStatusTextView : UITextView
/**所有的特殊字符（存放的JKSpecialText）*/
@property (nonatomic, strong) NSArray *specials;
@end
