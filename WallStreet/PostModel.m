//
//  PostModel.m
//  WallStreet
//
//  Created by qingyun on 16/4/21.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "PostModel.h"

@implementation PostModel

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.Id = dict[@"id"];
        self.title = dict[@"title"];
        self.createdAt = dict[@"createdAt"];
        self.url = dict[@"url"];
        self.imageUrl = dict[@"imageUrl"];
        self.summary = dict[@"summary"];
    }
    
    return self;
}

+ (instancetype)modelWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

@end
