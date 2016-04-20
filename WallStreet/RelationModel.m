//
//  RelationModel.m
//  WallStreet
//
//  Created by qingyun on 16/4/18.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "RelationModel.h"

@implementation RelationModel

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.Id = [dict[@"id"] integerValue];
        self.title = dict[@"title"];
        self.url = dict[@"url"];
        self.imgUrl = dict[@"img"][@"url"];
    }
    
    return self;
}

+ (instancetype)modelWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

@end
