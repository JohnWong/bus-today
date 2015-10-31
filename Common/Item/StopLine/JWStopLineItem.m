//
//  JWStopLineItem.m
//  BusRider
//
//  Created by John Wong on 1/13/15.
//  Copyright (c) 2015 John Wong. All rights reserved.
//

#import "JWStopLineItem.h"
#import "JWFormatter.h"


@implementation JWStopLineItem

- (void)setFromDictionary:(NSDictionary *)dict
{
    self.lineId = dict[@"lineId"];
    self.lineNumer = [JWFormatter formatedLineNumber:dict[@"lineName"]];
    self.from = dict[@"startStopName"];
    self.to = dict[@"endStopName"];
    self.nextStop = dict[@"nextStop"];
    self.leftStops = [dict[@"leftStopNum"] integerValue];
}

- (NSComparisonResult)compare:(JWStopLineItem *)other
{
    return [self.lineNumer compare:other.lineNumer options:NSNumericSearch];
}

@end
