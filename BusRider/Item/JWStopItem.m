//
//  JWStopItem.m
//  BusRider
//
//  Created by John Wong on 12/17/14.
//  Copyright (c) 2014 John Wong. All rights reserved.
//

#import "JWStopItem.h"

@implementation JWStopItem

- (id)copyWithZone:(NSZone *)zone {
    JWStopItem *item = [[[self class] allocWithZone:zone] init];
    item.order = self.order;
    item.stopId = self.stopId;
    item.stopName = self.stopName;
    item.coordinate = self.coordinate;
    return item;
}

- (void)setFromDictionary:(NSDictionary *)dict {
    self.order = [dict[@"order"] integerValue];
    self.stopId = dict[@"stopId"];
    self.stopName = dict[@"stopName"];
    self.coordinate = CLLocationCoordinate2DMake([dict[@"weidu"] doubleValue], [dict[@"jingdu"] doubleValue]);
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@%@", [super description], @{
                                                                    @"order": @(self.order),
                                                                    @"stopId": self.stopId,
                                                                    @"stopName": self.stopName,
                                                                    @"coordinate": [NSString stringWithFormat:@"(latitude = %f, longitude = %f)", self.coordinate.latitude, self.coordinate.longitude]
                                                                    }];
}

@end
