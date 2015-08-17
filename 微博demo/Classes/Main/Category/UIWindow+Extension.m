//
//  UIWindow+Extension.m
//  微博demo
//
//  Created by 史江凯 on 15/7/3.
//  Copyright (c) 2015年 史江凯. All rights reserved.
//

#import "UIWindow+Extension.h"
#import "JKTabBarController.h"
#import "JKNewFeatureController.h"

@implementation UIWindow (Extension)
- (void)switchRootViewController
{
    //判断版本号，是否显示新特性界面
    NSString *key = @"CFBundleVersion";
    //从沙盒中取出上次版本号
    NSString *lastVersion = [[NSUserDefaults standardUserDefaults] valueForKey:key];
    
    //从软件中读取当前版本号
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
    if ([currentVersion isEqualToString:lastVersion]) {
        //版本号相同，直接显示TabBarController页面
        NSLog(@"%@", currentVersion);
        self.rootViewController = [[JKTabBarController alloc] init];
    } else {
        //版本号不同，显示新特性
        self.rootViewController = [[JKNewFeatureController alloc] init];
        //将当前版本号写入沙盒，立即同步，否则会有延时。也可以在新特性页面点击开始微博按钮后才写入沙盒。
        [[NSUserDefaults standardUserDefaults] setValue:currentVersion forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }

}
@end
