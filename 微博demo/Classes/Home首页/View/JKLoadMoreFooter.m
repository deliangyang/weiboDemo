//
//  JKLoadMoreFooter.m
//  微博demo
//
//  Created by 史江凯 on 15/7/4.
//  Copyright (c) 2015年 史江凯. All rights reserved.
//

#import "JKLoadMoreFooter.h"

@implementation JKLoadMoreFooter

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (instancetype)footer
{
    return [[[NSBundle mainBundle] loadNibNamed:@"JKLoadMoreFooter" owner:nil options:nil] lastObject];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
