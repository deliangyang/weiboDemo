//
//  JKStatusTool.m
//  微博demo
//
//  Created by 史江凯 on 15/7/19.
//  Copyright (c) 2015年 史江凯. All rights reserved.
//

#import "JKStatusTool.h"
#import "FMDB.h"

static FMDatabase *_db;

@implementation JKStatusTool

+ (void)initialize
{
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"statuses.sqlite"];
    //NSLog(@"%@", filePath);
    
    //打开数据库
    _db = [FMDatabase databaseWithPath:filePath];
    [_db open];
    
    //建表
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_status (id integer PRIMARY KEY, status blob NOT NULL, idstr text NOT NULL);"];
}

+ (NSArray *)statusesWithParams:(NSDictionary *)params
{
    NSString *sql = nil;
    if (params[@"since_id"]) {
        sql = [NSString stringWithFormat:@"SELECT * FROM t_status WHERE idstr > %@ ORDER BY idstr DESC LIMIT 20;", params[@"since_id"]];
    } else if (params[@"max_id"]){
        sql = [NSString stringWithFormat:@"SELECT * FROM t_status WHERE idstr <= %@ ORDER BY idstr DESC LIMIT 20;", params[@"max_id"]];
        
    } else {
        sql = @"SELECT * FROM t_status ORDER BY idstr DESC LIMIT 20;";
    }
    FMResultSet *set = [_db executeQuery:sql];
    NSMutableArray *statuses = [NSMutableArray array];
    while (set.next) {
        //status字段取出来的是NSData
        NSData *statusData = [set objectForColumnName:@"status"];
        //再转成字典
        NSDictionary *status = [NSKeyedUnarchiver unarchiveObjectWithData:statusData];
        
        [statuses addObject:status];
    }
    return statuses;
}

+ (void)saveStatuses:(NSArray *)statuses
{
    //将一个对象（要实现NSCoding协议）存进数据库的blob类型的字段，要先转为NSData
    for (NSDictionary *status in statuses) {
        //字典转为NSData
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:status];
        //status字段为blob类型
        [_db executeUpdateWithFormat:@"INSERT INTO t_status (status, idstr) VALUES (%@, %@);", data, status[@"idstr"]];
    }
}

@end
