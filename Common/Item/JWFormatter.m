//
//  JWFormatter.m
//  BusRider
//
//  Created by John Wong on 1/13/15.
//  Copyright (c) 2015 John Wong. All rights reserved.
//

#import "JWFormatter.h"


@implementation JWFormatter

+ (NSString *)formatedLineNumber:(NSString *)lineNumber
{
    if (lineNumber.length == 0) {
        NSAssert(NO, @"lineNumber is nil (%@)", lineNumber);
        return @"";
    }
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:@"\\d*" options:0 error:nil];
    if ([regularExpression stringByReplacingMatchesInString:lineNumber options:0 range:NSMakeRange(0, lineNumber.length) withTemplate:@""].length == 0) {
        return [NSString stringWithFormat:@"%@路", lineNumber];
    } else {
        return lineNumber;
    }
}

+ (NSString *)formatedCost:(NSInteger)time
{
    return [NSString stringWithFormat:@"%ld%@", (long)(time < 60 ? time : time / 60), time < 60 ? @"秒" : @"分"];
}

+ (NSString *)formatedTime:(NSTimeInterval)time
{
    NSTimeInterval arrivalTime = time / 1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:arrivalTime];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    formatter.dateFormat = @"HH:mm";
    return [formatter stringFromDate:date];
}

+ (NSString *)formatedDistance:(NSInteger)distance
{
    if (distance > 1000) {
        return [NSString stringWithFormat:@"%@千米", @(distance / 1000)];
    } else {
        return [NSString stringWithFormat:@"%@米", @(distance)];
    }
}

@end
