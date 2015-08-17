//
//  JKStatusFrame.m
//  微博demo
//
//  Created by 史江凯 on 15/7/4.
//  Copyright (c) 2015年 史江凯. All rights reserved.


#import "JKStatusFrame.h"
#import "JKStatus.h"
#import "JKUser.h"
#import "JKStatusPhotosView.h"

//cell的宽度，就是屏幕的宽度
#define cellW [UIScreen mainScreen].bounds.size.width

@implementation JKStatusFrame

- (void)setStatus:(JKStatus *)status
{
    _status = status;
    JKUser *user = status.user;

    /**头像   */
    CGFloat iconWH = 35;
    CGFloat iconX = kStatusCellBorderW;
    CGFloat iconY = kStatusCellBorderW;
    self.iconFrame = CGRectMake(iconX, iconY, iconWH, iconWH);
    
    /**用户昵称*/
    CGFloat nameX = CGRectGetMaxX(self.iconFrame) + kStatusCellBorderW;
    CGFloat nameY = iconY;
    CGSize nameLabelSize = [user.name sizeWithFont:kNameLabelFont];
    self.nameFrame = (CGRect){{nameX, nameY}, nameLabelSize};

    /**会员图标 是vip才显示会员图标  */
    if (user.vip) {
        CGFloat vipX = CGRectGetMaxX(self.nameFrame) + kStatusCellBorderW;
        CGFloat vipY = nameY;
        CGFloat vipW = 14;
        CGFloat vipH = nameLabelSize.height;
        self.vipFrame = CGRectMake(vipX, vipY, vipW, vipH);
    }
    
    /**时间*/
    CGFloat timeX = nameX;
    CGFloat timeY = CGRectGetMaxY(self.nameFrame) + kStatusCellBorderW;
    CGSize timeSize = [status.created_at sizeWithFont:kTimeLabelFont];
    self.timeFrame = (CGRect){{timeX, timeY}, timeSize};

    /**来源*/
    CGFloat sourceX = CGRectGetMaxX(self.timeFrame) + kStatusCellBorderW;
    CGFloat sourceY = timeY;
    CGSize sourceSize = [status.source sizeWithFont:kSourceLabelFont];
    self.sourceFrame = (CGRect){{sourceX, sourceY}, sourceSize};

//    /**微博正文*/
    CGFloat contentX = iconX;
    CGFloat contentY = MAX(CGRectGetMaxY(self.iconFrame), CGRectGetMaxY(self.timeFrame)) + kStatusCellBorderW;
    CGFloat maxWidth = cellW - 2 * contentX;
//    CGSize contentSize = [status.text sizeWithFont:kContentLabelFont maxWidth:maxWidth];
    CGSize contentSize = [status.attributedText boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    self.contentFrame = (CGRect){{contentX, contentY}, contentSize};
    
    /**配图   */
    CGFloat originalH;//原创微博这个整体的高度，需要考虑有无配图

    if (status.pic_urls.count) {
        CGFloat photoX = contentX;
        CGFloat photoY = CGRectGetMaxY(self.contentFrame) + kStatusCellBorderW;
        CGSize photosSize = [JKStatusPhotosView photosSizeWithCount:status.pic_urls.count];
        self.photosFrame = (CGRect){{photoX, photoY}, photosSize};
        //有配图，原创微博这个整体的高度
        originalH = CGRectGetMaxY(self.photosFrame) + kStatusCellBorderW;
    } else {
        //没有配图，原创微博这个整体的高度
        originalH = CGRectGetMaxY(self.contentFrame) + kStatusCellBorderW;
    }
    
    /**原创微博，作为一个整体（容器）   */
    CGFloat originalX = 0;
    CGFloat originalY = kStatusCellMargin;
    CGFloat originalW = cellW;
    self.originalFrame = CGRectMake(originalX, originalY, originalW, originalH);
    
    CGFloat toolbarY = 0;//底部工具条的y值
    if (status.retweeted_status) {
        //如果有转发微博
        //转发微博的正文
        CGFloat retweetContentX = kStatusCellBorderW;
        CGFloat retweetContentY = kStatusCellBorderW;
        
        //取出转发微博模型，转发微博的作者
        JKStatus *retweeted_status = status.retweeted_status;

        CGSize retweetContentSize = [status.retweetedAttributedText boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        self.retweetContentLabelFrame = (CGRect){{retweetContentX, retweetContentY}, retweetContentSize};

        CGFloat retweetH;//转发微博这个整体的高度，需要考虑有无配图

        if (retweeted_status.pic_urls.count) {
            
            //转发微博里有配图
            CGFloat retweetPhotoX = retweetContentX;
            CGFloat retweetPhotoY = CGRectGetMaxY(self.retweetContentLabelFrame) + kStatusCellBorderW;
            CGSize retweetPhotosSize = [JKStatusPhotosView photosSizeWithCount:retweeted_status.pic_urls.count];
            self.retweetPhotosViewFrame = (CGRect){{retweetPhotoX, retweetPhotoY}, retweetPhotosSize};
            
            //有配图，转发微博这个整体的高度
            retweetH = CGRectGetMaxY(self.retweetPhotosViewFrame) + kStatusCellBorderW;
        } else {
            //没有配图，转发微博这个整体的高度
            retweetH = CGRectGetMaxY(self.retweetContentLabelFrame) + kStatusCellBorderW;
        }
        
        /**转发微博，作为一个整体（容器）   */
        CGFloat retweetX = 0;
        CGFloat retweetY = CGRectGetMaxY(self.originalFrame);
        CGFloat retweetW = cellW;
        self.retweetViewFrame = CGRectMake(retweetX, retweetY, retweetW, retweetH);
        
        //有转发微博时，工具条的y值
        toolbarY = CGRectGetMaxY(self.retweetViewFrame);

    } else {
        //没有转发微博时，工具条的y值
        toolbarY = CGRectGetMaxY(self.originalFrame);
    }
    
    CGFloat toolbarX = 0;
    CGFloat toolbarW = cellW;
    CGFloat toolbarH = 35;
    self.toolbarFrame = CGRectMake(toolbarX, toolbarY, toolbarW, toolbarH);
    
    self.cellHeight = CGRectGetMaxY(self.toolbarFrame);
}

@end
