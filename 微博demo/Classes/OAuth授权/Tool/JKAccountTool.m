//
//  JKAccountTool.m
//  微博demo
//
//  Created by 史江凯 on 15/7/3.
//  Copyright (c) 2015年 史江凯. All rights reserved.
//

#define JKAccountFilePath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"account.data"]

#import "JKAccountTool.h"

@implementation JKAccountTool

+ (void)saveAccount:(JKAccount *)account
{
    //沙盒document路径，拼接文件名（利用宏），归档
    [NSKeyedArchiver archiveRootObject:account toFile:JKAccountFilePath];
}

+ (JKAccount *)account
{
    //从沙盒读取账号文件
    JKAccount *account =  [NSKeyedUnarchiver unarchiveObjectWithFile:JKAccountFilePath];

    //expires_in是一个间隔时间，指的是时长
    long long expires_in = [account.expires_in longLongValue];
    //过期时间，指的是某个时间点
    NSDate *expiersTime = [account.created_time dateByAddingTimeInterval:expires_in];

    NSDate *now = [NSDate date];
    
    if ([expiersTime compare:now] != NSOrderedDescending) {
        //过期时间在现在之前，或等于现在，表示账号已过期，返回nil
        return nil;
    }
    return account;
}

@end
