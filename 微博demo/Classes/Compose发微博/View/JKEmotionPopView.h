//
//  JKEmotionPopView.h
//  微博demo
//
//  Created by 史江凯 on 15/7/10.
//  Copyright (c) 2015年 史江凯. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JKEmotion;
@class JKEmotionButton;
@interface JKEmotionPopView : UIView

@property (weak, nonatomic) IBOutlet JKEmotionButton *emotionButton;
+ (instancetype)popView;
- (void)showFrom:(JKEmotionButton *)btn;
@end
