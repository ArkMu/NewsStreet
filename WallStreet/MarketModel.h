//
//  MarketModel.h
//  WallStreet
//
//  Created by qingyun on 16/4/20.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MarketModel : NSObject

@property (nonatomic, assign) NSInteger timestamp;
@property (nonatomic, strong) NSString *localDateTime;
@property (nonatomic, assign) NSInteger importance;     // 星数
@property (nonatomic, strong) NSString *title;      // 标题

@property (nonatomic, strong) NSString *actual; // 今值
@property (nonatomic, strong) NSString *revised;
@property (nonatomic, strong) NSString *forecast; // 预期值
@property (nonatomic, strong) NSString *previous; //前值

@property (nonatomic, assign) NSInteger category_id;  // 国家标示
@property (nonatomic, strong) NSString *mark;   // BB 已公布  FE 未公布

@property (nonatomic, assign) NSInteger level;
@property (nonatomic, strong) NSString *country;
@property (nonatomic, strong) NSString *currency;
@property (nonatomic, strong) NSString *calendarType;
@property (nonatomic, strong) NSString *desc;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (instancetype)modelWithDictionary:(NSDictionary *)dict;

@end
