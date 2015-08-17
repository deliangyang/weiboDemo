//
//  JKStatusCellToolbar.m
//  微博demo
//
//  Created by 史江凯 on 15/7/5.
//  Copyright (c) 2015年 史江凯. All rights reserved.
//

#import "JKStatusCellToolbar.h"
#import "JKStatus.h"

#define kStatusCellToolbarFont [UIFont systemFontOfSize:13]

@interface JKStatusCellToolbar ()

/**存放三个按钮*/
@property (nonatomic, strong) NSMutableArray *btns;

/**存放按钮之间的分割线*/
@property (nonatomic, strong) NSMutableArray *dividers;

/**转发按钮*/
@property (nonatomic, weak) UIButton *repostBtn;

/**评论按钮*/
@property (nonatomic, weak) UIButton *commentBtn;

/**赞，按钮*/
@property (nonatomic, weak) UIButton *attitudeBtn;

@end

@implementation JKStatusCellToolbar

- (NSMutableArray *)btns
{
    if (!_btns) {
        self.btns = [[NSMutableArray alloc] init];
    }
    return _btns;
}

- (NSMutableArray *)dividers
{
    if (!_dividers) {
        self.dividers = [[NSMutableArray alloc] init];
    }
    return _dividers;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //工具条的背景
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"timeline_card_bottom_background"]];
        //创建三个按钮
        self.repostBtn = [self addBtnWithTitle:@"转发" icon:@"timeline_icon_retweet"];
        self.commentBtn = [self addBtnWithTitle:@"评论" icon:@"timeline_icon_comment"];
        self.attitudeBtn = [self addBtnWithTitle:@"赞" icon:@"timeline_icon_unlike"];
        
        //添加分割线
        [self addDividers];
        [self addDividers];
        }
    return self;
}

//添加分割线
- (void)addDividers
{
    UIImageView *divider = [[UIImageView alloc] init];
    divider.image = [UIImage imageNamed:@"timeline_card_bottom_line"];
    [self addSubview:divider];
    [self.dividers addObject:divider];
    
}

//创建三个按钮，添加到工具条上，加入到按钮数组
- (UIButton *)addBtnWithTitle:(NSString *)title icon:(NSString *)icon
{
    UIButton *btn = [[UIButton alloc] init];
    
    [btn setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];//文字左边有个间距
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    btn.titleLabel.font = kStatusCellToolbarFont;
    
    [btn setBackgroundImage:[UIImage imageNamed:@"timeline_card_bottom_background_highlighted"] forState:UIControlStateHighlighted];

    [self addSubview:btn];
    
    [self.btns addObject:btn];
    
    return btn;
}

//重新布局子控件
- (void)layoutSubviews
{
    [super layoutSubviews];

    //按钮
    NSUInteger btnCount = self.btns.count;
    CGFloat btnW = self.width / btnCount;
    CGFloat btnH = self.height;
    for (int i = 0; i < btnCount; i++) {
        UIButton *btn = self.btns[i];
        btn.x = i * btnW;
        btn.y = 0;
        btn.width = btnW;
        btn.height = btnH;
    }
    //分割线
    NSUInteger dividerCount = self.dividers.count;
    for (int i = 0; i < dividerCount; i++) {
        UIImageView *divider = self.dividers[i];
        divider.x = (i + 1) * btnW;
        divider.y = 0;
        divider.width = 1;
        divider.height = btnH;
    }
}

+ (instancetype)toolbar
{
    return [[self alloc] init];
}

- (void)setStatus:(JKStatus *)status
{
    _status = status;
    //传入微博模型时，根据模型内的三个属性设置按钮显示的数字
    [self setupBtnCount:status.reposts_count title:@"转发" OfBtn:self.repostBtn];
    [self setupBtnCount:status.comments_count title:@"评论" OfBtn:self.commentBtn];
    [self setupBtnCount:status.attitudes_count title:@"赞" OfBtn:self.attitudeBtn];
}

- (void)setupBtnCount:(int)count title:(NSString *)title OfBtn:(UIButton *)btn
{
    if (count) {
        if (count < 10000) {
            //数字小于一万,直接显示
            title = [NSString stringWithFormat:@"%d", count];
        } else {
            //数字大于一万，显示格式xx.x万，除以10000，取1位小数
            title = [NSString stringWithFormat:@"%.1f", count / 10000.0];
            //如果是xx.0万的情况，去除‘.0’
            title = [title stringByReplacingOccurrencesOfString:@".0" withString:@""];
        }
    }
    [btn setTitle:title forState:UIControlStateNormal];
}

@end
