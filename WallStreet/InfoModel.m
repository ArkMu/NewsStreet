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
//        self.userModel = [UserModel modelWithDictionary:dict[@"user"]];
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

//- (void)encodeWithCoder:(NSCoder *)aCoder {
//    [aCoder setValue:self.type forKey:@"type"];
//    [aCoder setValue:@(self.Id) forKey:@"id"];
//    [aCoder setValue:self.title forKey:@"title"];
//    [aCoder setValue:self.localType forKey:@"localType"];
//    [aCoder setValue:@(self.createdAt) forKey:@"createdAt"];
//    [aCoder setValue:self.summary forKey:@"summary"];
//    [aCoder setValue:self.url forKey:@"url"];
//    [aCoder setValue:self.imgUrl forKey:@"imgUrl"];
//    [aCoder setValue:self.tags forKey:@"tags"];
//    [aCoder encodeObject:self.userModel forKey:@"userModel"];
//    [aCoder setValue:@(self.commentCount) forKey:@"commentCount"];
//}
//
//-(instancetype)initWithCoder:(NSCoder *)aDecoder {
//    self = [super init];
//    if (self) {
//        self.type = [aDecoder decodeObjectForKey:@"type"];
//        self.Id = [aDecoder decodeIntegerForKey:@"id"];
//        self.title = [aDecoder decodeObjectForKey:@"title"];
//        self.localType = [aDecoder decodeObjectForKey:@"localType"];
//        self.createdAt = [aDecoder decodeIntegerForKey:@"createdAt"];
//        self.summary = [aDecoder decodeObjectForKey:@"summary"];
//        self.url = [aDecoder decodeObjectForKey:@"url"];
//        self.imgUrl = [aDecoder decodeObjectForKey:@"imgUrl"];
//        self.tags = [aDecoder decodeObjectForKey:@"tags"];
//        self.userModel = [aDecoder decodeObjectForKey:@"userModel"];
//        self.commentCount = [aDecoder decodeIntegerForKey:@"commentCount"];
//    }
//    
//    return self;
//}

@end
