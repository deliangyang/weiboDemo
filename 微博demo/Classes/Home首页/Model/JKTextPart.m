//
//  JKTextPart.m
//  微博demo
//
//  Created by 史江凯 on 15/7/17.
//  Copyright (c) 2015年 史江凯. All rights reserved.
//

#import "JKTextPart.h"

@implementation JKTextPart
- (NSString *)description
{
    return [NSString stringWithFormat:@"%@%@", self.text, NSStringFromRange(self.range)];
}
@end
