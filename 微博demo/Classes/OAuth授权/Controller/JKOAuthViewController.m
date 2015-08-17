//
//  JKOAuthViewController.m
//  微博demo
//
//  Created by 史江凯 on 15/7/2.
//  Copyright (c) 2015年 史江凯. All rights reserved.
//

#import "JKOAuthViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "JKAccountTool.h"


@interface JKOAuthViewController () <UIWebViewDelegate>

@end

@implementation JKOAuthViewController

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
    //创建webView加载登录页面
    UIWebView *webView = [[UIWebView alloc] init];
    webView.frame = self.view.bounds;
    [self.view addSubview:webView];
    webView.delegate = self;

    //client_id 申请应用时分配的AppKey
    //redirect_uri 回调地址，申请应用时填写的。默认http://
    NSString *URLStr = [NSString stringWithFormat:@"https://api.weibo.com/oauth2/authorize?client_id=%@&redirect_uri=%@",  JKAppKey, JKRedirectURI];
    NSURL *url = [NSURL URLWithString:URLStr];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [webView loadRequest:request];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [MBProgressHUD showMessage:@"正在加载..."];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MBProgressHUD hideHUD];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [MBProgressHUD hideHUD];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *urlString = request.URL.absoluteString;
    NSLog(@"%@", urlString);
    NSRange range = [urlString rangeOfString:@"code="];
    if (range.length) {
        NSString *code = [urlString substringFromIndex:NSMaxRange(range)];
        //登录成功后，利用返回的code请求accessToken
        [self accessTokenWithCode:code];
        NSLog(@"%@----code:", code);
        //禁止加载回调地址
        return NO;
    }
    
    return YES;
}
- (void)accessTokenWithCode:(NSString *)code
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //新浪返回的JSON数据类型是text/plain，需要渠道AFN的源代码里修改AFJSONResponseSerializer的acceptableContentTypes
    //    manager.responseSerializer默认就是AFJSONResponseSerializer
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //申请应用时新浪返回的
    params[@"client_id"] = JKAppKey;
    params[@"client_secret"] = JKAppSecret;
    //固定用法
    params[@"grant_type"] = @"authorization_code";
    //授权成功后获取的回调地址，和code
    params[@"redirect_uri"] = JKRedirectURI;
    params[@"code"] = code;

    [manager POST:@"https://api.weibo.com/oauth2/access_token" parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {

        [MBProgressHUD hideHUD];

        //成功后返回一个字典，四个元素access_token, expires_in,reminnd_in,uid
        //转换成模型后，将模型存进沙盒
        JKAccount *account = [JKAccount accountWithDict:responseObject];
        
        [JKAccountTool saveAccount:account];
        NSLog(@"account----%@", account);
        //切换主控制器
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window switchRootViewController];

        //上下能替换     [self.view.window switchRootViewController];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"++++++//////%@", error.userInfo[@"com.alamofire.serialization.response.error.data"]);
        NSLog(@"%@", [NSJSONSerialization  JSONObjectWithData:error.userInfo[@"com.alamofire.serialization.response.error.data"] options:NSJSONReadingMutableLeaves error:nil]);
        [MBProgressHUD hideHUD];
    }];
}

@end
