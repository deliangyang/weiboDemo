//
//  JKDropDownMenu.m
//  微博demo
//
//  Created by 史江凯 on 15/7/1.
//  Copyright (c) 2015年 史江凯. All rights reserved.
//

#import "JKDropDownMenu.h"

@implementation JKDropDownMenu

- (UIImageView *)containerView
{
    if (!_containerView) {
        UIImageView *containerView= [[UIImageView alloc] init];

        containerView.image = [UIImage imageNamed:@"popover_background"];
        containerView.userInteractionEnabled = YES;
        [self addSubview:containerView];
        self.containerView = containerView;
    }
    return _containerView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

+ (instancetype)menu
{
    return [[self alloc] init];
}

- (void)showFrom:(UIView *)from
{
    //获得当前屏幕最上面的window
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];

    self.frame = window.bounds;

    [window addSubview:self];
    
    // 调整灰色containerView图片的位置
    // 默认情况下，frame是以父控件左上角为坐标原点
    // 转换坐标系
    CGRect newFrame = [from convertRect:from.bounds toView:window];
    //    CGRect newFrame = [from.superview convertRect:from.frame toView:window];
    self.containerView.centerX = CGRectGetMidX(newFrame);
    self.containerView.y = CGRectGetMaxY(newFrame);
    
    //当自己显示时，通知代理
    if ([self.delegate respondsToSelector:@selector(didShowDropDownMenu:)]) {
        [self.delegate didShowDropDownMenu:self];
    }
}

- (void)dismiss
{
    [self removeFromSuperview];
    //当自己消失时，通知代理
    if ([self.delegate respondsToSelector:@selector(didDismissDropDownMenu:)]) {
        [self.delegate didDismissDropDownMenu:self];
    }
}

- (void)setContent:(UIView *)content
{
    _content = content;
    
    content.x = 10;
    content.y = 15;
    
    self.containerView.height = CGRectGetMaxY(content.frame) + 11;
    self.containerView.width = CGRectGetMaxX(content.frame) + 10;
    
    [self.containerView addSubview:content];
}

- (void)setContentController:(UIViewController *)contentController
{
    _contentController = contentController;
    self.content = contentController.view;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self dismiss];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
