//
//  ResultModel.h
//  WallStreet
//
//  Created by qingyun on 16/4/21.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResultModel : NSObject

@property (nonatomic, strong) NSString *Id;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *summary;
@property (nonatomic, strong) NSString *url;

@property (nonatomic, strong) NSMutableArray *resultMarr;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (instancetype)modelWithDictionary:(NSDictionary *)dict;

@end
