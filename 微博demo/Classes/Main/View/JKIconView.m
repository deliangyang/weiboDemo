//
//  JKIconView.m
//  微博demo
//
//  Created by 史江凯 on 15/7/7.
//  Copyright (c) 2015年 史江凯. All rights reserved.
//

#import "JKIconView.h"
#import "JKUser.h"
#import "UIImageView+WebCache.h"

@interface JKIconView ()

//用户头像右下角的认证图片
@property (nonatomic, weak) UIImageView *verifiedView;
@end

@implementation JKIconView

- (UIImageView *)verifiedView
{
    if (!_verifiedView) {
        UIImageView *verifiedView = [[UIImageView alloc] init];
        [self addSubview:verifiedView];
        self.verifiedView = verifiedView;
    }
    return _verifiedView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setUser:(JKUser *)user
{
    _user = user;
    //
    [self sd_setImageWithURL:[NSURL URLWithString:user.profile_image_url] placeholderImage:[UIImage imageNamed:@"avatar_default_small"]];
    //
    switch (user.verifiedType) {
        
//        case JKUserVerifiedTypeNone:         //用户没有认证，不显示认证图片
//            self.verifiedView.hidden = YES;
//            break;
        
        case JKUserVerifiedTypeOrgEnterprice: //企业认证
        case JKUserVerifiedTypeOrgMedia:       //媒体官方
        case JKUserVerifiedTypeOrgWebsite :    //官网认证
            self.verifiedView.hidden = NO;
            self.verifiedView.image = [UIImage imageNamed:@"avatar_enterprise_vip"];
            break;
        
        case JKUserVerifiedTypePersonal:        //个人认证
            self.verifiedView.hidden = NO;
            self.verifiedView.image = [UIImage imageNamed:@"avatar_vip"];
            break;
        
        case JKUserVerifiedTypeDaren:           //达人认证
            self.verifiedView.hidden = NO;
            self.verifiedView.image = [UIImage imageNamed:@"avatar_grassroot"];
            break;
            
        default:
            self.verifiedView.hidden = YES;      //当作用户没有认证，不显示认证图片，省略几行代码
            break;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    //认证图片靠右下显示，具体位置可能依scale轻微移动
    CGFloat scale = 0.6;
    self.verifiedView.x = self.width - self.verifiedView.width * scale;
    self.verifiedView.y = self.height - self.verifiedView.height * scale;
}

@end
