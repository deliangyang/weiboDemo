//
//  JKStatus.m
//  微博demo
//
//  Created by 史江凯 on 15/7/3.
//  Copyright (c) 2015年 史江凯. All rights reserved.
//  

#import "JKStatus.h"
#import "JKUser.h"
#import "MJExtension.h"
#import "JKPhoto.h"
#import "RegexKitLite.h"
#import "JKTextPart.h"
#import "JKEmotion.h"
#import "JKEmotionTool.h"
#import "JKSpecialText.h"

@implementation JKStatus

/*普通文字转成带有属性的文字*/
- (NSMutableAttributedString *)attributedTextWithText:(NSString *)text
{
    NSMutableAttributedString *attrbutedText = [[NSMutableAttributedString alloc] init];
    // 表情的规则
    NSString *emotionPattern = @"\\[[0-9a-zA-Z\\u4e00-\\u9fa5]+\\]";
    // @的规则
    NSString *atPattern = @"@[0-9a-zA-Z\\u4e00-\\u9fa5-_]+";
    // #话题#的规则
    NSString *topicPattern = @"#[0-9a-zA-Z\\u4e00-\\u9fa5]+#";
    // url链接的规则
    NSString *urlPattern = @"\\b(([\\w-]+://?|www[.])[^\\s()<>]+(?:\\([\\w\\d]+\\)|([^[:punct:]\\s]|/)))";
    NSString *pattern = [NSString stringWithFormat:@"%@|%@|%@|%@", emotionPattern, atPattern, topicPattern, urlPattern];

    NSMutableArray *parts = [NSMutableArray array];
    //遍历特殊文字，存进parts数组
    [text enumerateStringsMatchedByRegex:pattern usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        if ((*capturedRanges).length) {
            JKTextPart *part = [[JKTextPart alloc] init];
            part.special = YES;
            part.text = *capturedStrings;
            part.emotion = [part.text hasPrefix:@"["] && [part.text hasSuffix:@"]"];
            part.range = *capturedRanges;
            [parts addObject:part];
        }
    }];

    //遍历普通文字，存进parts数组
    [text enumerateStringsSeparatedByRegex:pattern usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        if ((*capturedRanges).length) {
            JKTextPart *part = [[JKTextPart alloc] init];
            part.text = *capturedStrings;
            part.range = *capturedRanges;
            [parts addObject:part];
        }
    }];
    
    //parts数组排序
    [parts sortUsingComparator:^NSComparisonResult(JKTextPart *part1, JKTextPart *part2) {
        return part1.range.location < part2.range.location ? NSOrderedAscending : NSOrderedDescending;
    }];

    UIFont *font = [UIFont systemFontOfSize:15];
    NSMutableArray *specials = [NSMutableArray array];
    //遍历数组
    for (JKTextPart *part in parts) {
        NSAttributedString *subStr = nil;
        if (part.isEmotion) {//是表情，先看表情对应的图片是否存在
            NSString *png = [JKEmotionTool emotionWithChs:part.text].png;
            if (png) {
                NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
                attachment.image = [UIImage imageNamed:png];
                attachment.bounds = CGRectMake(0, -3, font.lineHeight, font.lineHeight);
                subStr = [NSAttributedString attributedStringWithAttachment:attachment];
            } else {//是表情，但没有表情图片能对应这段文字，把它当做普通文字显示
                subStr = [[NSAttributedString alloc] initWithString:part.text];
            }
        } else if (part.isSpecial) {//非表情的特殊文字
            subStr = [[NSAttributedString alloc] initWithString:part.text attributes:@{ NSForegroundColorAttributeName : [UIColor blueColor]}];
            JKSpecialText *specialText = [[JKSpecialText alloc] init];
            specialText.text = part.text;
            specialText.range = NSMakeRange(attrbutedText.length, part.text.length);
            [specials addObject:specialText];
        } else {//是普通文字
            subStr = [[NSAttributedString alloc] initWithString:part.text];
        }
        [attrbutedText appendAttributedString:subStr];
    }

    [attrbutedText addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, attrbutedText.length)];
    //把特殊字符串数组当作第一个字的属性存起来，以便利用
    [attrbutedText addAttribute:@"specials" value:specials range:NSMakeRange(0, 1)];
    return attrbutedText;
}

