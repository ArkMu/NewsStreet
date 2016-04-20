//
//  InfoModel.h
//  WallStreet
//
//  Created by qingyun on 16/4/18.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UserModel;

@interface InfoModel : NSObject

@property (nonatomic, strong) NSString *type;
@property (nonatomic, assign) NSInteger Id;
@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSString *localType;
@property (nonatomic, assign) NSInteger createdAt;
@property (nonatomic, strong) NSString *summary;

@property (nonatomic, strong) NSString *url;

@property (nonatomic, strong) NSString *imgUrl;
@property (nonatomic, strong) NSArray *tags;

@property (nonatomic, strong) UserModel *userModel;

@property (nonatomic, strong) NSMutableArray *relationArr;

@property (nonatomic, assign) NSInteger commentCount;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (instancetype)modelWithDictionary:(NSDictionary *)dict;

@end
