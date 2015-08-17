//
//  JKEmotion.h
//  微博demo
//
//  Created by 史江凯 on 15/7/9.
//  Copyright (c) 2015年 史江凯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JKEmotion : NSObject <NSCoding>
/**表情的文字描述，中括号里的文字：例如：［哈哈］*/
@property (nonatomic, copy) NSString *chs;

/**表情图片名*/
@property (nonatomic, copy) NSString *png;

/**Emoji表情的16进制编码*/
@property (nonatomic, copy) NSString *code;
@end
