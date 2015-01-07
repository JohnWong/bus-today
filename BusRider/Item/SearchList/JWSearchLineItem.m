//
//  JWSearchLineItem.m
//  BusRider
//
//  Created by John Wong on 1/7/15.
//  Copyright (c) 2015 John Wong. All rights reserved.
//

#import "JWSearchLineItem.h"

@implementation JWSearchLineItem

- (void)setFromDictionary:(NSDictionary *)dict {
    self.lineId = dict[@"lineId"];
    
    NSString *lineName = dict[@"lineName"];
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:@"\\d*" options:0 error:nil];
    if ([regularExpression stringByReplacingMatchesInString:lineName options:0 range:NSMakeRange(0, lineName.length) withTemplate:@""].length == 0) {
        self.lineNumber = [NSString stringWithFormat:@"%@路", lineName];
    } else {
        self.lineNumber = lineName;
    }
}

@end
