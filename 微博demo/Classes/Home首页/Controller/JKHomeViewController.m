//
//  JKHomeViewController.m
//  微博demo
//
//  Created by 史江凯 on 15/6/30.
//  Copyright (c) 2015年 史江凯. All rights reserved.
//

#import "JKHomeViewController.h"
#import "JKNavItem.h"
#import "JKDropDownMenu.h"
#import "JKTestDropDownController.h"
#import "AFNetworking.h"
#import "JKAccountTool.h"
#import "JKTitleButton.h"
#import "JKStatus.h"
#import "JKUser.h"
#import "MJExtension.h"
#import "JKLoadMoreFooter.h"
#import "UIImageView+WebCache.h"
#import "JKStatusCell.h"
#import "JKStatusFrame.h"
#import "JKStatusTool.h"
#import "MJRefresh.h"


@interface JKHomeViewController () <JKDropDownMenuDelegate>

/**微博数组*/
@property (nonatomic, strong) NSMutableArray *statusFrames;

@end

@implementation JKHomeViewController

- (NSMutableArray *)statusFrames
{
    if (!_statusFrames) {
        self.statusFrames = [NSMutableArray array];
    }
    return _statusFrames;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor colorWithRed:211/255.0 green:211/255.0 blue:211/255.0 alpha:1.0];
    //设置导航条左中右内容
    [self setupNavItem];
//暂时关闭，以调试表情
    //获得用户昵称，为了设置导航条的titleView
    [self setupUserInfo];
//
//    //第一次获取微博数据时，可以通过一次自动下拉刷新实现
//    [self loadNewStatusTimeline];
    //下拉刷新
    [self setupRefresh];
//
    //底部的上拉刷新
    [self setupUpRefresh];
//
//    //设置一个定时器，持续获取未读微博数
//    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(setupUnreadCount) userInfo:nil repeats:YES];
//    //以NSRunLoopCommonModes模式，将定时器添加到运行循环中，以便主线程持续处理。否则主线程处理其他事件（如滚动tableView）时，会停止获取未读数
//    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

