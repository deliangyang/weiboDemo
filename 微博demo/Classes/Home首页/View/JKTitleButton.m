//
//  JKTitleButton.m
//  微博demo
//
//  Created by 史江凯 on 15/7/3.
//  Copyright (c) 2015年 史江凯. All rights reserved.
//

#import "JKTitleButton.h"

#define kTitleButtonMargin 8

@implementation JKTitleButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //设置图片
        [self setImage:[UIImage imageNamed:@"navigationbar_arrow_down"] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"navigationbar_arrow_up"] forState:UIControlStateSelected];
        //设置文字颜色
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //设置文字字体
        self.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    //button自己的宽度先加个间距，再设置
    frame.size.width += kTitleButtonMargin;
    [super setFrame:frame];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    //标签挪到图片前
    self.titleLabel.x = self.imageView.x;
    //图片挪到标签后加上个间距
    self.imageView.x = CGRectGetMaxX(self.titleLabel.frame) + kTitleButtonMargin;
}

//图片改变时，按钮大小也自动适应
- (void)setImage:(UIImage *)image forState:(UIControlState)state
{
    [super setImage:image forState:state];
    [self sizeToFit];
}

//标题改变时，按钮大小也自动适应
- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [super setTitle:title forState:state];

    [self sizeToFit];
}

@end
