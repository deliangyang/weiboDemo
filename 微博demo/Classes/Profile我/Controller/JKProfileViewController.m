//
//  JKProfileViewController.m
//  微博demo
//
//  Created by 史江凯 on 15/6/30.
//  Copyright (c) 2015年 史江凯. All rights reserved.
//

#import "JKProfileViewController.h"
#import "JKTest1ViewController.h"
#import "SDWebImageManager.h"

@interface JKProfileViewController ()

@end

@implementation JKProfileViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    //设置导航栏右侧按钮，弹出一个JKTest1ViewController
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"pushTestVC" style:UIBarButtonItemStylePlain target:self action:@selector(pushTestVC)];

    //设置导航栏右侧按钮，清除缓存，（图片缓存，利用SDWebImage）
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"清除缓存" style:UIBarButtonItemStylePlain target:self action:@selector(clearCache)];

    NSUInteger byteSize = [SDImageCache sharedImageCache].getSize;

    self.navigationItem.title = [NSString stringWithFormat:@"缓存大小：%.1f M", byteSize / 1000.0 / 1000.0];
    [self fileOperation];
}

- (void)fileOperation
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    [fileManager removeItemAtPath:cachesPath error:nil];//删除Caches文件夹下的所有内容
//    NSString *test = @"/Users/shijiangkai/Desktop/ios常见问题.docx";
    
//    [fileManager contentsOfDirectoryAtPath:cachesPath error:nil];//a shallow search 只有一层，不会层层遍历
    
//    [fileManager subpathsAtPath:cachesPath];//遍历
    //    NSDictionary *dict = [fileManager attributesOfItemAtPath:cachesPath error:nil];
//    NSArray *subpaths = [fileManager subpathsOfDirectoryAtPath:cachesPath error:nil];//遍历
//    NSInteger totalByteSize = 0;
//    for (NSString *subpath in subpaths) {
//        NSString *fullSubpath = [cachesPath stringByAppendingPathComponent:subpath];
//        
//        BOOL isDir = NO;
//        [fileManager fileExistsAtPath:fullSubpath isDirectory:&isDir];//判断文件或文件夹是否存在于给定路径
//        if (isDir == NO) {
//            //不是文件夹，说明是文件
//            NSDictionary *dict = [fileManager attributesOfItemAtPath:fullSubpath error:nil];
//            totalByteSize += [dict[NSFileSize] longLongValue];
//        } else {
//            //是文件夹
//            NSLog(@"%@", fullSubpath);
//        }
//     写进了NSString的分类，对象方法fileSize，返回字节数
//    }
//    NSLog(@"%f", totalByteSize / 1000.0 / 1000.0);
//    NSLog(@"%d", [cachesPath fileSize]);
//    NSLog(@"%d", [@"/Users/shijiangkai/Desktop/资料/工具/01-服务器/01-eclipse-jee-kepler-SR2-macosx-cocoa-x86_64.tar.gz" fileSize]);
//    NSLog(@"%d", [@"dfkaj" fileSize]);//返回-1，说明参数非法，不是文件，也不是文件夹
//    NSLog(@"%d", [@"/Users/shijiangkai/Desktop/我是空文件夹" fileSize]);//返回0
}

- (void)clearCache
{
    UIActivityIndicatorView *circle = [[UIActivityIndicatorView alloc] init];
    [circle startAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:circle];
    
    [[SDImageCache sharedImageCache] clearDisk];
    
    //清除完缓存后，还要更新rightBarButtonItem 和 navigationItem.title
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"清除缓存" style:UIBarButtonItemStylePlain target:self action:@selector(clearCache)];
    
    self.navigationItem.title = @"缓存大小：0 M";
}

- (void)pushTestVC
{
    JKTest1ViewController *test1VC = [[JKTest1ViewController alloc] init];
    [self.navigationController pushViewController:test1VC animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return 0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
//*/
//
///*
//// Override to support conditional editing of the table view.
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    // Return NO if you do not want the specified item to be editable.
//    return YES;
//}
//*/
//
///*
//// Override to support editing the table view.
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        // Delete the row from the data source
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
//        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//    }   
//}
//*/
//
///*
//// Override to support rearranging the table view.
//- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
//{
//}
//*/
//
///*
//// Override to support conditional rearranging of the table view.
//- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    // Return NO if you do not want the item to be re-orderable.
//    return YES;
//}
//*/
//
///*
//#pragma mark - Navigation
//
//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//}
//*/

@end
