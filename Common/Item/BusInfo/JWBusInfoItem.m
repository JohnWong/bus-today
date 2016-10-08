//
//  JWBusInfoItem.m
//  BusRider
//
//  Created by John Wong on 12/6/14.
//  Copyright (c) 2014 John Wong. All rights reserved.
//

#import "JWBusInfoItem.h"
#import "JWFormatter.h"

#import <UIKit/UIKit.h>


@implementation JWBusInfoItem

- (instancetype)initWithUserStopOrder:(NSInteger)stopOrder busInfo:(NSDictionary *)busInfo
{
    self = [super init];
    if (self) {
        [self setUserStopOrder:stopOrder busInfo:busInfo];
    }
    return self;
}

- (instancetype)init
{
    return [self initWithUserStopOrder:0 busInfo:nil];
}

- (void)setUserStopOrder:(NSInteger)stopOrder busInfo:(NSDictionary *)dict
{
    NSArray *mapArray = dict[@"stations"];
    NSArray *busArray = dict[@"buses"];
    NSDictionary *lineInfo = dict[@"line"];

    self.lineNumber = [JWFormatter formatedLineNumber:lineInfo[@"name"]];
    self.from = lineInfo[@"startSn"];
    self.to = lineInfo[@"endSn"];
    self.firstTime = lineInfo[@"firstTime"];
    self.lastTime = lineInfo[@"lastTime"];

    NSInteger nearestOrder = -1;
    NSDictionary *busInfo = nil;
    for (NSDictionary *busDict in busArray) {
        NSInteger order = [busDict[@"order"] integerValue];
        if (order > nearestOrder && order <= stopOrder) {
            nearestOrder = order;
            busInfo = busDict;
        }
    }

    NSInteger currentOrder = -1;
    NSInteger distance = 0;
    for (NSDictionary *mapInfo in mapArray) {
        NSInteger order = [mapInfo[@"order"] integerValue];
        if (order == stopOrder) {
            currentOrder = order;
            self.currentStop = mapInfo[@"sn"];
        }
        if (order > nearestOrder && order <= stopOrder) {
            distance += [mapInfo[@"distanceToSp"] integerValue];
        }
    }
    self.distance = distance;

    if (busArray.count == 0 || currentOrder == -1) {
        self.state = JWBusStateNotFound;
        self.desc = lineInfo[@"desc"];
        if ([self.desc rangeOfString:@"暂时失联"].location != NSNotFound) {
            self.desc = @"暂时失联";
        }
        return;
    }

    if (nearestOrder == -1) {
        // TODO
        busInfo = busArray.lastObject;
        self.state = JWBusStateNotStarted;
    } else if (nearestOrder == currentOrder) {
        self.state = JWBusStateNear;
        self.remains = [busInfo[@"state"] integerValue] == 1 ? @"已到站" : @"即将到站";
    } else {
        self.state = JWBusStateFar;
        self.remains = [NSString stringWithFormat:@"%@站", @(currentOrder - nearestOrder)];
    }
    self.order = currentOrder;
    self.updateTime = [busInfo[@"syncTime"] integerValue];
    NSArray *travels = busInfo[@"travels"];
    if (travels.count > 0) {
        NSDictionary *travel = travels[0];
        self.rate = (NSInteger)floor([travel[@"pRate"] doubleValue] * 100);
        NSInteger time = [travel[@"travelTime"] integerValue];
        if (time / 60 >= 60) {
            self.travelTime = [JWFormatter formatedTime:[travel[@"arrivalTime"] doubleValue]];
        } else if (time / 60 >= 1) {
            self.travelTime = [NSString stringWithFormat:@"%@分", @(time / 60)];
        } else if (time > 30) {
            self.travelTime = [NSString stringWithFormat:@"%@秒", @(time)];
        } else {
            self.travelTime = @"30秒";
        }
    }
}

- (NSArray *)calulateInfo
{
    NSAttributedString *main = nil;
    NSString *update = nil;
    typeof(self) item = self;
    switch (item.state) {
        case JWBusStateNotStarted: {
            update = [NSString stringWithFormat:@"准点率%@", item.rate > 0 ? [NSString stringWithFormat:@"%@%%", @(item.rate)] : @"--"];
            break;
        }
        case JWBusStateNear: {
            update = [NSString stringWithFormat:@"%@ %@前上报", item.remains, [JWFormatter formatedCost:item.updateTime]];
            break;
        }
        case JWBusStateFar: {
            NSString *distance = [JWFormatter formatedDistance:item.distance];
            update = [NSString stringWithFormat:@"%@/%@ %@前上报", item.remains, distance, [JWFormatter formatedCost:item.updateTime]];
            break;
        }
        case JWBusStateNotFound:
        default: {
            update = item.desc;
            break;
        }
    }
    NSString *text = self.travelTime ?: @"--";
    NSMutableAttributedString *ats = [[NSMutableAttributedString alloc] initWithString:text];
    NSString *lastChar = [text substringFromIndex:text.length - 1];
    if ([lastChar isEqualToString:@"分"] || [lastChar isEqualToString:@"秒"]) {
        [ats addAttribute:NSFontAttributeName
                    value:[UIFont systemFontOfSize:14]
                    range:NSMakeRange(item.travelTime.length - 1, 1)];
    }
    main = [ats copy];
    return @[ main, update ];
}

@end
