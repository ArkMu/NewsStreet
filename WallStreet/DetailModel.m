//
//  DetailModel.m
//  WallStreet
//
//  Created by qingyun on 16/4/19.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "DetailModel.h"

#import "UserModel.h"
#import "ConnectionModel.h"

#import "NSString+Time.h"

@implementation DetailModel

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.title = dict[@"title"];
        self.summary = dict[@"summary"];
        self.createdAt = dict[@"createdAt"];
        self.content = dict[@"text"][@"content"];
        [NSString stringFromHtml:self.content];
        
        self.userModel = [UserModel modelWithDictionary:dict[@"user"]];
        
        _connectionArr = [NSMutableArray array];
        NSArray *arr = dict[@"connections"];
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ConnectionModel *model = [ConnectionModel modelWithDictionary:(NSDictionary *)obj];
            [_connectionArr addObject:model];
        }];
    }
    return self;
}

+ (instancetype)modelWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}


@end
