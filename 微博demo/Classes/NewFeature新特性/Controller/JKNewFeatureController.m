//
//  JKNewFeatureController.m
//  微博demo
//
//  Created by 史江凯 on 15/7/1.
//  Copyright (c) 2015年 史江凯. All rights reserved.
//

#import "JKNewFeatureController.h"
#import "JKTabBarController.h"

@interface JKNewFeatureController () <UIScrollViewDelegate>
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIPageControl *pageControl;
@end

@implementation JKNewFeatureController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = self.view.bounds;
//    CGFloat scrollW = scrollView.width;
//    CGFloat scrollH = scrollView.height;

    //height赋值为0，代表垂直方向不能滚动
    scrollView.contentSize = CGSizeMake(4 * scrollView.width, 0);
    
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.bounces = NO;
    scrollView.delegate = self;
    self.scrollView = scrollView;
    [self.view addSubview:scrollView];

    for ( int i = 0; i<4; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        NSString *imageName = [NSString stringWithFormat:@"new_feature_%d", i+1];
        imageView.image = [UIImage imageNamed:imageName];
        imageView.size = imageView.image.size;
        imageView.x = i * imageView.width;
//        imageView.width = scrollW;
//        imageView.height = scrollH;
//        imageView.y = 0;
//        imageView.x = i * scrollW;
        //设置最后一个imageView
        if (i == 3) {
            [self setupLastImageView:imageView];
        }
        [scrollView addSubview:imageView];
    }
    
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.numberOfPages = 4;
    pageControl.centerX = scrollView.width * 0.5;
    pageControl.centerY = scrollView.height - 50;
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    self.pageControl = pageControl;
    [self.view addSubview:pageControl];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.pageControl.currentPage = (int)(scrollView.contentOffset.x / scrollView.width + 0.5);
}

- (void)setupLastImageView:(UIImageView *)imageView
{
    imageView.userInteractionEnabled = YES;

    //分享按钮
    UIButton *shareBtn = [[UIButton alloc] init];
    //设置按钮图片
    [shareBtn setImage:[UIImage imageNamed:@"new_feature_share_false"] forState:UIControlStateNormal];
    [shareBtn setImage:[UIImage imageNamed:@"new_feature_share_true"] forState:UIControlStateSelected];
    //设置按钮文字
    [shareBtn setTitle:@"分享给大家" forState:UIControlStateNormal];
    [shareBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    shareBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    //按钮靠下居中显示
    shareBtn.width = 200;
    shareBtn.height = 30;
    //不能使用imageView的centerX设置shareBtn,最后一个imageView的centerX ＝＝ 1120；
//    NSLog(@"----%f", imageView.centerX);
    shareBtn.centerX = imageView.width * 0.5;
    shareBtn.centerY = imageView.height * 0.65;
    //文字和图片之间有个间距
    shareBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 15);
    
    [shareBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:shareBtn];
    
    //开始微博按钮
    UIButton *startBtn = [[UIButton alloc] init];
    
    //设置按钮图片
    [startBtn setBackgroundImage:[UIImage imageNamed:@"new_feature_finish_button"] forState:UIControlStateNormal];
    [startBtn setBackgroundImage:[UIImage imageNamed:@"new_feature_finish_button_highlighted"] forState:UIControlStateSelected];
    startBtn.size = startBtn.currentBackgroundImage.size;
    startBtn.centerX = shareBtn.centerX;
    startBtn.centerY = imageView.height * 0.75;
    //设置按钮文字
    [startBtn setTitle:@"开始微博" forState:UIControlStateNormal];
    [startBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    startBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [startBtn addTarget:self action:@selector(startBtnClick) forControlEvents:UIControlEventTouchUpInside];

    [imageView addSubview:startBtn];
}

- (void)shareBtnClick:(UIButton *)shareBtn
{
    shareBtn.selected = !shareBtn.selected;
}

//开始微博，切换到TabBarController页面
- (void)startBtnClick
{
    //获得主窗口
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    //切换主窗口的根控制器，执行完后JKNewFeatureController会被销毁。
    //这里不使用push或modal方式切换控制器，两种方式控制器不会销毁
    window.rootViewController = [[JKTabBarController alloc] init];
}

@end