//获得未读微博数
- (void)setupUnreadCount
{
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    // 2.拼接请求参数
    JKAccount *account = [JKAccountTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    params[@"uid"] = account.uid;
    // 3.发送请求
    [mgr GET:@"https://rm.api.weibo.com/2/remind/unread_count.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //返回的数据中取出@"status"对应的未读数，是一个NSNumber，需要转成字符串，以便设置tabBarItem的badgeValue
        NSString *status = [responseObject[@"status"] description];
        if ([status isEqualToString:@"0"]) {
            //未读数是 ‘0’
            //self在这里即是首页控制器，拿到的tabBarItem就是首页图标
            self.tabBarItem.badgeValue = nil;//清空之前图标上的未读数
            [UIApplication sharedApplication].applicationIconBadgeNumber = 0;//应用程序图标未读数为 0 时，0会自动隐藏
        } else {//未读数非0
            self.tabBarItem.badgeValue = status;//badgeValue是NSString类型
            [UIApplication sharedApplication].applicationIconBadgeNumber = status.integerValue;
            //进入后台后将不能更新applicationIconBadgeNumber，需要在JKAppDelegate实现后台运行的方法
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败-%@", error);

    }];
}

//底部的上拉刷新
- (void)setupUpRefresh
{
//    JKLoadMoreFooter *footer = [JKLoadMoreFooter footer];
//    self.tableView.tableFooterView = footer;
//    //一开始时隐藏，手动拉到底部时再显示
//    footer.hidden = YES;
    //使用MJRefresh
    [self.tableView addFooterWithTarget:self action:@selector(loadMoreStatus)];
}

//监听滚动，判断是否要上拉刷新，加载更多（较早）微博
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    //如果tableView没有数据或footer已经显示，直接返回
//    if (!self.statusFrames.count || self.tableView.tableFooterView.isHidden == NO) return;
//    //
//    CGFloat offsetY = scrollView.contentOffset.y;
//    //
//    CGFloat judgeOffsetY = scrollView.contentSize.height + scrollView.contentInset.bottom - scrollView.height - self.tableView.tableFooterView.height;
//    if (offsetY >= judgeOffsetY) {
//        //显示上拉刷新
//        self.tableView.tableFooterView.hidden = NO;
//        //加载更多微博（较早的微博）
//        [self loadMoreStatus];
//    }                                     
//}

//根据statuse模型数组转为statusFrames模型数组
- (NSMutableArray *)statusFramesArrayWithStatusesArray:(NSArray *)newStatuses
{
    NSMutableArray *newFrames = [NSMutableArray array];
    for (JKStatus *status in newStatuses) {
        JKStatusFrame *statusFrame = [[JKStatusFrame alloc] init];
        statusFrame.status = status;
        [newFrames addObject:statusFrame];
    }
    return newFrames;
}

//加载更多微博（较早的微博）
- (void)loadMoreStatus
{
    // 1.请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    // 2.拼接请求参数
    JKAccount *account = [JKAccountTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    
    // 取出最后面的微博（）
    JKStatusFrame *lastStatusFrame = [self.statusFrames lastObject];
    if (lastStatusFrame) {
        // 若指定此参数，则返回ID小于或等于max_id的微博，默认为0。
        // id这种数据一般都是比较大的，一般转成整数的话，最好是long long类型 -1是为了防止重复
        long long maxId = lastStatusFrame.status.idstr.longLongValue - 1;
        params[@"max_id"] = @(maxId);
    }
    
    //将一些相同代码写成一个block
    void (^dealingResult)(NSArray *) = ^(NSArray *statuses){
        NSArray *newStatuses = [JKStatus objectArrayWithKeyValuesArray:statuses];
        NSArray *newFrames = [self statusFramesArrayWithStatusesArray:newStatuses];
        
        // 将更多的微博数据，添加到总数组的最后面
        [self.statusFrames addObjectsFromArray:newFrames];
        
        // 刷新表格
        [self.tableView reloadData];
        
        // 结束刷新(隐藏footer)
        //self.tableView.tableFooterView.hidden = YES;
        //MJRefresh结束上拉刷新
        [self.tableView footerEndRefreshing];
    };
    
    //先尝试从数据库中加载微博数据
    NSArray *statuses = [JKStatusTool statusesWithParams:params];
    if (statuses.count) {
//        NSArray *newStatuses = [JKStatus objectArrayWithKeyValuesArray:statuses];
//        NSArray *newFrames = [self statusFramesArrayWithStatusesArray:newStatuses];
//        
//        // 将更多的微博数据，添加到总数组的最后面
//        [self.statusFrames addObjectsFromArray:newFrames];
//        
//        // 刷新表格
//        [self.tableView reloadData];
//        
//        // 结束刷新(隐藏footer)
//        self.tableView.tableFooterView.hidden = YES;
        dealingResult(statuses);
    } else {
        
        // 3.发送请求
        [mgr GET:@"https://api.weibo.com/2/statuses/friends_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
            
            //将服务器返回的[@"statuses"]对应的字典数组，存进数据库
            [JKStatusTool saveStatuses:responseObject[@"statuses"]];
            
//            // 将 "微博字典"数组 转为 "微博模型"数组
//            NSArray *newStatuses = [JKStatus objectArrayWithKeyValuesArray:responseObject[@"statuses"]];
//            
//            NSArray *newFrames = [self statusFramesArrayWithStatusesArray:newStatuses];
//            
//            // 将更多的微博数据，添加到总数组的最后面
//            [self.statusFrames addObjectsFromArray:newFrames];
//            
//            // 刷新表格
//            [self.tableView reloadData];
//            
//            // 结束刷新(隐藏footer)
//            self.tableView.tableFooterView.hidden = YES;
            
            dealingResult(responseObject[@"statuses"]);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"请求失败-%@", error);
            
            // 结束刷新
            //self.tableView.tableFooterView.hidden = YES;
            [self.tableView footerEndRefreshing];
        }];
    }
    

}

