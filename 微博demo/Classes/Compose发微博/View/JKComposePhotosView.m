//
//  JKComposePhotosView.m
//  微博demo
//
//  Created by 史江凯 on 15/7/8.
//  Copyright (c) 2015年 史江凯. All rights reserved.
//
#define kStatusPhotosMaxCols(count) ((count == 4 ) ? 2: 3)
#import "JKComposePhotosView.h"


@implementation JKComposePhotosView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _photos = [NSMutableArray array];
    }
    return self;
}

- (void)addPhoto:(UIImage *)image
{
    UIImageView *photoView = [[UIImageView alloc] initWithImage:image];
    [self addSubview:photoView];
    [self.photos addObject:image];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    //设置图片的尺寸和位置
    NSUInteger photosCount = self.subviews.count;
    
//    int maxCols = kStatusPhotosMaxCols(photosCount);//只有当count＝4的时候，maxCols才是2，是田字格排列
    int maxCols = 3;
    CGFloat imageWH = 70;
    CGFloat imageMargin = 10;
    for (int i = 0; i < photosCount; i++) {
        
        UIImageView *imageView = self.subviews[i];
        
        imageView.width = imageWH;
        imageView.height = imageWH;
        //x对应的是列
        int col = i % maxCols;
        imageView.x = col * (imageWH + imageMargin);
        //y对应的是行
        int row = i / maxCols;
        imageView.y = row * (imageWH + imageMargin);
    }
}

@end
