//
//  AguModel.h
//  WallStreet
//
//  Created by qingyun on 16/4/19.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AguModel : NSObject

@property (nonatomic, strong) NSString *updatedAt;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *Id;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (instancetype)modelWithDictionary:(NSDictionary *)dict;

@end
