//
//  JKUser.h
//  微博demo
//
//  Created by 史江凯 on 15/7/3.
//  Copyright (c) 2015年 史江凯. All rights reserved.
//  用户模型

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    JKUserVerifiedTypeNone = -1,         //没有认证
    JKUserVerifiedTypePersonal = 0,      //个人认证
    JKUserVerifiedTypeOrgEnterprice = 2, //企业认证
    JKUserVerifiedTypeOrgMedia = 3,      //媒体官方
    JKUserVerifiedTypeOrgWebsite = 5,    //网站官方
    JKUserVerifiedTypeDaren = 220        //微博达人
} JKUserVerifiedType;

@interface JKUser : NSObject
/**字符串型的用户UID*/
@property (nonatomic, copy) NSString *idstr;
/**友好显示名称*/
@property (nonatomic, copy) NSString *name;
/**用户头像地址，50*50像素*/
@property (nonatomic, copy) NSString *profile_image_url;
/**会员类型 》 2 是会员*/
@property (nonatomic, assign) int mbType;
/**会员等级*/
@property (nonatomic, assign) int mbRank;

@property (nonatomic, assign, getter = isVip) BOOL vip;

/**认证类型*/
@property (nonatomic, assign) JKUserVerifiedType verifiedType;
@end
