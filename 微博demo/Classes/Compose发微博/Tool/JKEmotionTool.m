//
//  JKEmotionTool.m
//  微博demo
//
//  Created by 史江凯 on 15/7/13.
//  Copyright (c) 2015年 史江凯. All rights reserved.
//
#define JKRecentEmotionsFilePath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"RecentEmotions.data"]

#import "JKEmotionTool.h"
#import "JKEmotion.h"
#import "MJExtension.h"
@implementation JKEmotionTool

static NSMutableArray *_recentEmotion;
static NSArray *_defaultEmotions, *_emojiEmotions, *_lxhEmotions;

//只在第一次使用这类的时候调用一次
+ (void)initialize
{
    _recentEmotion = [NSKeyedUnarchiver unarchiveObjectWithFile:JKRecentEmotionsFilePath];
    if (!_recentEmotion) {
        _recentEmotion = [NSMutableArray array];
    }
    if (!_defaultEmotions) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"EmotionIcons/default/info.plist" ofType:nil];
        NSArray *array = [NSArray arrayWithContentsOfFile:path];
        _defaultEmotions = [JKEmotion objectArrayWithKeyValuesArray:array];
    }
    if (!_emojiEmotions) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"EmotionIcons/emoji/info.plist" ofType:nil];
        NSArray *array = [NSArray arrayWithContentsOfFile:path];
        _emojiEmotions = [JKEmotion objectArrayWithKeyValuesArray:array];
    }
    if (!_lxhEmotions) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"EmotionIcons/lxh/info.plist" ofType:nil];
        NSArray *array = [NSArray arrayWithContentsOfFile:path];
        _lxhEmotions = [JKEmotion objectArrayWithKeyValuesArray:array];
    }
}

+ (JKEmotion *)emotionWithChs:(NSString *)chs
{
    //遍历默认表情
    for (JKEmotion *emotion in _defaultEmotions) {
        if ([emotion.chs isEqualToString:chs]) {
            return emotion;
        }
    }
    //遍历浪小花表情    
    for (JKEmotion *emotion in _lxhEmotions) {
        if ([emotion.chs isEqualToString:chs]) {
            return emotion;
        }
    }
    return nil;
}

+ (void)addRecentEmotion:(JKEmotion *)emotion
{

//删除重复的表情
//    for (JKEmotion *emotionExisting in emotionsArray) {
//        if ([emotionExisting.chs isEqualToString:emotion.chs]) {
//            [emotionsArray removeObject:emotionExisting];
//            break;
//        }
//    }
    //删除重复的表情，重写了JKEmotion的isEqual:方法，不再比较地址，而是比较字符串，因此可以直接删除（如果表情存在的话）
    [_recentEmotion removeObject:emotion];
    //把表情插在第一个
    [_recentEmotion insertObject:emotion atIndex:0];
    //把最近表情的数组归档到沙盒
    [NSKeyedArchiver archiveRootObject:_recentEmotion toFile:JKRecentEmotionsFilePath];
}

+ (NSArray *)recentEmotions
{
    //从沙盒中解码最近表情的数组
    return _recentEmotion;
}

/**默认表情的数组*/
+ (NSArray *)defaultEmotions
{
    return _defaultEmotions;
}

/**emoji的数组*/
+ (NSArray *)emojiEmotions
{
    return _emojiEmotions;
}

/**浪小花表情的数组*/
+ (NSArray *)lxhEmotions
{
    return _lxhEmotions;
}

@end
