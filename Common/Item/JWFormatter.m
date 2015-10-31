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
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:@"\\d*" options:0 error:nil];
    if ([regularExpression stringByReplacingMatchesInString:lineNumber options:0 range:NSMakeRange(0, lineNumber.length) withTemplate:@""].length == 0) {
        return [NSString stringWithFormat:@"%@路", lineNumber];
    } else {
        return lineNumber;
    }
}

+ (NSString *)formatedTime:(NSInteger)time
{
    return [NSString stringWithFormat:@"%ld%@", (long)(time < 60 ? time : time / 60), time < 60 ? @"秒" : @"分"];
}

@end
