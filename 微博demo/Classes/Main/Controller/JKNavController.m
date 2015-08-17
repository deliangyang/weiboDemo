//
//  JKNavController.m
//  微博demo
//
//  Created by 史江凯 on 15/6/30.
//  Copyright (c) 2015年 史江凯. All rights reserved.
//

#import "JKNavController.h"
#import "JKNavItem.h"

@interface JKNavController ()

@end

@implementation JKNavController

+ (void)initialize
{
    //设置整个项目所有（普通文字型）NavItem的主题样式
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    
    //普通状态下的文字大小，颜色
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:15];
    attrs[NSForegroundColorAttributeName] = [UIColor orangeColor];
    [item setTitleTextAttributes:attrs forState:UIControlStateNormal];
    
    //不可用状态下的文字大小，颜色
    NSMutableDictionary *stateDisabledAttrs = [NSMutableDictionary dictionary];
    stateDisabledAttrs[NSFontAttributeName] = attrs[NSFontAttributeName];
    stateDisabledAttrs[NSForegroundColorAttributeName] = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.7];
    [item setTitleTextAttributes:stateDisabledAttrs forState:UIControlStateDisabled];
}

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
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //不是根控制器时才需要显示左右两侧的navigationItem
    if (self.viewControllers.count > 0) {

        //利用自定义navItem设置左右两侧的navItem
        viewController.navigationItem.leftBarButtonItem = [JKNavItem navItemWithTarget:self action:@selector(back) image:@"navigationbar_back" selectedImage:@"navigationbar_back_highlighted"];
        viewController.navigationItem.rightBarButtonItem = [JKNavItem navItemWithTarget:self action:@selector(more) image:@"navigationbar_more" selectedImage:@"navigationbar_more_highlighted"];

        //只有是四个主要模块是才显示TabBarItem
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

- (void)back
{
    [self popViewControllerAnimated:YES];
    NSLog(@"back");
}

- (void)more
{
    NSLog(@"more");
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
