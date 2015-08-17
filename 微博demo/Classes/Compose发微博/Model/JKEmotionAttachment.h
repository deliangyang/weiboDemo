//
//  JKEmotionAttachment.h
//  微博demo
//
//  Created by 史江凯 on 15/7/12.
//  Copyright (c) 2015年 史江凯. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JKEmotion;
@interface JKEmotionAttachment : NSTextAttachment

//为了能通过JKEmotionAttachment拿到对应的表情，一个JKEmotionAttachment对应一个JKEmotion
@property (nonatomic, strong) JKEmotion *emotion;
@end
