//
//  JKTabBarController.m
//  微博demo
//
//  Created by 史江凯 on 15/6/30.
//  Copyright (c) 2015年 史江凯. All rights reserved.
//

#import "JKTabBarController.h"
#import "JKNavController.h"
#import "JKProfileViewController.h"
#import "JKHomeViewController.h"
#import "JKMessageCenterViewController.h"
#import "JKDiscoverViewController.h"
#import "JKTabBar.h"
#import "JKComposeViewController.h"

@interface JKTabBarController () <JKTabBarDelegate>

@end

@implementation JKTabBarController

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
    
    //创建四个模块，添加至TabBarController，设置两种图片，上部导航栏和底下TabBar的title
    
    JKHomeViewController *homeVC = [[JKHomeViewController alloc] init];
    homeVC.title = @"首页";
    [self addChildVCWithChildVC:homeVC image:@"tabbar_home" selectedImage:@"tabbar_home_selected"];
    
    JKMessageCenterViewController *messageCenterVC = [[JKMessageCenterViewController alloc] init];
    messageCenterVC.title = @"消息";
    [self addChildVCWithChildVC:messageCenterVC image:@"tabbar_message_center" selectedImage:@"tabbar_message_center_selected"];
    
    JKDiscoverViewController *discoverVC = [[JKDiscoverViewController alloc] init];
    discoverVC.title = @"发现";
    [self addChildVCWithChildVC:discoverVC image:@"tabbar_discover" selectedImage:@"tabbar_discover_selected"];
    
    JKProfileViewController *profileVC = [[JKProfileViewController alloc] init];
    profileVC.title = @"我";
    [self addChildVCWithChildVC:profileVC image:@"tabbar_profile" selectedImage:@"tabbar_profile_selected"];
    
    //替换系统的tabBar为自定义JKTabBar。self.tabBar是只读的
    JKTabBar *tabBar = [[JKTabBar alloc] init];
    //这一句注释掉也可以
    //tabBar.delegate = self;
    [self setValue:tabBar forKeyPath:@"tabBar"];
    //在此设置代理会崩溃
//    tabBar.delegate = self;

}

- (void)addChildVCWithChildVC:(UIViewController *)childVC image:(NSString *)image selectedImage:(NSString *)selectedImage
{
//    UIImage *NormalImage = [UIImage imageNamed:image];
//    UIImage *seleImage = [UIImage imageNamed:selectedImage];
    //设置两种状态下的图片，特别是选中时图片不能被系统渲染成蓝色，要保持原来的橙色
    childVC.tabBarItem.image = [UIImage imageNamed:image];
    if (iOS7) {
        childVC.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    } else {
        childVC.tabBarItem.selectedImage = [UIImage imageNamed:selectedImage];
    }

    //设置两种状态下的文字样式
    NSMutableDictionary *normalTextAttrs = [[NSMutableDictionary alloc] init];
    normalTextAttrs[NSForegroundColorAttributeName] = [UIColor colorWithRed:123/255.0 green:123/255.0 blue:123/255.0 alpha:123/255.0];
    [childVC.tabBarItem setTitleTextAttributes:normalTextAttrs forState:UIControlStateNormal];
    
    NSMutableDictionary *selectedTextAttrs = [[NSMutableDictionary alloc] init];
    selectedTextAttrs[NSForegroundColorAttributeName] = [UIColor orangeColor];
    [childVC.tabBarItem setTitleTextAttributes:selectedTextAttrs forState:UIControlStateSelected];
    

    //每个模块都是各自导航控制器的根控制器
    JKNavController *nav = [[JKNavController alloc] initWithRootViewController:childVC];
    //添加每个nav控制器至tabBarVC
    [self addChildViewController:nav];
}

- (void)didClickPlusButtonInTabBar:(JKTabBar *)tabBar
{
    JKComposeViewController *composeVC = [[JKComposeViewController alloc] init];
    JKNavController *navVC = [[JKNavController alloc] initWithRootViewController:composeVC];
    [self presentViewController:navVC animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
