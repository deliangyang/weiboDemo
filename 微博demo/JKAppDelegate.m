//
//  JKAppDelegate.m
//  微博demo
//
//  Created by 史江凯 on 15/6/30.
//  Copyright (c) 2015年 ___FULLUSERNAME___. All rights reserved.
//

#import "JKAppDelegate.h"

#import "JKOAuthViewController.h"
#import "JKTabBarController.h"
#import "JKNewFeatureController.h"
#import "JKAccountTool.h"
#import "SDWebImageManager.h"

@implementation JKAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //创建窗口
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    self.window = [[UIWindow alloc] init];
//    self.window.frame = [UIScreen mainScreen].bounds;
    //获取账号文件
    JKAccount *account = [JKAccountTool account];
    if (account) {//账号文件存在，说明之前成功登录过，判断版本号，是否显示新特性
        //切换控制器
        [self.window switchRootViewController];
    } else {//没有成功登录过
        self.window.rootViewController = [[JKOAuthViewController alloc] init];
    }
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    //程序进入后台时，向操作系统申请后台运行资格，不确定运行多久，程序可能被系统杀掉
    //在info.plist中添加Required background modes，可以设为多媒体播放，利用一个0KB的MP3文件播放，实现一直在后台运行    
    UIBackgroundTaskIdentifier task = [application beginBackgroundTaskWithExpirationHandler:^{
        [application endBackgroundTask:task];
    }];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    SDWebImageManager *mgr = [SDWebImageManager sharedManager];
    [mgr cancelAll];
    [mgr.imageCache clearMemory];
}

@end
