//
//  JKStatusTool.h
//  微博demo
//
//  Created by 史江凯 on 15/7/19.
//  Copyright (c) 2015年 史江凯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JKStatusTool : NSObject

/**从本地缓存中加载微博数据*/
+ (NSArray *)statusesWithParams:(NSDictionary *)params;

/**把微博数据存到数据库*/
+ (void)saveStatuses:(NSArray *)statuses;
@end
