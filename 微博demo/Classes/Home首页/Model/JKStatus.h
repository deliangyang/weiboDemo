//
//  JKStatus.h
//  微博demo
//
//  Created by 史江凯 on 15/7/3.
//  Copyright (c) 2015年 史江凯. All rights reserved.
//  微博模型

#import <Foundation/Foundation.h>
@class JKUser;

@interface JKStatus : NSObject

/**字符串型的微博ID*/
@property (nonatomic, copy) NSString *idstr;

/**微博正文信息内容*/
@property (nonatomic, copy) NSString *text;

/**微博正文，带有属性的文字(特殊文字会高亮显示，显示表情)*/
@property (nonatomic, copy) NSAttributedString *attributedText;

/**微博作者user模型*/
@property (nonatomic, strong) JKUser *user;

/**微博发布时间*/
@property (nonatomic, copy) NSString *created_at;

/**微博来源 */
@property (nonatomic, copy) NSString *source;

/**微博配图地址的数组，数组里是JKPhoto模型，需要实现MJExtension的objectClassInArray方法*/
@property (nonatomic, strong) NSArray *pic_urls;

/**转发微博模型*/
@property (nonatomic, strong) JKStatus *retweeted_status;

/**转发微博正文，带有属性的文字*/
@property (nonatomic, copy) NSAttributedString *retweetedAttributedText;

/**转发数*/
@property (nonatomic, assign) int reposts_count;

/**评论数*/
@property (nonatomic, assign) int comments_count;

/**赞数，（表态数）*/
@property (nonatomic, assign) int attitudes_count;
@end
