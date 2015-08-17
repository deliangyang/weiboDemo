//
//  JKEmotionButton.m
//  微博demo
//
//  Created by 史江凯 on 15/7/10.
//  Copyright (c) 2015年 史江凯. All rights reserved.
//

#import "JKEmotionButton.h"
#import "JKEmotion.h"

@implementation JKEmotionButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //代码手动创建按钮，在这里设置按钮属性（字体 ），这里生成的按钮是listView的按钮
        self.titleLabel.font = [UIFont systemFontOfSize:32];
        //取消高亮时图片变黑
        self.adjustsImageWhenHighlighted = NO;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        //从xib中加载按钮，在这里设置按钮属性（字体），这里生成的按钮是popView的按钮，主要是给emoji表情
        self.titleLabel.font = [UIFont systemFontOfSize:32];
    }
    return self;
}

- (void)setEmotion:(JKEmotion *)emotion
{
    _emotion = emotion;
    //根据模型设置按钮自己的图片
    if (emotion.png) {
        //有图片，设置图片，没有图片设置emoji
        [self setImage:[UIImage imageNamed:emotion.png] forState:UIControlStateNormal];
    } else if (emotion.code) {
        //16进制编码（字符串）转成emoji字符
        [self setTitle:[emotion.code emoji] forState:UIControlStateNormal];
        //设置字体 ,在这里会频繁设置字体，只需要在从xib初始化时在initWithCoder设置一次即可
    }
}

@end
