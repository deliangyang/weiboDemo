//
//  JKStatusTextView.m
//  微博demo
//
//  Created by 史江凯 on 15/7/17.
//  Copyright (c) 2015年 史江凯. All rights reserved.
//

#import "JKStatusTextView.h"
#import "JKSpecialText.h"
#define JKStatusTextViewCoverTag 999

@implementation JKStatusTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.textContainerInset = UIEdgeInsetsMake(0, -5, 0, -5);
        self.editable = NO;
        self.scrollEnabled = NO;
    }
    return self;
}

- (JKSpecialText *)touchingSpecialWithPoint:(CGPoint)point
{
    for (JKSpecialText *specialText in self.specials) {
        for (NSValue *rectValue in specialText.rects) {
            if (CGRectContainsPoint(rectValue.CGRectValue, point)) {
                return specialText;
            }
        }
    }
    return nil;
}

- (void)setupSpecialRects
{
    self.specials = [self.attributedText attribute:@"specials" atIndex:0 effectiveRange:NULL];
    for (JKSpecialText *specialText in self.specials) {
        self.selectedRange = specialText.range;
        NSArray *selectionRects = [self selectionRectsForRange:self.selectedTextRange];
        self.selectedRange = NSMakeRange(0, 0);
        NSMutableArray *rects = [NSMutableArray array];
        for (UITextSelectionRect *selectionRect in selectionRects) {
            if (selectionRect.rect.size.width == 0 || selectionRect.rect.size.height == 0)  continue;
            [rects addObject:[NSValue valueWithCGRect:selectionRect.rect]];
        }
        specialText.rects = rects;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    [self setupSpecialRects];
    JKSpecialText *specialText = [self touchingSpecialWithPoint:point];
    for (NSValue *rectValue in specialText.rects) {
        UIView *cover = [[UIView alloc] init];
        cover.backgroundColor = [UIColor orangeColor];
        cover.frame = rectValue.CGRectValue;
        cover.layer.cornerRadius = 5;
        cover.tag = JKStatusTextViewCoverTag;
        [self insertSubview:cover atIndex:0];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self touchesCancelled:touches withEvent:event];
    });
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UIView *child in self.subviews) {
        if (child.tag == JKStatusTextViewCoverTag)  [child removeFromSuperview];
    }
}

//只处理特殊字符所在位置的点击事件，其余的点的点击可以看作是点击了cell
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    [self setupSpecialRects];
    //根据触摸点获得触摸的特殊字符
    JKSpecialText *specialText = [self touchingSpecialWithPoint:point];
    return specialText ? YES : NO;
}

@end
