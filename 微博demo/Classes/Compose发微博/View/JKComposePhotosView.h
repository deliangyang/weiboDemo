//
//  JKComposePhotosView.h
//  微博demo
//
//  Created by 史江凯 on 15/7/8.
//  Copyright (c) 2015年 史江凯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JKComposePhotosView : UIView

/**存放从照相机，或者相册选中的相片，只读以防外部修改*/
@property (nonatomic, strong, readonly) NSMutableArray *photos;

- (void)addPhoto:(UIImage *)image;
@end
