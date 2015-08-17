//
//  JKDiscoverViewController.m
//  微博demo
//
//  Created by 史江凯 on 15/6/30.
//  Copyright (c) 2015年 史江凯. All rights reserved.
//

#import "JKDiscoverViewController.h"
#import "JKSearchBar.h"

@interface JKDiscoverViewController ()

@end

@implementation JKDiscoverViewController

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
    self.view.backgroundColor = [UIColor grayColor];
//    设置顶部搜索框
    JKSearchBar *searchBar = [JKSearchBar searchBar];
    searchBar.frame = CGRectMake(0, 0, 300, 30);
    searchBar.background = [UIImage imageNamed:@"searchbar_textfield_background"];
    //设置搜索框左边的放大镜
    UIImageView *searchIcon = [[UIImageView alloc] init];
    searchIcon.frame = CGRectMake(0, 0, 30, 30);
    searchIcon.image = [UIImage imageNamed:@"searchbar_textfield_search_icon"];
    //图片居中显示
    searchIcon.contentMode = UIViewContentModeCenter;
//    [searchBar addSubview:searchIcon];
    searchBar.leftView = searchIcon;
    //设置一直显示，否则会看不见放大镜这个leftView
    searchBar.leftViewMode = UITextFieldViewModeAlways;
    self.navigationItem.titleView = searchBar;
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
