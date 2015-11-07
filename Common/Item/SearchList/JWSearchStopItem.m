//
//  JWSearchStopItem.m
//  BusRider
//
//  Created by John Wong on 1/7/15.
//  Copyright (c) 2015 John Wong. All rights reserved.
//

#import "JWSearchStopItem.h"


@implementation JWSearchStopItem

- (instancetype)initWithStopId:(NSString *)stopId stopName:(NSString *)stopName
{
    if (self = [super init]) {
        self.stopName = stopName;
        self.stopId = stopId;
    }
    return self;
}

- (void)setFromDictionary:(NSDictionary *)dict
{
    // TODO
    self.stopName = dict[@"sn"];
    self.stopId = dict[@"sId"];
}

@end
