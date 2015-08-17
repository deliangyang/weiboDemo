//
//  JKUser.m
//  微博demo
//
//  Created by 史江凯 on 15/7/3.
//  Copyright (c) 2015年 史江凯. All rights reserved.
//

#import "JKUser.h"

@implementation JKUser

- (void)setMbRank:(int)mbRank
{
    _mbRank = mbRank;
    self.vip = mbRank > 2 ;
}

@end
