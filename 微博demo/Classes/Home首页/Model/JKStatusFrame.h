//
//  JKStatusFrame.h
//  微博demo
//
//  Created by 史江凯 on 15/7/4.
//  Copyright (c) 2015年 史江凯. All rights reserved.
//
//  JKStatusFrame模型包含了以下信息
//  1.内部所有子控件的frame数据
//  2.一个cell的高度
//  3.一个数据模型JKStatus

#import <Foundation/Foundation.h>

#define kNameLabelFont [UIFont systemFontOfSize:15]
#define kTimeLabelFont [UIFont systemFontOfSize:12]
#define kSourceLabelFont kTimeLabelFont
#define kContentLabelFont [UIFont systemFontOfSize:14]
#define kRetweetLabelFont [UIFont systemFontOfSize:13]
#define kStatusCellMargin 15

//cell的边框宽度
#define kStatusCellBorderW 10

@class JKStatus;

@interface JKStatusFrame : NSObject

/**微博数据模型*/
@property (nonatomic, strong) JKStatus *status;

/**原创微博，作为一个整体（容器）   */
@property (nonatomic, assign) CGRect originalFrame;
/**头像   */
@property (nonatomic, assign) CGRect iconFrame;
/**会员图标   */
@property (nonatomic, assign) CGRect vipFrame;
/**配图   */
@property (nonatomic, assign) CGRect photosFrame;
/**用户昵称*/
@property (nonatomic, assign) CGRect nameFrame;
/**时间*/
@property (nonatomic, assign) CGRect timeFrame;
/**来源*/
@property (nonatomic, assign) CGRect sourceFrame;
/**微博正文*/
@property (nonatomic, assign) CGRect contentFrame;

/**转发微博，作为一个整体（容器）   */
@property (nonatomic, assign) CGRect retweetViewFrame;
/**转发微博正文＋昵称*/
@property (nonatomic, assign) CGRect retweetContentLabelFrame;
/**转发微博里的配图   */
@property (nonatomic, assign) CGRect retweetPhotosViewFrame;

/**转发，评论，赞三合一工具条*/
@property (nonatomic, assign) CGRect toolbarFrame;

/**cell的高度*/
@property (nonatomic, assign) CGFloat cellHeight;
@end
