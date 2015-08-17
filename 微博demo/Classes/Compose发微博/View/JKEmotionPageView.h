//
//  JKEmotionPageView.h
//  微博demo
//
//  Created by 史江凯 on 15/7/10.
//  Copyright (c) 2015年 史江凯. All rights reserved.
//

#import <UIKit/UIKit.h>

//每一页有几行
#define JKEmotionMaxRows 3
//一行中有多少列
#define JKEmotionMaxCols 7
//每一页的最大表情个数
#define JKEmotionsMaxCountOfPerPage ((JKEmotionMaxRows * JKEmotionMaxCols) - 1)

@interface JKEmotionPageView : UIView
//截取的emotions
@property (nonatomic, strong) NSArray *emotions;
@end
