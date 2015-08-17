//
//  JKStatusCell.m
//  微博demo
//
//  Created by 史江凯 on 15/7/4.
//  Copyright (c) 2015年 史江凯. All rights reserved.
//

#import "JKStatusCell.h"
#import "JKStatusFrame.h"
#import "JKStatus.h"
#import "JKUser.h"
#import "JKPhoto.h"
#import "UIImageView+WebCache.h"
#import "JKStatusCellToolbar.h"
#import "JKStatusPhotosView.h"
#import "JKIconView.h"
#import "JKStatusTextView.h"

@interface JKStatusCell()
/**原创微博，作为一个整体（容器）   */
@property (nonatomic, weak) UIView *originalView;
/**头像   */
@property (nonatomic, weak) JKIconView *iconView;
/**会员图标   */
@property (nonatomic, weak) UIImageView *vipView;
/**配图   */
@property (nonatomic, weak) JKStatusPhotosView *photosView;
/**用户昵称*/
@property (nonatomic, weak) UILabel *nameLabel;
/**时间*/
@property (nonatomic, weak) UILabel *timeLabel;
/**来源*/
@property (nonatomic, weak) UILabel *sourceLabel;
/**微博正文*/
@property (nonatomic, weak) JKStatusTextView *contentLabel;

/**转发微博，作为一个整体（容器）   */
@property (nonatomic, weak) UIView *retweetView;
/**转发微博正文＋昵称*/
@property (nonatomic, weak) JKStatusTextView *retweetContentLabel;
/**转发微博里的配图   */
@property (nonatomic, weak) JKStatusPhotosView *retweetPhotosView;

/**转发，评论，赞三合一工具条*/
@property (nonatomic, weak) JKStatusCellToolbar *toolbar;

@end

@implementation JKStatusCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"status";
    JKStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[JKStatusCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

//- (void)setFrame:(CGRect)frame
//{
//    //每个cell都向下移动一段距离，效果其实就是第一个cell顶部有个间距
//    需要注释掉，JKStatusFrame中已经设置了cell里的originalFrame.y = kStatusCellMargin;即每一个originalFrame都里顶部有个间距
//    看起来就是每个cell之间有个间距

//    frame.origin.y += kStatusCellMargin;
//    [super setFrame:frame];
//}

//初始化cell时，就设置好cell内部的控件，一些固定属性
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code

        //cell的背景颜色透明，以便显示其内部控件的背景颜色
        self.backgroundColor = [UIColor clearColor];

        //cell选中时不变色
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //cell选中时的背景
        //self.selectedBackgroundView
        
        /**原创微博，作为一个整体（容器）,添加到cell的contentView */
        UIView *originalView = [[UIView alloc] init];
        originalView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:originalView];
        self.originalView = originalView;
        
        /**头像  ,添加到originalView这个容器，下面几个也是 */
        JKIconView *iconView = [[JKIconView alloc] init];
        [self.originalView addSubview:iconView];
        self.iconView = iconView;
        /**会员图标   */
        UIImageView *vipView = [[UIImageView alloc] init];
        vipView.contentMode = UIViewContentModeCenter;
        [self.originalView addSubview:vipView];
        self.vipView = vipView;
        /**配图   */
        JKStatusPhotosView *photosView = [[JKStatusPhotosView alloc] init];
        [self.originalView addSubview:photosView];
        self.photosView = photosView;

        /**用户昵称*/
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.font = kNameLabelFont;
        [self.originalView addSubview:nameLabel];
        self.nameLabel = nameLabel;

        /**时间*/
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.font = kTimeLabelFont;
        timeLabel.textColor = [UIColor orangeColor];
        [self.originalView addSubview:timeLabel];
        self.timeLabel = timeLabel;
        
        /**来源*/
        UILabel *sourceLabel = [[UILabel alloc] init];
        sourceLabel.font = kSourceLabelFont;
        [self.originalView addSubview:sourceLabel];
        self.sourceLabel = sourceLabel;

        /**微博正文*/
        JKStatusTextView *contentLabel = [[JKStatusTextView alloc] init];
//        contentLabel.font = kContentLabelFont;
        [self.originalView addSubview:contentLabel];
        self.contentLabel = contentLabel;
        
        /**转发微博，作为一个整体（容器）*/
        UIView *retweetView = [[UIView alloc] init];
        retweetView.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0];
        [self.contentView addSubview:retweetView];
        self.retweetView = retweetView;
        
        /**转发微博的正文＋昵称*/
        JKStatusTextView *retweetContentLabel = [[JKStatusTextView alloc] init];
