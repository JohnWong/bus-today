//
//  JWSearchStopItem.m
//  BusRider
//
//  Created by John Wong on 1/7/15.
//  Copyright (c) 2015 John Wong. All rights reserved.
//

#import "JWSearchStopItem.h"

@implementation JWSearchStopItem

- (void)setFromDictionary:(NSDictionary *)dict {
    self.stopId = dict[@"stopId"];
    self.stopName = dict[@"stopName"];
}

@end