//创建下拉刷新，添加监听事件
- (void)setupRefresh
{
//    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
//    [refreshControl addTarget:self action:@selector(refreshStateChange:) forControlEvents:UIControlEventValueChanged];
//
//    [self.tableView addSubview:refreshControl];
    
    //马上进入刷新状态，仅仅是UI上显示刷新状态，并不会触发UIControlEventValueChanged，还需要手动调用
//    [refreshControl beginRefreshing];

    //手动调用一次下拉刷新事件，相当于做了一次自动下拉刷新
    //[self refreshStateChange:refreshControl];
//    [self showNewStatusCount:0];
    
    //MJRefresh下拉刷新
    [self.tableView addHeaderWithTarget:self action:@selector(refreshStateChange)];
    //header主动刷新一次
    [self.tableView headerBeginRefreshing];
}

//下拉刷新，获取最新微博
- (void)refreshStateChange
{
#warning 假数据～～～
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        NSDictionary *responseObject = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"fakeStatus" ofType:@"plist"]];
//        // 将 "微博字典"数组 转为 "微博模型"数组
//        
//        NSArray *newStatuses = [JKStatus objectArrayWithKeyValuesArray:responseObject[@"statuses"]];
//
//        
//        // 将 HWStatus数组 转为 HWStatusFrame数组
//        NSArray *newFrames = [self statusFramesArrayWithStatusesArray:newStatuses];
//        
//        // 将最新的微博数据，添加到总数组的最前面
//        NSRange range = NSMakeRange(0, newFrames.count);
//        NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:range];
//        [self.statusFrames insertObjects:newFrames atIndexes:set];
//        
//        // 刷新表格
//        [self.tableView reloadData];
//        
//        // 结束刷新
//        //[refreshControl endRefreshing];
//        //MJRefresh结束刷新
//        [self.tableView headerEndRefreshing];
//        
//        // 显示最新微博的数量
//        [self showNewStatusCount:newStatuses.count];
//    });
//    
//    return;
//    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    //利用JKAccountTool获得账号
    JKAccount *account = [JKAccountTool account];
    params[@"access_token"] = account.access_token;

    //当前屏幕上的第一条微博（没有刷新前还依然是最新的微博），ID最大
    JKStatusFrame *firstStatusFrame = [self.statusFrames firstObject];
    if (firstStatusFrame) {
        //指定since_id，返回ID比since_id大的微博，即比since_id还新（还晚）的的微博，默认是0
        params[@"since_id"] = firstStatusFrame.status.idstr;
    }
    
    //将一些相同代码写成一个block
    void (^dealingResult)(NSArray *) = ^(NSArray *statuses){
        NSArray *newStatuses = [JKStatus objectArrayWithKeyValuesArray:statuses];
        NSArray *newFrames = [self statusFramesArrayWithStatusesArray:newStatuses];
        
        //下拉刷新得到的数组添加到总数组的最前面
        NSRange range = NSMakeRange(0, newFrames.count);
        NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:range];
        [self.statusFrames insertObjects:newFrames atIndexes:set];
        
        //刷新表格
        [self.tableView reloadData];
        //结束下拉刷新
        //[refreshControl endRefreshing];
        //MJRefresh结束刷新
        [self.tableView headerEndRefreshing];
        
        //显示下拉刷新得到的最新微博的数量
        [self showNewStatusCount:newStatuses.count];
    };
    
    //先尝试从数据库中加载微博数据
    NSArray *statuses = [JKStatusTool statusesWithParams:params];
    if (statuses.count) {

//        本段写成了一个block，以简化代码
//        NSArray *newStatuses = [JKStatus objectArrayWithKeyValuesArray:statuses];
//        
//        NSArray *newFrames = [self statusFramesArrayWithStatusesArray:newStatuses];
//        
//        //下拉刷新得到的数组添加到总数组的最前面
//        NSRange range = NSMakeRange(0, newFrames.count);
//        NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:range];
//        [self.statusFrames insertObjects:newFrames atIndexes:set];
//        
//        //刷新表格
//        [self.tableView reloadData];
//        //结束下拉刷新
//        [refreshControl endRefreshing];
//        
//        //显示下拉刷新得到的最新微博的数量
//        [self showNewStatusCount:newStatuses.count];

        dealingResult(statuses);

    } else {
        
        [manager GET:@"https://api.weibo.com/2/statuses/friends_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //服务器返回的responseObject中，包含了全新的微博，statuses对应的是一个数组，每个数组元素包含了个微博字典
            //objectArrayWithKeyValuesArray方法，通过字典数组来创建一个模型数组
            
            //将服务器返回的[@"statuses"]对应的字典数组，存进数据库
            [JKStatusTool saveStatuses:responseObject[@"statuses"]];
            
//            NSArray *newStatuses = [JKStatus objectArrayWithKeyValuesArray:responseObject[@"statuses"]];
//            
//            NSArray *newFrames = [self statusFramesArrayWithStatusesArray:newStatuses];
//            
//            //下拉刷新得到的数组添加到总数组的最前面
//            NSRange range = NSMakeRange(0, newFrames.count);
//            NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:range];
//            [self.statusFrames insertObjects:newFrames atIndexes:set];
//            
//            //刷新表格
//            [self.tableView reloadData];
//            //结束下拉刷新
//            [refreshControl endRefreshing];
//            
//            //显示下拉刷新得到的最新微博的数量
//            [self showNewStatusCount:newStatuses.count];
            dealingResult(responseObject[@"statuses"]);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"++++++%@", error);
            //如果出错，也需要结束下拉刷新
            //[refreshControl endRefreshing];
            //MJRefresh结束刷新
            [self.tableView headerEndRefreshing];
        }];
    }
}

