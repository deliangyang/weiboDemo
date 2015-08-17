//
//  JKAccount.h
//  微博demo
//
//  Created by 史江凯 on 15/7/3.
//  Copyright (c) 2015年 史江凯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JKAccount : NSObject <NSCoding>

/**授权成功后的access token*/
@property (nonatomic, copy) NSString *access_token;

/**access token的有效时间*/
@property (nonatomic, copy) NSString *expires_in;

/**当前授权用户的UID*/
@property (nonatomic, copy) NSString *uid;

/**access_token的创建时间*/
@property (nonatomic, strong) NSDate *created_time;

/**用户昵称*/
@property (nonatomic, copy) NSString *name;

+ (instancetype)accountWithDict:(NSDictionary *)dict;

@end
