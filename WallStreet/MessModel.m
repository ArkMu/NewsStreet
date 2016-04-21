//
//  MessModel.m
//  WallStreet
//
//  Created by qingyun on 16/4/21.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "MessModel.h"

@implementation MessModel

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.seq = dict[@"seq"];
        self.title = dict[@"title"];
        self.ctime = dict[@"ctime"];
        self.url = dict[@"url"];
        self.imgurl = dict[@"imgurl"];
        self.digest = dict[@"digest"];
    }
    
    return self;
}

+ (instancetype)modelWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

@end
