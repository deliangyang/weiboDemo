//
//  JKSpecialText.h
//  微博demo
//
//  Created by 史江凯 on 15/7/17.
//  Copyright (c) 2015年 史江凯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JKSpecialText : NSObject
/**这段特殊文字的内容*/
@property (nonatomic, copy) NSString *text;
/**这段特殊文字的范围*/
@property (nonatomic, assign) NSRange range;
/**这段特殊文字的矩形框（可能有多行）*/
@property (nonatomic, strong) NSArray *rects;
@end
