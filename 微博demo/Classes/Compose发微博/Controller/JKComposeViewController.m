//
//  JKComposeViewController.m
//  微博demo
//
//  Created by 史江凯 on 15/7/7.
//  Copyright (c) 2015年 史江凯. All rights reserved.
//

#import "JKComposeViewController.h"
#import "JKAccountTool.h"
#import "JKEmotionTextView.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "JKComposeToolbar.h"
#import "JKComposePhotosView.h"
#import "JKEmotionKeyboard.h"
#import "JKEmotion.h"

@interface JKComposeViewController () <UITextViewDelegate, JKComposeToolbarDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
//键盘顶部的五合一工具条
@property (nonatomic, weak) JKComposeToolbar *toolbar;
//文本控件
@property (nonatomic, weak) JKEmotionTextView *textView;
//在此设置强引用是因为它可能设置为nil被销毁
@property (nonatomic, strong) JKEmotionKeyboard *emotionKeyboard;

//存放从照相机或相册里选出来的照片
@property (nonatomic, weak) JKComposePhotosView *photosView;
@end

@implementation JKComposeViewController

- (JKEmotionKeyboard *)emotionKeyboard
{
    if (!_emotionKeyboard) {
        self.emotionKeyboard = [[JKEmotionKeyboard alloc] init];
        //键盘宽度非0，系统会强制让键盘宽度等于屏幕宽度。为0时，键盘不可见
        self.emotionKeyboard.width = self.view.width;
        self.emotionKeyboard.height = 216;
    }
    return _emotionKeyboard;
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
    self.view.backgroundColor = [UIColor whiteColor];
    //导航栏左侧item
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    //导航栏右侧item，默认不可用
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(send)];
    self.navigationItem.rightBarButtonItem.enabled = NO;

    //设置navigationItem的titleView
    [self setupTitleView];

    //添加自定义的textView
    [self setupTextView];
    
    //添加键盘正上方的五合一工具条
    [self setupToolbar];
    
    //添加相册
    [self setupPhotosView];

}

- (void)setupPhotosView
{
    JKComposePhotosView *photosView = [[JKComposePhotosView alloc] init];

    photosView.width = self.view.width;
    photosView.height = self.view.height;
    photosView.y = 100;
    
    [self.textView addSubview:photosView];
    self.photosView = photosView;
}

- (void)setupToolbar
{
    JKComposeToolbar *toolbar = [[JKComposeToolbar alloc] init];
    toolbar.delegate = self;
    toolbar.width = self.view.width;
    toolbar.height = 44;
    toolbar.y = self.view.bounds.size.height - toolbar.height;
    [self.view addSubview:toolbar];
    self.toolbar = toolbar;
}

- (void)setupTextView
{
    JKEmotionTextView *textView = [[JKEmotionTextView alloc] init];
    textView.delegate = self;
    //垂直方向上有弹簧效果，能拖拽    
    textView.alwaysBounceVertical = YES;
    textView.frame = self.view.bounds;
    textView.font = [UIFont systemFontOfSize:18];
    textView.placeholder = @"分享新鲜事...";
    //指定占位文本的字体颜色
    textView.placeholderColor = [UIColor grayColor];
    self.textView = textView;
    [self.view addSubview:textView];

    //成为第一响应者，即弹出键盘
    [self.textView becomeFirstResponder];
    
    //selector的方法在object中，若为nil，在当前
    //添加通知，监听textView输入文字状态，以便去掉占位文本
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidChange) name:UITextViewTextDidChangeNotification object:self.textView];
    //添加通知，监听键盘frame改变状态，以便调整键盘正上方toolbar的位置
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
    //监听选中表情时的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emotionDidSelect:) name:JKEmotionDidSelectNotification object:nil];
    
    //监听删除表情时的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emotionDidDelete) name:JKEmotionDidDeleteNotification object:nil];
}

//删除表情
- (void)emotionDidDelete
{
    [self.textView deleteBackward];
}

//表情选中时的监听方法
- (void)emotionDidSelect:(NSNotification *)notification
{
    JKEmotion *emotion = notification.userInfo[JKEmotionDidSelectNotificationUserInfoKey];
    //插入表情
    [self.textView insertEmotion:emotion];
}

//键盘隐藏时的监听方法
- (void)keyboardWillHide
{
    //键盘在系统键盘和自定义键盘两种之间切换时，会来到这里，能保持自定义的五合一toolbar在一个固定位置
    self.toolbar.y = self.view.height - self.emotionKeyboard.height - self.toolbar.height;
}

- (void)composeToolbar:(JKComposeToolbar *)toolbar didClickBtnOfType:(JKComposeToolbarButtonType)type
{
    switch (type) {
        case JKComposeToolbarButtonTypeCamera:
            //打开照相机
            [self showCamera];
            break;
            
        case JKComposeToolbarButtonTypePhotoLibrary:
            //打开相册
            [self showPicLib];
            break;

        case JKComposeToolbarButtonTypeMention:

            break;
            
        case JKComposeToolbarButtonTypeTrend:

            break;
            
        case JKComposeToolbarButtonTypeEmotion:
            [self switchKeyboard];
            break;
        default:
            break;
    }
}

