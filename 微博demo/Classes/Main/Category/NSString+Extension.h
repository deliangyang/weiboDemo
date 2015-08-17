//
//  NSString+Extension.h
//  微博demo
//
//  Created by 史江凯 on 15/7/6.
//  Copyright (c) 2015年 史江凯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)
- (CGSize)sizeWithFont:(UIFont *)font maxWidth:(CGFloat)maxWidth;

- (CGSize)sizeWithFont:(UIFont *)font;

/**给定文件，或文件夹，返回所有内容的大小，返回的是字节数*/
- (NSInteger)fileSize;
@end
