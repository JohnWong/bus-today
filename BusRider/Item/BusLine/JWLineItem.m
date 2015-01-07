//
//  JWLineItem.m
//  BusRider
//
//  Created by John Wong on 12/17/14.
//  Copyright (c) 2014 John Wong. All rights reserved.
//

#import "JWLineItem.h"

@implementation JWLineItem

- (void)setFromDictionary:(NSDictionary *)dict {
    NSDictionary *lineDict = dict[@"line"];
    self.lineId = lineDict[@"lineId"];
    NSString *lineName = lineDict[@"lineName"];
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:@"\\d*" options:0 error:nil];
    if ([regularExpression stringByReplacingMatchesInString:lineName options:0 range:NSMakeRange(0, lineName.length) withTemplate:@""].length == 0) {
        self.lineNumber = [NSString stringWithFormat:@"%@路", lineName];
    } else {
        self.lineNumber = lineName;
    }
    self.from = lineDict[@"startStopName"];
    self.to = lineDict[@"endStopName"];
    self.firstTime = lineDict[@"firstTime"];
    self.lastTime = lineDict[@"lastTime"];
    
    NSArray *otherLines = dict[@"otherlines"];
    if (otherLines.count == 1) {
        self.otherLineId = otherLines[0][@"lineId"];
    }
    self.pastTime = [dict[@"busBehindTime"] integerValue];
}

@end
