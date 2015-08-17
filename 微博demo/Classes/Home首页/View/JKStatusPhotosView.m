//
//  JKStatusPhotosView.m
//  微博demo
//
//  Created by 史江凯 on 15/7/6.
//  Copyright (c) 2015年 史江凯. All rights reserved.
//  cell里的配图，显示1-9张图片

#import "JKStatusPhotosView.h"
#import "JKPhoto.h"
#import "JKStatusPhotoView.h"

//微博配图里每一张图片的宽高
#define kStatusPhotoWH 50

//微博配图里图片之间的间距
#define kStatusPhotoMargin 10

//只有当count＝4的时候，maxCols才是2，是田字格排列
#define kStatusPhotosMaxCols(count) ((count == 4 ) ? 2: 3)

@implementation JKStatusPhotosView

+ (CGSize)photosSizeWithCount:(NSUInteger)count
{
    int maxCols = kStatusPhotosMaxCols(count);//只有当count＝4的时候，maxCols才是2，是田字格排列
    //大于3就是3列，小于3，count是1就1列，是2就2列
    NSUInteger cols = (count >= maxCols) ? maxCols : count;
    //(count + maxCols - 1) / maxCols 公式，计算行数
    NSUInteger rows = (count + maxCols - 1) / maxCols;
    CGFloat photosW = cols * kStatusPhotoWH + (cols - 1) * kStatusPhotoMargin;
    CGFloat photosH = rows * kStatusPhotoWH + (rows - 1) * kStatusPhotoMargin;
    return CGSizeMake(photosW, photosH);
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    NSUInteger count = photos.count;
    
    //先创建足够的图片控件，因为cell在循环利用，配图里的个数在变
    //self.subviews.count在while循环里会自增，不能用其他的临时变量代替
    while (self.subviews.count < photos.count) {
        JKStatusPhotoView *imageView = [[JKStatusPhotoView alloc] init];
        [self addSubview:imageView];
    }
    //给每个图片控件设置图片
    for (int i = 0; i<self.subviews.count; i++) {
        JKStatusPhotoView *photoView = self.subviews[i];
        if (i < count) {//需要显示，取出JKPhoto模型，根据对应的url设置图片
            photoView.photo = photos[i];
            photoView.hidden = NO;

        } else {//cell循环利用时，子控件数大于传进的配图个数，将多余的子控件隐藏
            photoView.hidden = YES;
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    //设置图片的尺寸和位置
    NSUInteger photosCount = self.photos.count;
    
    int maxCols = kStatusPhotosMaxCols(photosCount);//只有当count＝4的时候，maxCols才是2，是田字格排列
    
    for (int i = 0; i < photosCount; i++) {
        
        JKStatusPhotoView *photoView = self.subviews[i];
       
        photoView.width = kStatusPhotoWH;
        photoView.height = kStatusPhotoWH;
        //x对应的是列
        int col = i % maxCols;
        photoView.x = col * (kStatusPhotoWH + kStatusPhotoMargin);
        //y对应的是行
        int row = i / maxCols;
        photoView.y = row * (kStatusPhotoWH + kStatusPhotoMargin);
    }
}

@end