- (void)switchKeyboard
{
    if (self.textView.inputView == nil) {//使用的是系统键盘
        self.textView.inputView = self.emotionKeyboard;
        self.toolbar.swithKeyboard = NO;
    } else {
        //给inputView赋值nil时，就是用系统键盘，给toolbar的表情／键盘按钮的属性：切换为键盘，值设为YES
        self.textView.inputView = nil;
        self.toolbar.swithKeyboard = YES;
    }
    [self.textView endEditing:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.textView becomeFirstResponder];
    });
}

//textView开始滚动时，结束编辑状态，即关闭键盘
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
    //如果是(自定义)键盘，关闭它时，把五合一toolbar放置屏幕最底下
    self.toolbar.y = self.view.height - self.toolbar.height;
}

- (void)textViewDidChange
{
    //textView有文字时，右侧的按钮才能点击
    self.navigationItem.rightBarButtonItem.enabled = self.textView.hasText;
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification
{

    //通知的userInfo字典，包含了一些键盘frame改变的信息
    NSDictionary *userInfo = notification.userInfo;
    //userInfo里key对应的值时NSValue对象，要转换
    //键盘弹出（隐藏）动画结束时键盘的frame
    CGRect keyboardRect = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //键盘弹出（隐藏）的动画时长
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        
        //toolbar始终在键盘的正上方
        self.toolbar.y = keyboardRect.origin.y - self.toolbar.height;
//        if (keyboardRect.origin.y >= self.view.height) {
//            self.toolbar.y = self.view.height - self.toolbar.height;
//        }
    }];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupTitleView
{
    //设置navigationItem的titleView
    NSString *prefix = @"发微博";
    NSString *name = [JKAccountTool account].name;
    if (name) {
        //用户昵称存在，拼接‘发微博 换行 加上用户名’
        NSString *titleText = [NSString stringWithFormat:@"%@\n%@", prefix, name];
        
        //导航栏中间的titleView，是一个label，显示：发微博换行加上用户名
        UILabel *titleView = [[UILabel alloc] init];
        
        titleView.width = 200;
        titleView.height = 44;
        
        titleView.textAlignment = NSTextAlignmentCenter;//文字居中
        titleView.numberOfLines = 0;//自动换行
        //创建一个带有属性的字符串（颜色，字体属性等），拼接了‘发微博 换行 name’
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:titleText];
        //    NSMutableDictionary *attrDict = [NSMutableDictionary dictionary];
        //    attrDict[NSFontAttributeName] = [UIFont systemFontOfSize:15];
        //    [attrStr addAttributes:<#(NSDictionary *)#> range:<#(NSRange)#>]
        //给prefix设置属性
        [attrStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:15] range:NSMakeRange(0,prefix.length)];
        //给用户名设置属性
        [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(prefix.length + 1, name.length)];
        
        //如果name为空，那么会出现range越界错误
        //NSRange range = [titleText rangeOfString:name];
        
        //    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
        //    attachment.image = [UIImage imageNamed:@"vip"];文字后面拼接了一张图片，即图文混排
        //    NSAttributedString *attrStr2 = [NSAttributedString attributedStringWithAttachment:attachment];
        //    [attrStr appendAttributedString:attrStr2];
        
        //titleLable设置AttributedText
        [titleView setAttributedText:attrStr];
        
        self.navigationItem.titleView = titleView;
        
    } else {
        //未能取得用户昵称时，只显示“发微博”
        self.title = prefix;
    }
}

- (void)cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//发微博
- (void)send
{
    if (self.photosView.photos.count) {
        //如果要发的微博里有图片，调用的是发照片接口
        [self sendWithImage];

    } else {
        //只是文字，调用的是发文字的接口
        [self sendWithText];
    }
}

- (void)sendWithText
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"access_token"] = [JKAccountTool account].access_token;
    params[@"status"] = self.textView.fullText;
    [manager POST:@"https://api.weibo.com/2/statuses/update.json" parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        [MBProgressHUD showSuccess:@"发布成功"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"发送失败"];
    }];

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)sendWithImage
{
    //发带有图片的微博，调用的API接口不一样，afn方法也不一样
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"access_token"] = [JKAccountTool account].access_token;
    params[@"status"] = self.textView.fullText;
    //name:@"pic"，即要求的参数key，是pic
    [manager POST:@"https://upload.api.weibo.com/2/statuses/upload.json" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //这个API只支持一张图片，从photos数组读取第一张，转成NSData，formData拼接之
        UIImage *image = [self.photosView.photos firstObject];
        NSData *data = UIImageJPEGRepresentation(image, 1.0);
        [formData appendPartWithFileData:data name:@"pic" fileName:@"testUpload.jpg" mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD showSuccess:@"发布成功"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        [MBProgressHUD showError:@"发送失败"];
    }];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showCamera
{
    //弹出照相机
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
        ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
        ipc.delegate = self;
        [self presentViewController:ipc animated:YES completion:nil];
    }
}

- (void)showPicLib
{
    //弹出相册
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
        ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        ipc.delegate = self;
        [self presentViewController:ipc animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    [self.photosView addPhoto:image];
    //dissmiss相册，弹出键盘
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self.textView becomeFirstResponder];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    //取消选择图片时，要dismiss，并且弹出键盘
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self.textView becomeFirstResponder];
}

@end
