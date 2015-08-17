//
//  JKEmotionListView.m
//  微博demo
//
//  Created by 史江凯 on 15/7/8.
//  Copyright (c) 2015年 史江凯. All rights reserved.
//




#import "JKEmotionListView.h"
#import "JKEmotionPageView.h"

@interface JKEmotionListView () <UIScrollViewDelegate>

@property (nonatomic, weak) UIScrollView *scrollView;

@property (nonatomic, weak) UIPageControl *pageControl;

@end
@implementation JKEmotionListView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];

        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.delegate = self;
        scrollView.pagingEnabled = YES;
        scrollView.bounces = NO;
        //去除垂直和水平方向的滚动条，以保证scrollView的subviews都是自定义的用来显示表情的UIView（pageView）
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:scrollView];
        self.scrollView = scrollView;
        
        UIPageControl *pageControl = [[UIPageControl alloc] init];
        pageControl.userInteractionEnabled = NO;
        //只有一页时，隐藏pageControl
        pageControl.hidesForSinglePage = YES;
        [self addSubview:pageControl];
        [pageControl setValue:[UIImage imageNamed:@"compose_keyboard_dot_selected"] forKeyPath:@"currentPageImage"];
        [pageControl setValue:[UIImage imageNamed:@"compose_keyboard_dot_normal"] forKeyPath:@"pageImage"];
        self.pageControl = pageControl;
    }
    return self;
}

//根据传进来的emotions，创建对应个数的表情pageView
- (void)setEmotions:(NSArray *)emotions
{
    _emotions = emotions;
    //针对‘最近’选项卡，先移除每一页，再加载最近表情
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    //最大页数，根据emotions.count变化
    NSUInteger count = (emotions.count + JKEmotionsMaxCountOfPerPage - 1) / JKEmotionsMaxCountOfPerPage;
    self.pageControl.numberOfPages = count;

    for (int i = 0; i < count; i++) {
        JKEmotionPageView *pageView = [[JKEmotionPageView alloc] init];
        //计算每一页的表情范围
        NSRange range;
        //每一页从哪个地方开始截
        range.location = i * JKEmotionsMaxCountOfPerPage;
        //比较剩下的表情个数和每页最大数，前几页剩余数大于每页最大数，取每页最大数20
        //（最后一页）截取的表情个数不够（小于）最大数（20）时，就截取剩下的。
        range.length = MIN(emotions.count - range.location, JKEmotionsMaxCountOfPerPage);
        //每一页只显示自己截取到的子数组
        pageView.emotions = [emotions subarrayWithRange:range];
//        pageView.backgroundColor = JKRandomColor;
        [self.scrollView addSubview:pageView];
    }
    //重新设置子控件的frame    
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    //设置pageControl的frame
    self.pageControl.width = self.width;
    self.pageControl.height = 25;
    self.pageControl.x = 0;
    self.pageControl.y = self.height - self.pageControl.height;
    
    //设置scrollView的frame
    self.scrollView.width = self.width;
    self.scrollView.height = self.pageControl.y;
    self.scrollView.x = 0;
    self.scrollView.y = 0;

    //设置scrollView的contentSize
    NSUInteger count = self.scrollView.subviews.count;
    self.scrollView.contentSize = CGSizeMake(count * self.scrollView.width, 0);

    //设置scrollView里的每一个pageView的frame
    for (int i = 0; i < self.scrollView.subviews.count; i++) {
        JKEmotionPageView *pageView = self.scrollView.subviews[i];
        pageView.x = i * self.scrollView.width;
        pageView.y = 0;
        pageView.width = self.scrollView.width;
        pageView.height = 150;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.pageControl.currentPage = (int)(scrollView.contentOffset.x / scrollView.width + 0.5);
}

@end
