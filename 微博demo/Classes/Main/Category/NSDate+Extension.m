//
//  NSDate+Extension.m
//  微博demo
//
//  Created by 史江凯 on 15/7/6.
//  Copyright (c) 2015年 史江凯. All rights reserved.
//

#import "NSDate+Extension.h"

@implementation NSDate (Extension)

- (BOOL)isThisYear
{
    NSCalendar *calender = [NSCalendar currentCalendar];

    //指定日历单元，以获得xxxx年
    NSCalendarUnit unit =  NSCalendarUnitYear;
    
    NSDateComponents *createdTimeCmp = [calender components:unit fromDate:self];
    
    //当前时刻的年份
    NSDateComponents *currentTimeCmp = [calender components:unit fromDate:[NSDate date]];
    
    return createdTimeCmp.year == currentTimeCmp.year;
}

- (BOOL)isYesterday
{

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];//真机要指定locale
    dateFormatter.dateFormat = @"yyyy-MM-dd";

    //将自己的日期格式只保留年月日
    NSString *dateString = [dateFormatter stringFromDate:self];
    //将当前时间的日期格式只保留年月日
    NSString *currentDateString = [dateFormatter stringFromDate:[NSDate date]];
    
    //再转成年月日的NSDate 时分秒都是00:00:00
    NSDate *date = [dateFormatter dateFromString:dateString];
    NSDate *currentDate = [dateFormatter dateFromString:currentDateString];
    
    //日历对象，以比较两个NSDate对象的差距
    NSCalendar *calender = [NSCalendar currentCalendar];
    //指定日历单元，以获得单位，多少年，月，日
    NSCalendarUnit unit =  NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;

    NSDateComponents *cmp = [calender components:unit fromDate:date toDate:currentDate options:0];
    
    return cmp.year == 0 && cmp.month == 0 && cmp.day ==1;
}

- (BOOL)isToday
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];//真机要指定locale
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    
    //将自己的日期格式只保留年月日
    NSString *dateString = [dateFormatter stringFromDate:self];
    //将当前时间的日期格式只保留年月日
    NSString *currentDateString = [dateFormatter stringFromDate:[NSDate date]];
    
    return [dateString isEqualToString:currentDateString];
}

@end
