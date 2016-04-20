//
//  MarketViewCell.h
//  WallStreet
//
//  Created by qingyun on 16/4/20.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MarketModel;

@interface MarketViewCell : UITableViewCell

@property (nonatomic, strong) NSDictionary *countryName;

@property (nonatomic, strong) MarketModel *markModel;

@end
