//
//  JKAccountTool.h
//  微博demo
//
//  Created by 史江凯 on 15/7/3.
//  Copyright (c) 2015年 史江凯. All rights reserved.
//
//处理账号的相关操作，存取账号，验证账号

#import <Foundation/Foundation.h>
#import "JKAccount.h"

@interface JKAccountTool : NSObject

/**账号存进沙盒*/
+ (void)saveAccount:(JKAccount *)account;

/**从沙盒读取账号信息*/
+ (JKAccount *)account;
@end
