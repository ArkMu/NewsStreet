//
//  NSString+Time.m
//  WallStreet
//
//  Created by qingyun on 16/4/18.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "NSString+Time.h"

@implementation NSString (Time)

+ (NSString *)dateString:(NSInteger)inter {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:inter];
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    formatter.dateFormat = @"EEE MMM dd HH:mm:ss zzz yyy";
//    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    NSDate *currentDate = [NSDate date];
    
    NSTimeInterval interval = [currentDate timeIntervalSinceDate:date];
    if (interval < 60) {
        return @"刚刚";
    } else if (interval < 60 * 60) {
        return [NSString stringWithFormat:@"%ld分钟前", (NSInteger)interval / 60];
    } else if (interval < 60 * 60 * 24) {
        return [NSString stringWithFormat:@"%ld小时前", (NSInteger)interval / 60 / 60];
    } else {
        return [NSString stringWithFormat:@"%ld天前", (NSInteger)interval / 60 / 60 / 24];
    }
}


+ (NSString *)stringFromHtml:(NSString *)html {
    NSMutableArray *arr = [html componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<p>"]];
    [arr removeObject:@""];
    [arr removeObject:@"/"];
    [arr removeObject:@"\\"];
    
    return nil;
}
@end
