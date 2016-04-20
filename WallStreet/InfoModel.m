//
//  InfoModel.m
//  WallStreet
//
//  Created by qingyun on 16/4/18.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "InfoModel.h"

#import "UserModel.h"

#import "RelationModel.h"

@implementation InfoModel

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.type = dict[@"type"];
        self.Id = [dict[@"id"] integerValue];
        self.title = dict[@"title"];
        self.localType = dict[@"localType"];
        self.createdAt = [dict[@"createdAt"] integerValue];
        self.summary = dict[@"summary"];
        self.url = dict[@"url"];
        self.imgUrl = dict[@"img"][@"url"];
        self.tags = dict[@"tags"];
        self.userModel = [UserModel modelWithDictionary:dict[@"user"]];
        self.commentCount = [dict[@"commentCount"] integerValue];
        
        _relationArr = [NSMutableArray array];
        for (NSDictionary *dic in dict[@"relations"]) {
            RelationModel *model = [RelationModel modelWithDictionary:dic];
            [self.relationArr addObject:model];
        }
    }
    
    return self;
}

+ (instancetype)modelWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

@end