//显示下拉刷新得到的最新微博的数量
- (void)showNewStatusCount:(NSUInteger)count
{
    //通过一个UILabel，给它设置动画，来显示下拉刷新得到的最新微博的数量
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"timeline_new_status_background"]];
    label.width = [UIScreen mainScreen].bounds.size.width;
    label.height = 35;
    label.y = 64 - label.height;
    if (count) {
        label.text = [NSString stringWithFormat:@"共有%zd条新微博", count];
    } else {
        label.text = @"暂时没有最新微博，稍后再试";
    }
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:16];
    //按钮添加在导航控制器view的上面，导航栏的下面（添加在tableView上会跟着tableView动，添加在window上会挡住其他view
    [self.navigationController.view insertSubview:label belowSubview:self.navigationController.navigationBar];
    
    //按钮下移和返回的动画时长都是1秒
    NSTimeInterval duration = 1.0;
    //动画
    [UIView animateWithDuration:duration animations:^{
        //label下移
//        label.y += label.height;
        label.transform = CGAffineTransformMakeTranslation(0, label.height);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:duration delay:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
            //UIViewAnimationOptionCurveLinear匀速平移，没有加速度或负得加速度EaseIn EaseOut
            //延时1.0秒，再让label回到原来的位置，返回的时长也是1.0秒
//            label.y -= label.height;
            //CGAffineTransformIdentity动画执行前的状态
            label.transform = CGAffineTransformIdentity;

        } completion:^(BOOL finished) {
            //动画结束，移除label
            [label removeFromSuperview];
        }];
    }];
}

