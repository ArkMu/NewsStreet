//
//  DetailModel.h
//  WallStreet
//
//  Created by qingyun on 16/4/19.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UserModel;

@interface DetailModel : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *createdAt;
@property (nonatomic, strong) NSString *summary;

@property (nonatomic, strong) NSString *content;

@property (nonatomic, strong) UserModel *userModel;

@property (nonatomic, strong) NSMutableArray *connectionArr;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (instancetype)modelWithDictionary:(NSDictionary *)dict;

@end
