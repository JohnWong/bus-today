//
//  JWLineItem.m
//  BusRider
//
//  Created by John Wong on 12/17/14.
//  Copyright (c) 2014 John Wong. All rights reserved.
//

#import "JWLineItem.h"
#import "JWFormatter.h"


@implementation JWLineItem

- (void)setFromDictionary:(NSDictionary *)dict
{
    NSDictionary *lineDict = dict[@"line"];
    self.lineId = lineDict[@"lineId"];
    self.lineNumber = [JWFormatter formatedLineNumber:lineDict[@"lineName"] ?: lineDict[@"name"]];
    self.from = lineDict[@"startSn"];
    self.to = lineDict[@"endSn"];
    self.firstTime = lineDict[@"firstTime"];
    self.lastTime = lineDict[@"lastTime"];

    NSArray *otherLines = dict[@"otherlines"];
    if (otherLines.count == 1) {
        self.otherLineId = otherLines[0][@"lineId"];
    }
}

@end
