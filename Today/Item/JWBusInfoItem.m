//
//  JWBusInfoItem.m
//  BusRider
//
//  Created by John Wong on 12/6/14.
//  Copyright (c) 2014 John Wong. All rights reserved.
//

#import "JWBusInfoItem.h"

@implementation JWBusInfoItem

- (instancetype)initWithUserStop:(NSString *)userStop busInfo:(NSDictionary *)busInfo {
    if (self = [super init]) {
        [self setUserStop:userStop busInfo:busInfo];
    }
    return self;
}

- (void)setUserStop:(NSString *)currentStop busInfo:(NSDictionary *)dict {
    
    NSArray *mapArray = dict[@"map"];
    NSArray *busArray = dict[@"bus"];
    NSDictionary *lineInfo = dict[@"line"];
    
    self.currentStop = currentStop;
    self.lineNumber = lineInfo[@"lineName"];
    self.from = lineInfo[@"startStopName"];
    self.to = lineInfo[@"endStopName"];
    self.firstTime = lineInfo[@"firstTime"];
    self.lastTime = lineInfo[@"lastTime"];
    
    NSInteger currentOrder = -1;
    for (NSDictionary *mapInfo in mapArray) {
        if ([mapInfo[@"stopName"] isEqualToString:currentStop]) {
            currentOrder = [mapInfo[@"order"] integerValue];
            break;
        }
    }
    if (currentOrder == -1) {
        // can not find current stop
        return;
    }
    
    if (busArray.count == 0) {
        self.state = JWBusStateNotFound;
        if ([dict[@"nobustip"] containsString:@"已过运营时间"]) {
            self.noBusTip = @"已过运营时间";
        } else {
            self.noBusTip = @"暂无数据";
        }
        return;
    }
    NSInteger nearestOrder = -1;
    NSDictionary *busInfo = nil;
    for (NSDictionary *busDict in busArray) {
        NSInteger order = [busDict[@"order"] integerValue];
        if (order > nearestOrder && order <= currentOrder) {
            nearestOrder = order;
            busInfo = busDict;
        }
    }
    
    if (nearestOrder == -1) {
        self.state = JWBusStateNotStarted;
        self.pastTime = [dict[@"busBehindTime"] integerValue];
    } else if (nearestOrder == currentOrder) {
        self.state = JWBusStateNear;
        self.distance = (int)floor([busInfo[@"distance"] doubleValue]);
    } else {
        self.state = JWBusStateFar;
        self.remains = currentOrder - nearestOrder;
    }
    self.order = currentOrder;
    self.updateTime = [busInfo[@"lastTime"] integerValue];
}

@end
