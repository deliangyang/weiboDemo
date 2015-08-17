//
//  JKEmotion.m
//  微博demo
//
//  Created by 史江凯 on 15/7/9.
//  Copyright (c) 2015年 史江凯. All rights reserved.
//

#import "JKEmotion.h"
#import "MJExtension.h"

//偷懒的话可以用MJCodingImplementation，一行相当于两个方法

@implementation JKEmotion
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.chs = [aDecoder decodeObjectForKey:@"chs"];
        self.png = [aDecoder decodeObjectForKey:@"png"];
        self.code = [aDecoder decodeObjectForKey:@"code"];
//        [self enumerateIvarsWithBlock:^(MJIvar *ivar, BOOL *stop) {
//            ivar.value = [aDecoder decodeObjectForKey:ivar.name];
//        }];利用MJExtension.h可以实现遍历所有的属性，ivar.value指的是属性，ivar.name指的是对应的key
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.chs forKey:@"chs"];
    [aCoder encodeObject:self.png forKey:@"png"];
    [aCoder encodeObject:self.code forKey:@"code"];
//    [self enumerateIvarsWithBlock:^(MJIvar *ivar, BOOL *stop) {
//        [aCoder encodeObject:ivar.value forKey:ivar.name];
//    }];利用MJExtension.h可以实现遍历所有的属性，ivar.value指的是属性，ivar.name指的是对应的key
}

//重写了isEqual方法，不再比较地址，而是比较字符串
- (BOOL)isEqual:(JKEmotion *)other
{
    return [self.chs isEqualToString:other.chs] || [self.code isEqualToString:other.code];
}

@end
