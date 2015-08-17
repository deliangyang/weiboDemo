//
//  JKEmotionPageView.m
//  微博demo
//
//  Created by 史江凯 on 15/7/10.
//  Copyright (c) 2015年 史江凯. All rights reserved.
//

#import "JKEmotionPageView.h"
#import "JKEmotion.h"
#import "JKEmotionPopView.h"
#import "JKEmotionButton.h"
#import "JKEmotionTool.h"

@interface JKEmotionPageView ()
//点击表情弹出的放大镜
@property (nonatomic, strong) JKEmotionPopView *popView;
//删除按钮
@property (nonatomic, weak) UIButton *deleteBtn;

@end

@implementation JKEmotionPageView

- (JKEmotionPopView *)popView
{
    if (!_popView) {
        self.popView = [JKEmotionPopView popView];
    }
    return _popView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //删除按钮
        UIButton *deleteBtn = [[UIButton alloc] init];
        [deleteBtn setImage:[UIImage imageNamed:@"compose_emotion_delete"] forState:UIControlStateNormal];
        [deleteBtn setImage:[UIImage imageNamed:@"compose_emotion_delete_highlighted"] forState:UIControlStateHighlighted];
        [deleteBtn addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:deleteBtn];
        self.deleteBtn = deleteBtn;
        //添加长按手势
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        [self addGestureRecognizer:longPressGesture];
    }
    return self;
}

- (JKEmotionButton *)emotionButtonInLocation:(CGPoint)location
{
    //根据位置找出对应的emotionButton，跳过删除按钮
    for (JKEmotionButton *btn in self.subviews) {
        if ([btn isKindOfClass:[JKEmotionButton class]]) {
            if (CGRectContainsPoint(btn.frame, location)) {
                return btn;
                break;
            }
        }
    }
//也可以用下面这种形式    
//    for (int i = 0; i < self.emotions.count; i++) {
//        JKEmotionButton *btn = self.subviews[i + 1];
//        if (CGRectContainsPoint(btn.frame, location)) {
//                return btn;
//                break;
//            }
//    }
    return nil;
}

- (void)longPress:(UILongPressGestureRecognizer *)longPressGestureRecognizer
{
    CGPoint location = [longPressGestureRecognizer locationInView:self];
    JKEmotionButton *btn = [self emotionButtonInLocation:location];
    switch (longPressGestureRecognizer.state) {
            //结束状态，或取消（被迫取消）状态，移除popView，发出通知将表情上屏
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
            //移除放大镜popView
            [self.popView removeFromSuperview];
            if (btn) {
                //发出通知，表情上屏
                [self selectEmotion:btn.emotion];
            }
            break;
            
            //开始状态（刚检测到长按手势），或改变状态（手指位置改变），弹出放大镜popView
        case UIGestureRecognizerStateBegan:
        case UIGestureRecognizerStateChanged:
            [self.popView showFrom:btn];
            break;
            
        default:
            break;
    }
}

//点击删除按钮，发出删除表情通知
- (void)deleteBtnClick
{
    [[NSNotificationCenter defaultCenter] postNotificationName:JKEmotionDidDeleteNotification object:nil];
}

- (void)setEmotions:(NSArray *)emotions
{
    _emotions = emotions;

    for (int i = 0; i < emotions.count; i++) {
        JKEmotionButton *btn = [[JKEmotionButton alloc] init];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.emotion = self.emotions[i];

        [self addSubview:btn];
    }
}



- (void)btnClick:(JKEmotionButton *)btn
{
//封装到了popView
//    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
//    [window addSubview:self.popView];
////    self.popView.emotion = btn.emotion;
//    self.popView.emotionButton.emotion = btn.emotion;
//    CGRect convertedFrame = [btn convertRect:btn.bounds toView:window];
//    self.popView.centerX = CGRectGetMidX(convertedFrame);
//    self.popView.y = CGRectGetMidY(convertedFrame) - self.popView.height;
    
    [self.popView showFrom:btn];

    //点击表情0.25秒后，放大镜消失
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.popView removeFromSuperview];
    });
    //发出通知
    [self selectEmotion:btn.emotion];
}

- (void)selectEmotion:(JKEmotion *)emotion
{
    //把表情存进最近表情的沙盒
    [JKEmotionTool addRecentEmotion:emotion];
    
    //发出通知，表情上屏
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[JKEmotionDidSelectNotificationUserInfoKey] = emotion;
    [[NSNotificationCenter defaultCenter] postNotificationName:JKEmotionDidSelectNotification object:nil userInfo:userInfo];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    NSUInteger count = self.emotions.count;
    CGFloat inset = 10;
    CGFloat btnW = (self.width - 2 * inset) / JKEmotionMaxCols;
    CGFloat btnH = (self.height - inset) / JKEmotionMaxRows;
    for (int i = 0; i < count; i++) {
        //跳过删除按钮，它是subviews[0]
        JKEmotionButton *btn = self.subviews[i+1];
        btn.width = btnW;
        btn.height = btnH;
        btn.x = (i % JKEmotionMaxCols) * btnW + inset;
        btn.y = (i / JKEmotionMaxCols) * btnH + inset;
    }
    //删除按钮的frame
    self.deleteBtn.width = btnW;
    self.deleteBtn.height = btnH;
    self.deleteBtn.x = self.width - inset - self.deleteBtn.width;//右侧有个间距
    self.deleteBtn.y = self.height - btnH;//底部没有间距
}

@end
