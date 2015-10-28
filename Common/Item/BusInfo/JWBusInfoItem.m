//
//  JWBusInfoItem.m
//  BusRider
//
//  Created by John Wong on 12/6/14.
//  Copyright (c) 2014 John Wong. All rights reserved.
//

#import "JWBusInfoItem.h"
#import "JWFormatter.h"

@implementation JWBusInfoItem

- (instancetype)initWithUserStopOrder:(NSInteger)stopOrder busInfo:(NSDictionary *)busInfo {
    self = [super init];
    if (self) {
        [self setUserStopOrder:stopOrder busInfo:busInfo];
    }
    return self;
}

- (instancetype)init {
    NSAssert(NO, @"Method is not designated initializer");
    return [self initWithUserStopOrder:0 busInfo:nil];
}

- (void)setUserStopOrder:(NSInteger)stopOrder busInfo:(NSDictionary *)dict {
    
    NSArray *mapArray = dict[@"map"];
    NSArray *busArray = dict[@"bus"];
    NSDictionary *lineInfo = dict[@"line"];
    
    self.lineNumber = [JWFormatter formatedLineNumber:lineInfo[@"lineName"]];
    self.from = lineInfo[@"startStopName"];
    self.to = lineInfo[@"endStopName"];
    self.firstTime = lineInfo[@"firstTime"];
    self.lastTime = lineInfo[@"lastTime"];
    
    NSInteger currentOrder = -1;
    for (NSDictionary *mapInfo in mapArray) {
        if ([mapInfo[@"order"] integerValue] == stopOrder) {
            currentOrder = [mapInfo[@"order"] integerValue];
            self.currentStop = mapInfo[@"stopName"];
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
