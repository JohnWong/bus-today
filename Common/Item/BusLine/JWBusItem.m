//
//  JWBusItem.m
//  BusRider
//
//  Created by John Wong on 12/18/14.
//  Copyright (c) 2014 John Wong. All rights reserved.
//

#import "JWBusItem.h"


@implementation JWBusItem

+ (NSArray *)arrayFromDictionaryArray:(NSArray *)array
{
    NSMutableArray *filtered = [NSMutableArray arrayWithCapacity:array.count];
    for (NSDictionary *bus in array) {
        if ([bus[@"order"] integerValue] >= 0) {
            [filtered addObject:bus];
        }
    }
    return [super arrayFromDictionaryArray:filtered];
}

- (void)setFromDictionary:(NSDictionary *)dict
{
    self.arrived = [dict[@"arrived"] boolValue];
    self.order = [dict[@"order"] integerValue];
    self.distance = [dict[@"distance"] integerValue];
    self.lastTime = [dict[@"lastTime"] integerValue];
    self.stopId = dict[@"stopId"];
}

@end
