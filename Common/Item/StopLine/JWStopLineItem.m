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

- (void)setFromDictionary:(NSDictionary *)dc
{
    NSDictionary *dict = dc[@"line"];
    self.lineId = dict[@"lineId"];
    self.lineNumer = [JWFormatter formatedLineNumber:dict[@"name"]];
    self.from = dict[@"startSn"];
    self.to = dict[@"endSn"];
    NSDictionary *next = dc[@"nextStation"];
    if ([next[@"sn"] isEqualToString:@"-1"]) {
        self.nextStop = @"终点站";
    } else {
        self.nextStop = [NSString stringWithFormat:@"开往%@", next[@"sn"]];
    }
    NSArray *stns = dc[@"stnStates"];
    if (stns.count > 0) {
        NSDictionary *stn = stns[0];
        NSInteger time = [stn[@"travelTime"] integerValue];
        if (time / 60 > 60) {
            self.desc = [JWFormatter formatedTime:[stn[@"arrivalTime"] integerValue]];
        } else if (time / 60 >= 1) {
            self.desc = [NSString stringWithFormat:@"%@分", @(time / 60)];
        } else if (time > 30) {
            self.desc = [NSString stringWithFormat:@"%@秒", @(time)];
        } else {
            self.desc = @"30秒";
        }
    } else {
        self.desc = dict[@"desc"];
    }
}

- (NSComparisonResult)compare:(JWStopLineItem *)other
{
    return [self.lineNumer compare:other.lineNumer options:NSNumericSearch];
}

@end
