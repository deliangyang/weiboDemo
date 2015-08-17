//
//  JKTest1ViewController.m
//  微博demo
//
//  Created by 史江凯 on 15/6/30.
//  Copyright (c) 2015年 史江凯. All rights reserved.
//

#import "JKTest1ViewController.h"

@interface JKTest1ViewController ()

@end

@implementation JKTest1ViewController

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
    // Do any additional setup after loading the view from its nib.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.view.backgroundColor = JKRandomColor;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
