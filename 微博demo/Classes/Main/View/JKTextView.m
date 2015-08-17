//
//  JKTextView.m
//  微博demo
//
//  Created by 史江凯 on 15/7/7.
//  Copyright (c) 2015年 史江凯. All rights reserved.
//  可以显示placeholder

#import "JKTextView.h"

@implementation JKTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //添加通知，当自己，textView文字改变时（输入了文字），调用textViewDidChange
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidChange) name:UITextViewTextDidChangeNotification object:self];
        
//        添加的自控件可以随着光标的拖动而拖动，但是drawRect里绘制的文字只能显示在固定位置
//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeContactAdd];
//        [self addSubview:btn];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//输入文字时调用
- (void)textViewDidChange
{
//    NSLog(@"-----------");
    //重绘,setNeedsDisplay会在下一个消息循环时刻，调用drawRect：方法
    [self setNeedsDisplay];
}

//重写五个setter方法，以便当每个属性改变时，能实时更新（自定义控件时，要特别注意）
- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = [placeholder copy];
    [self setNeedsDisplay];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    _placeholderColor = placeholderColor;
    [self setNeedsDisplay];
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    [self setNeedsDisplay];
}

- (void)setAttributedText:(NSAttributedString *)attributedText
{
    [super setAttributedText:attributedText];
    [self setNeedsDisplay];
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    //如果textView内有文字，就不绘制占位文本，直接返回
    if (self.hasText) return;

    //x，y可以让文字大概和光标对齐
    CGFloat x = 5;
    CGFloat y = 8;
    //宽，高对称（相对屏幕四周都有一个边距）
    CGFloat width = rect.size.width - 2 * x;
    CGFloat height = rect.size.height - 2 * y;
    CGRect placeholderRect = CGRectMake(x, y, width, height);
    
    NSMutableDictionary *attrsDict = [NSMutableDictionary dictionary];

    attrsDict[NSFontAttributeName] = self.font;
    attrsDict[NSForegroundColorAttributeName] = self.placeholderColor;
    //根据文字属性绘制占位文本
    [self.placeholder drawInRect:placeholderRect withAttributes:attrsDict];
}


@end
