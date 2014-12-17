//
//  JWStopItem.m
//  BusRider
//
//  Created by John Wong on 12/17/14.
//  Copyright (c) 2014 John Wong. All rights reserved.
//

#import "JWStopItem.h"

@implementation JWStopItem

- (void)setFromDictionary:(NSDictionary *)dict {
    self.order = [dict[@"order"] integerValue];
    self.stopId = dict[@"stopId"];
    self.stopName = dict[@"stopName"];
    self.coordinate = CLLocationCoordinate2DMake([dict[@"weidu"] doubleValue], [dict[@"jingdu"] doubleValue]);
}

@end
