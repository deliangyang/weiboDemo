//
//  JKEmotionTextView.m
//  微博demo
//
//  Created by 史江凯 on 15/7/11.
//  Copyright (c) 2015年 史江凯. All rights reserved.
//

#import "JKEmotionTextView.h"
#import "JKEmotion.h"
#import "JKEmotionAttachment.h"

@implementation JKEmotionTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)insertEmotion:(JKEmotion *)emotion
{
    if (emotion.code) {
        //如果是emoji，装成字符后，直接插在光标当前位置
        [self insertText:emotion.code.emoji];
    } else if (emotion.png) {
        
        //如果是图片，要用NSMutableAttributedString
        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] init];
        //此时attributedStr为空，拼接后将获得所有的文字和图片
        [attributedStr appendAttributedString:self.attributedText];
        
        //拿到要上屏的表情图片，先包装成JKEmotionAttachment
        JKEmotionAttachment *textAttach = [[JKEmotionAttachment alloc] init];

        //为了能通过JKEmotionAttachment拿到对应的表情
        textAttach.emotion = emotion;
        
        textAttach.image = [UIImage imageNamed:emotion.png];
        //表情图片的宽高（大小）和文字的行高一致，并且调整图片的垂直位置，这里的bounds和平时的bounds有些不同
        CGFloat imageWH = self.font.lineHeight;
        textAttach.bounds = CGRectMake(0, -3.9, imageWH, imageWH);
        
        //拼接表情图片
        NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:textAttach];
        //[attributedStr appendAttributedString:imageStr];将它插在最后
        
        //获得当前光标所在位置，（没有选中文字时，selectedRange.length == 0）
        NSRange range = self.selectedRange;
        //插入图片
//        [attributedStr insertAttributedString:imageStr atIndex:range.location];如果选中了一段文字时，这句代码只会将表情图片插入选中文字的前面，不会替换，应该使用下面的replaceCharactersInRange:withAttributedString:
        [attributedStr replaceCharactersInRange:self.selectedRange withAttributedString:imageStr];
        
        //拼接好后设置字体
        [attributedStr addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, attributedStr.length)];
        
        //覆盖之前的文字
        self.attributedText = attributedStr;
        //光标移动到插入时的下一位（上一行覆盖后光标在最后）
        self.selectedRange = NSMakeRange(range.location + 1 ,0);
    }
}

- (NSString *)fullText
{
    //建立一个空的字符串
    NSMutableString *fullText = [NSMutableString string];
    //遍历所有的属性文字（带有属性的attributedText（表情图片），普通文字，emoji）
    [self.attributedText enumerateAttributesInRange:NSMakeRange(0, self.attributedText.length) options:0 usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
        //从每个range取出的attrs字典，再根据@"NSAttachment"这个key取出对应的自定的NSTextAttachment（JKEmotionAttachment）
        JKEmotionAttachment *attach = attrs[@"NSAttachment"];
        if (attach) {
            //如果存在，说明是图片表情，取出对应的表情的文字描述（中括号括起来的文字），拼接
            [fullText appendString:attach.emotion.chs];
        } else {
            // 如果不存在，说明是普通的文字，或者是emoji表情，（一个emoji占2个字符），根据range取出对应的文字或emoji，拼接
            NSAttributedString *str = [self.attributedText attributedSubstringFromRange:range];
            [fullText appendString:str.string];
        }
    }];
    return fullText;
}

@end
