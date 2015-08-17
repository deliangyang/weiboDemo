//
//  JKEmotionTextView.h
//  微博demo
//
//  Created by 史江凯 on 15/7/11.
//  Copyright (c) 2015年 史江凯. All rights reserved.
//

#import "JKTextView.h"
@class JKEmotion;
@interface JKEmotionTextView : JKTextView

//插入表情
- (void)insertEmotion:(JKEmotion *)emotion;

- (NSString *)fullText;
@end