//        retweetContentLabel.font = kRetweetLabelFont;
        [self.retweetView addSubview:retweetContentLabel];
        self.retweetContentLabel = retweetContentLabel;
        
        /**转发微博里的配图   */
        JKStatusPhotosView *retweetPhotosView = [[JKStatusPhotosView alloc] init];
        [self.retweetView addSubview:retweetPhotosView];
        self.retweetPhotosView = retweetPhotosView;
        
        /**转发，评论，赞三合一工具条*/
        JKStatusCellToolbar *toolbar = [JKStatusCellToolbar toolbar];
        [self.contentView addSubview:toolbar];
        self.toolbar = toolbar;
    }
    return self;
}

//重写statusFrame的setter方法，以便设置cell的statusFrame时，就设置cell内部控件的frame，设置头像，会员图标，配图的图片
- (void)setStatusFrame:(JKStatusFrame *)statusFrame
{
    _statusFrame = statusFrame;
    //取出微博模型
    JKStatus *status = statusFrame.status;
    //取出用户模型
    JKUser *user = status.user;
    
    /**原创微博，作为一个整体（容器）,添加到cell的contentView */
    self.originalView.frame = statusFrame.originalFrame;
    
    /**头像*/
    self.iconView.frame = statusFrame.iconFrame;
    self.iconView.user = user;
    
    /**会员图标   */
    if (user.isVip) {//是会员，显示具体的多少级的VIP图片，昵称是橙色
        self.vipView.hidden = NO;
        self.vipView.frame = statusFrame.vipFrame;
        NSString *memberlevelString = [NSString stringWithFormat:@"common_icon_membership_level%d", user.mbRank];
        self.vipView.image = [UIImage imageNamed:memberlevelString];
        self.nameLabel.textColor = [UIColor orangeColor];
    } else {
        self.vipView.hidden = YES;
        self.nameLabel.textColor = [UIColor blackColor];
    }
    
    /**配图   */
    if (status.pic_urls.count) {//有配图，暂时只取出第一张演示
        self.photosView.frame = statusFrame.photosFrame;
        self.photosView.photos = status.pic_urls;
        self.photosView.hidden = NO;
    } else {
        //没有配图时，隐藏
        self.photosView.hidden = YES;
    }
    
    /**用户昵称*/
    self.nameLabel.frame = statusFrame.nameFrame;
    self.nameLabel.text = user.name;
    
    /**时间*///重写了created_at的getter方法，这里用createdTime’临时‘保存起来，相当于本段代码内只调用了一次getter方法，
    //createdTime sizeWithFont:kTimeLabelFont计算size时，不再调用created_at的getter方法
    NSString *createdTime = status.created_at;
    CGFloat timeX = statusFrame.nameFrame.origin.x;
    CGFloat timeY = CGRectGetMaxY(statusFrame.nameFrame) + kStatusCellBorderW;
    CGSize timeSize = [createdTime sizeWithFont:kTimeLabelFont];
    self.timeLabel.frame = (CGRect){{timeX, timeY}, timeSize};
    self.timeLabel.text = createdTime;
    
    /**来源*/
    CGFloat sourceX = CGRectGetMaxX(statusFrame.timeFrame) + kStatusCellBorderW;
    CGFloat sourceY = timeY;
    CGSize sourceSize = [status.source sizeWithFont:kSourceLabelFont];
    self.sourceLabel.frame = (CGRect){{sourceX, sourceY}, sourceSize};
    self.sourceLabel.text = status.source;
    
    /**微博正文*/
    self.contentLabel.frame = statusFrame.contentFrame;
    self.contentLabel.attributedText = status.attributedText;
    
    /**转发微博，分情况处理*/
    if (status.retweeted_status) {//有转发微博
        //取出转发微博模型
        JKStatus *retweeted_status = status.retweeted_status;
        
        self.retweetView.hidden = NO;
        self.retweetView.frame = statusFrame.retweetViewFrame;
        //转发微博正文
        self.retweetContentLabel.attributedText = status.retweetedAttributedText;
        self.retweetContentLabel.frame = statusFrame.retweetContentLabelFrame;
        
        /**转发微博的配图   */
        if (retweeted_status.pic_urls.count) {
            self.retweetPhotosView.hidden = NO;
            self.retweetPhotosView.frame = statusFrame.retweetPhotosViewFrame;
            self.retweetPhotosView.photos = retweeted_status.pic_urls;
        } else {
            //没有配图时，隐藏
            self.retweetPhotosView.hidden = YES;
        }
    } else {
        //没有转发微博时，隐藏
        self.retweetView.hidden = YES;
    }

    /**底部工具条*/
    self.toolbar.frame = statusFrame.toolbarFrame;
    //根据模型设置内部三个按钮
    self.toolbar.status = status;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
