//
//  JKStatusPhotoView.m
//  微博demo
//
//  Created by 史江凯 on 15/7/6.
//  Copyright (c) 2015年 史江凯. All rights reserved.
//

#import "JKStatusPhotoView.h"
#import "UIImageView+WebCache.h"
#import "JKPhoto.h"

@interface JKStatusPhotoView ()

@property (nonatomic, weak) UIImageView *gifView;

@end

@implementation JKStatusPhotoView

- (UIImageView *)gifView
{
    if (!_gifView) {
        // 默认每一张配图都加了一个GIF标示，在photo的setter方法中，判断是否显示
        UIImageView *gifView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"timeline_image_gif"]];
        [self addSubview:gifView];
        self.gifView = gifView;
    }
    return _gifView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //保持宽高比，aspect ratio
        self.contentMode = UIViewContentModeScaleAspectFill;
        //超出边框的被剪掉
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)setPhoto:(JKPhoto *)photo
{
    _photo = photo;
    //根据传入的JKPhoto模型，设置单个配图的图片
    [self sd_setImageWithURL: [NSURL URLWithString:photo.thumbnail_pic] placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"]];
    //如果配图的地址（严谨起见，转成小写字符）以gif结尾，显示gifView。不以.gif结尾就隐藏之。
    self.gifView.hidden = ![photo.thumbnail_pic.lowercaseString hasSuffix:@".gif"];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    //重新布局gifView，把它放在右下角
    self.gifView.x = self.width - self.gifView.width;
    self.gifView.y = self.height - self.gifView.height;
}

@end
