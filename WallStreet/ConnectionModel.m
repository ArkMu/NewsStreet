//
//  ConnectionModel.m
//  WallStreet
//
//  Created by qingyun on 16/4/19.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "ConnectionModel.h"

#import "NSString+Time.h"

@implementation ConnectionModel

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.Id = dict[@"id"];
        self.image = dict[@"image"];
        self.title = dict[@"title"];
        self.createdAt = [NSString dateString:[dict[@"createdAt"] integerValue]];
        self.url = dict[@"url"];
    }
    
    return self;
}

+ (instancetype)modelWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

@end
