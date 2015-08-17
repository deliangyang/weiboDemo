//
//  JKComposeToolbar.h
//  微博demo
//
//  Created by 史江凯 on 15/7/7.
//  Copyright (c) 2015年 史江凯. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    JKComposeToolbarButtonTypeCamera,   //照相机
    JKComposeToolbarButtonTypePhotoLibrary,  //相册
    JKComposeToolbarButtonTypeMention,  //@
    JKComposeToolbarButtonTypeTrend,    //＃
    JKComposeToolbarButtonTypeEmotion,  //表情
} JKComposeToolbarButtonType;

@class JKComposeToolbar;

@protocol JKComposeToolbarDelegate <NSObject>

@optional
- (void)composeToolbar:(JKComposeToolbar *)toolbar didClickBtnOfType:(JKComposeToolbarButtonType)type;

@end

@interface JKComposeToolbar : UIView
@property (nonatomic, assign) JKComposeToolbarButtonType type;
@property (nonatomic, weak) id <JKComposeToolbarDelegate> delegate;

@property (nonatomic, assign) BOOL swithKeyboard;
@end