- (void)loadNewStatusTimeline
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    //利用JKAccountTool获得账号
    JKAccount *account = [JKAccountTool account];
    params[@"access_token"] = account.access_token;
    params[@"count"] = @2;//调试用，告知服务器要返回的微博条数
    [manager GET:@"https://api.weibo.com/2/statuses/friends_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //服务器返回的responseObject中，statuses对应的是一个数组，每个数组元素包含了个微博字典
//        NSArray *dictArray = responseObject[@"statuses"];
//        for (NSDictionary *dict in dictArray ) {
//            JKStatus *status = [JKStatus objectWithKeyValues:dict];
//            [self.statusFrames addObject:status];
//        }
        
        //服务器返回的responseObject中，包含了全新的微博，statuses对应的是一个数组，每个数组元素包含了个微博字典
        //objectArrayWithKeyValuesArray方法相当于上面的forin方法，通过字典数组来创建一个模型数组
        NSArray *newStatuses = [JKStatus objectArrayWithKeyValuesArray:responseObject[@"statuses"]];
        
        NSArray *newFrames = [self statusFramesArrayWithStatusesArray:newStatuses];
        //下拉刷新得到的数组添加到总数组的最前面
        NSRange range = NSMakeRange(0, newFrames.count);
        NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:range];
        [self.statusFrames insertObjects:newFrames atIndexes:set];


        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"++++++%@", error);
    }];
}

- (void)setupUserInfo
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    NSMutableDictionary *params = [NSMutableDictionary dictionary];

    //利用JKAccountTool获得账号
    JKAccount *account = [JKAccountTool account];
    
    params[@"access_token"] = account.access_token;
    params[@"uid"] = account.uid;

    [manager GET:@"https://api.weibo.com/2/users/show.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //标题按钮
        JKTitleButton *titleButton = (JKTitleButton *)self.navigationItem.titleView;
        //设置按钮名字，显示为用户昵称
        //返回的数据是一个包含了用户信息的字典，转成模型
        JKUser *user = [JKUser objectWithKeyValues:responseObject];
        [titleButton setTitle:user.name forState:UIControlStateNormal];
        //存储昵称到沙盒
        account.name = user.name;
        [JKAccountTool saveAccount:account];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"++++++%@", error);
    }];
}

- (void)setupNavItem
{
    //设置左上角好友搜索的navItem
    self.navigationItem.leftBarButtonItem = [JKNavItem navItemWithTarget:self action:@selector(friendSearch) image:@"navigationbar_friendsearch" selectedImage:@"navigationbar_friendsearch_highlighted"];
    //设置右上角扫描navItem
    self.navigationItem.rightBarButtonItem = [JKNavItem navItemWithTarget:self action:@selector(pop) image:@"navigationbar_pop" selectedImage:@"navigationbar_pop_highlighted"];

    //navigationItem.titleView 使用自定义titleButton，以便调整按钮内部图片和标签的布局（标签在前）
    //自定义按钮，在内部设置好了图片和文字颜色，文字字体
    JKTitleButton *titleButton = [JKTitleButton buttonWithType:UIButtonTypeCustom];

    //设置自定义按钮文字
    NSString *name = [JKAccountTool account].name;
    [titleButton setTitle:name?name:@"首页" forState:UIControlStateNormal];

    //设置按钮时间监听
    [titleButton addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = titleButton;
}

- (void)titleClick:(UIButton *)titleButton
{
    JKDropDownMenu *menu = [JKDropDownMenu menu];
    //成为下拉菜单的代理    
    menu.delegate = self;
    
    JKTestDropDownController *testVC = [[JKTestDropDownController alloc] init];
    testVC.tableView.frame = CGRectMake(0, 0, 150, 200);
    menu.contentController = testVC;
    [menu showFrom:titleButton];
}

- (void)friendSearch
{
    NSLog(@"friendSearch");
}

- (void)pop
{
    NSLog(@"pop");
}

- (void)didShowDropDownMenu:(JKDropDownMenu *)dropDownMenu
{
    UIButton *titleBtn = (UIButton *)self.navigationItem.titleView;
    titleBtn.selected = YES;
}

- (void)didDismissDropDownMenu:(JKDropDownMenu *)dropDownMenu
{
    UIButton *titleBtn = (UIButton *)self.navigationItem.titleView;
    titleBtn.selected = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.statusFrames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JKStatusCell *cell = [JKStatusCell cellWithTableView:tableView];
    
    cell.statusFrame = self.statusFrames[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JKStatusFrame *statusFrame = self.statusFrames[indexPath.row];
    return statusFrame.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didSelectRowAtIndexPath----d%zd", indexPath.row);
}

@end
