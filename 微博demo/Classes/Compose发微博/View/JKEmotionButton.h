//
//  JKEmotionButton.h
//  微博demo
//
//  Created by 史江凯 on 15/7/10.
//  Copyright (c) 2015年 史江凯. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JKEmotion;
@interface JKEmotionButton : UIButton

/**每一个JKEmotionButton里有一个JKEmotion模型*/
@property (nonatomic, strong) JKEmotion *emotion;
@end
