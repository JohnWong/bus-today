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
    self.lineNumber = lineDict[@"lineName"];
    self.from = lineDict[@"startStopName"];
    self.to = lineDict[@"endStopName"];
    self.firstTime = lineDict[@"firstTime"];
    self.lastTime = dict[@"lastTime"];
    
    NSArray *otherLines = dict[@"otherlines"];
    if (otherLines.count == 1) {
        self.otherLineId = otherLines[0][@"lineId"];
    }
    self.pastTime = [dict[@"busBehindTime"] integerValue];
}

@end
