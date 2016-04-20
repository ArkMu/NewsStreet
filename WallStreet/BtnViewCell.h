//
//  BtnViewCell.h
//  WallStreet
//
//  Created by qingyun on 16/4/19.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class InfoModel;

@interface BtnViewCell : UITableViewCell

@property (nonatomic, strong) InfoModel *btnModel;

@property (nonatomic, strong) void (^gotoView) (NSString *url);

@end
