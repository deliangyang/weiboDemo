//
//  JKTextPart.h
//  微博demo
//
//  Created by 史江凯 on 15/7/17.
//  Copyright (c) 2015年 史江凯. All rights reserved.
//  组成正文的部分文字

#import <Foundation/Foundation.h>

@interface JKTextPart : NSObject
/**这段部分文字的内容*/
@property (nonatomic, copy) NSString *text;
/**这段部分文字的范围*/
@property (nonatomic, assign) NSRange range;
/**是否是特殊文字 */
@property (nonatomic, assign, getter = isSpecial) BOOL special;
/**是否是表情 */
@property (nonatomic, assign, getter = isEmotion) BOOL emotion;
@end
