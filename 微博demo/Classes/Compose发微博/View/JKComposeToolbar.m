//
//  JKComposeToolbar.m
//  微博demo
//
//  Created by 史江凯 on 15/7/7.
//  Copyright (c) 2015年 史江凯. All rights reserved.
//

#import "JKComposeToolbar.h"

@interface JKComposeToolbar ()

@property (nonatomic, weak) UIButton *emotionBtn;

@end


@implementation JKComposeToolbar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"compose_toolbar_background"]];

        //依次添加五个按钮到toolbar
        [self setupBtnWithImageName:@"compose_camerabutton_background" highlightImageName:@"compose_camerabutton_background_highlighted" type:JKComposeToolbarButtonTypeCamera];
        
        [self setupBtnWithImageName:@"compose_toolbar_picture" highlightImageName:@"compose_toolbar_picture_highlighted" type:JKComposeToolbarButtonTypePhotoLibrary];
        
        [self setupBtnWithImageName:@"compose_mentionbutton_background" highlightImageName:@"compose_mentionbutton_background_highlighted" type:JKComposeToolbarButtonTypeMention];
        
        [self setupBtnWithImageName:@"compose_trendbutton_background" highlightImageName:@"compose_trendbutton_background_highlighted" type:JKComposeToolbarButtonTypeTrend];
        
        self.emotionBtn = [self setupBtnWithImageName:@"compose_emoticonbutton_background" highlightImageName:@"compose_emoticonbutton_background_highlighted" type:JKComposeToolbarButtonTypeEmotion];
    }
    return self;
}

- (UIButton *)setupBtnWithImageName:(NSString *)imageName highlightImageName:(NSString *)highlightImageName type:(JKComposeToolbarButtonType)type
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:highlightImageName] forState:UIControlStateHighlighted];
    //把JKComposeToolbarType以tag的形式存起来
    btn.tag = type;
    //按钮被点击时，通知代理自己被点了
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    return btn;
}

- (void)btnClick:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(composeToolbar:didClickBtnOfType:)]) {
        [self.delegate composeToolbar:self didClickBtnOfType:btn.tag];
    }
}

- (void)setSwithKeyboard:(BOOL)swithKeyboard
{
    _swithKeyboard = swithKeyboard;
    if (swithKeyboard) {
        //swithKeyboard为YES，就设置为表情图标
        [self.emotionBtn setImage:[UIImage imageNamed:@"compose_emoticonbutton_background" ] forState:UIControlStateNormal];
        [self.emotionBtn setImage:[UIImage imageNamed:@"compose_emoticonbutton_background_highlighted"] forState:UIControlStateHighlighted];
    } else {
        [self.emotionBtn setImage:[UIImage imageNamed:@"compose_keyboardbutton_background"] forState:UIControlStateNormal];
        [self.emotionBtn setImage:[UIImage imageNamed:@"compose_keyboardbutton_background_highlighted"] forState:UIControlStateHighlighted];
    }
}

- (void)layoutSubviews
{
    //布局五个按钮
    [super layoutSubviews];
    NSUInteger count = self.subviews.count;
    CGFloat btnW = self.width / count;
    for (NSUInteger i = 0; i < count; i++) {
        UIButton *btn = self.subviews[i];
        btn.width = btnW;
        btn.height = self.height;
        btn.x = i * btnW;
        btn.y = 0;
    }
}

@end