- (void)setText:(NSString *)text
{
    _text = [text copy];
    //利用text生成attributedText
    self.attributedText = [self attributedTextWithText:text];
}

- (void)setRetweeted_status:(JKStatus *)retweeted_status
{
    _retweeted_status = retweeted_status;

    //拼接转发微博的正文＋昵称
    NSString *retweetContent = [NSString stringWithFormat:@"@%@ : %@", retweeted_status.user.name, retweeted_status.text];
    self.retweetedAttributedText = [self attributedTextWithText:retweetContent];
}

- (NSDictionary *)objectClassInArray
{
    return @{@"pic_urls" : [JKPhoto class]};
}

//重写created_at的getter方法，以便返回各种格式的微博发表时间，@“刚刚”，X分钟前，x小时前，昨天xx：xx，yyyy－MM－dd xx：xx
//tableView滚动时，会持续调用getter方法，所以时间格式会一直更新
- (NSString *)created_at
{
    //Thu Oct 16 17:06:07 +0800 2014
    //EEE MMM dd HH:mm:ss Z yyyy
    
    //从_created_at得到NSDate类型的时间
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];//真机要指定locale
    dateFormatter.dateFormat = @"EEE MMM dd HH:mm:ss Z yyyy";
    NSDate *createdDate = [dateFormatter dateFromString:_created_at];
    
    //日历对象，以比较两个NSDate对象的差距
    NSCalendar *calender = [NSCalendar currentCalendar];
    //指定日历单元，以获得单位，多少年，月，日，时，分，秒
    NSCalendarUnit unit =  NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour |    NSCalendarUnitMinute | NSCalendarUnitSecond;
//    NSDateComponents *createdTimeCmp = [calender components:unit fromDate:createdTime];
//    NSDateComponents *currentTimeCmp = [calender components:unit fromDate:[NSDate date]];

    //计算两个日期之间的差距
    NSDateComponents *dateComponents = [calender components:unit fromDate:createdDate toDate:[NSDate date] options:0];
    //dateComponents.year为0，不一定表示两个时间都在同一年，只是差距少于12个月

    if ([createdDate isThisYear]) { // 今年
        if ([createdDate isYesterday]) { // 昨天
            dateFormatter.dateFormat = @"昨天 HH:mm";
            return [dateFormatter stringFromDate:createdDate];
        } else if ([createdDate isToday]) { // 今天
            if (dateComponents.hour >= 1) {
                return [NSString stringWithFormat:@"%d小时前", (int)dateComponents.hour];
            } else if (dateComponents.minute >= 1) {
                return [NSString stringWithFormat:@"%d分钟前", (int)dateComponents.minute];
            } else {
                return @"刚刚";
            }
        } else { // 今年的其他日子
            dateFormatter.dateFormat = @"MM-dd HH:mm";
            return [dateFormatter stringFromDate:createdDate];
        }
    } else { // 非今年
        dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
        return [dateFormatter stringFromDate:createdDate];
    }
}

//重写source的setter方法，处理服务器返回的<a>标签字符串
//传入对应模型仅会调用一次，tableView滚动时，不会一直调用（’来源‘不用更新）
- (void)setSource:(NSString *)source
{
    //<a href="http://app.weibo.com/t/feed/62N3i" rel="nofollow">冷笑话精选</a>
    if (source.length) {//来源是否存在
        NSRange range;
        //找到第一个'>'后的字符的位置
        range.location = [source rangeOfString:@">"].location + 1;
        //有效字符末尾的位置，减去开头位置，就是它的长度
        range.length = [source rangeOfString:@"</" options:NSBackwardsSearch].location - range.location;
        //根据range，截取有效字符串，拼接
        _source = [NSString stringWithFormat:@"来自%@", [source substringWithRange:range]];
    } else {
        _source = @"来自新浪微博";
    }
}

@end
