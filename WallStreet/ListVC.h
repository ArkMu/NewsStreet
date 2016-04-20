//
//  ListVC.h
//  WallStreet
//
//  Created by qingyun on 16/4/20.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MoreInfoVC;

@interface ListVC : UIViewController

@property (nonatomic, strong) void(^dismissListVC)(MoreInfoVC *);
//@property (nonatomic, strong) UITableView *tableView;

@end
