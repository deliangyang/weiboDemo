//
//  NSString+Extension.m
//  微博demo
//
//  Created by 史江凯 on 15/7/6.
//  Copyright (c) 2015年 史江凯. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)
- (CGSize)sizeWithFont:(UIFont *)font maxWidth:(CGFloat)maxWidth
{
    NSMutableDictionary *attrsDict = [NSMutableDictionary dictionary];
    attrsDict[NSFontAttributeName] = font;
    //    return [text sizeWithAttributes:attrsDict];
    CGSize maxSize = CGSizeMake(maxWidth, MAXFLOAT);
    if (iOS7) {
        return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrsDict context:nil].size;
    } else {
        return [self sizeWithFont:font constrainedToSize:maxSize];
    }
}

- (CGSize)sizeWithFont:(UIFont *)font
{
    return [self sizeWithFont:font maxWidth:MAXFLOAT];
}

- (NSInteger)fileSize
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL isDir = NO;
    BOOL exists = [fileManager fileExistsAtPath:self isDirectory:&isDir];
    
    if (!exists) return -1;//不是文件，也不是文件夹，返回-1
    
    if (isDir) {//
        NSArray *subpaths = [fileManager subpathsOfDirectoryAtPath:self error:nil];//遍历
        NSInteger totalByteSize = 0;
        for (NSString *subpath in subpaths) {
            NSString *fullSubpath = [self stringByAppendingPathComponent:subpath];
            
            BOOL isDir = NO;
            [fileManager fileExistsAtPath:fullSubpath isDirectory:&isDir];//判断文件或文件夹是否存在于给定路径
            if (isDir == NO) {
                //不是文件夹，说明是文件
                NSDictionary *dict = [fileManager attributesOfItemAtPath:fullSubpath error:nil];
                totalByteSize += [dict[NSFileSize] longLongValue];
            }
        }
        return totalByteSize;
    } else {
        return [[fileManager attributesOfItemAtPath:self error:nil][NSFileSize] integerValue];
    }
}

@end
