//
//  MessModel.h
//  WallStreet
//
//  Created by qingyun on 16/4/21.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessModel : NSObject

@property (nonatomic, strong) NSString *seq;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *ctime;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *imgurl;

@property (nonatomic, strong) NSString *digest;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (instancetype)modelWithDictionary:(NSDictionary *)dict;

@end
