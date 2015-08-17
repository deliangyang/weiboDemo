//
//  JKStatusPhotoView.h
//  微博demo
//
//  Created by 史江凯 on 15/7/6.
//  Copyright (c) 2015年 史江凯. All rights reserved.
//  微博配图里的最小单位（每一张配图）

#import <UIKit/UIKit.h>
@class JKPhoto;
@interface JKStatusPhotoView : UIImageView
/**JKPhoto模型*/
@property (nonatomic, strong) JKPhoto *photo;
@end
