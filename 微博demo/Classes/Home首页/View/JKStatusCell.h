//
//  JKStatusCell.h
//  微博demo
//
//  Created by 史江凯 on 15/7/4.
//  Copyright (c) 2015年 史江凯. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JKStatusFrame;
@interface JKStatusCell : UITableViewCell

@property (nonatomic, strong) JKStatusFrame *statusFrame;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
