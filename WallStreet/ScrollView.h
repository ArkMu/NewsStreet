//
//  ScrollView.h
//  WallStreet
//
//  Created by qingyun on 16/4/18.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScrollView : UIView

@property (nonatomic, strong) NSArray *infoArr;

@property (nonatomic, strong) void (^gotoView)(NSInteger Id);

@end
