//
//  ResultModel.m
//  WallStreet
//
//  Created by qingyun on 16/4/21.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "ResultModel.h"

#import "PostModel.h"

@implementation ResultModel

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.Id = dict[@"id"];
        self.title = dict[@"title"];
        self.summary = dict[@"summary"];
        self.url = dict[@"url"];
        
        NSArray *arr = dict[@"posts"];
        
        _resultMarr = [NSMutableArray array];
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            PostModel *model = [PostModel modelWithDictionary:(NSDictionary *)obj];
            [_resultMarr addObject:model];
        }];
    }
    
    return self;
}

+ (instancetype)modelWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

@end
