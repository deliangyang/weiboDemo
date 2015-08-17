//
//  JKStatusPhotosView.h
//  微博demo
//
//  Created by 史江凯 on 15/7/6.
//  Copyright (c) 2015年 史江凯. All rights reserved.
//  存放着配图的容器，整体

#import <UIKit/UIKit.h>

@interface JKStatusPhotosView : UIView

/**数组里存的是JKPhoto模型*/
@property (nonatomic, strong) NSArray *photos;

+ (CGSize)photosSizeWithCount:(NSUInteger)count;
@end
