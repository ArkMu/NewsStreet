//
//  MarketModel.m
//  WallStreet
//
//  Created by qingyun on 16/4/20.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "MarketModel.h"

@implementation MarketModel

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.timestamp = [dict[@"timestamp"] integerValue];
        self.localDateTime = dict[@"localDateTime"];
        self.importance = [dict[@"importance"] integerValue];
        self.title = dict[@"title"];
        self.actual = dict[@"actual"];
        self.revised = dict[@"revised"];
        self.forecast = dict[@"forecast"];
        self.previous = dict[@"previous"];
        self.category_id = [dict[@"category_id"] integerValue];
        self.mark = dict[@"mark"];
        self.level = [dict[@"level"] integerValue];
        self.country = dict[@"country"];
        self.currency = dict[@"currency"];
        self.calendarType = dict[@"calendarType"];
        self.desc = dict[@"desc"];
    }
    
    return self;
}

+ (instancetype)modelWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

@end
