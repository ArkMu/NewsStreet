//
//  PostModel.h
//  WallStreet
//
//  Created by qingyun on 16/4/21.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PostModel : NSObject

@property (nonatomic, strong) NSString *Id;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *createdAt;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString *summary;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (instancetype)modelWithDictionary:(NSDictionary *)dict;

@end
