//
//  JKEmotionTool.h
//  微博demo
//
//  Created by 史江凯 on 15/7/13.
//  Copyright (c) 2015年 史江凯. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JKEmotion;
@interface JKEmotionTool : NSObject

/**把最近表情的数组归档到沙盒*/
+ (void)addRecentEmotion:(JKEmotion *)emotion;

/**从沙盒中解码最近表情的数组*/
+ (NSArray *)recentEmotions;

/**默认表情的数组*/
+ (NSArray *)defaultEmotions;

/**emoji的数组*/
+ (NSArray *)emojiEmotions;

/**浪小花表情的数组*/
+ (NSArray *)lxhEmotions;

/**通过表情的文字描述获得对应表情*/
+ (JKEmotion *)emotionWithChs:(NSString *)chs;
@end
