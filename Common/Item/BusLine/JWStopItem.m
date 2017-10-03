//
//  JWStopItem.m
//  BusRider
//
//  Created by John Wong on 12/17/14.
//  Copyright (c) 2014 John Wong. All rights reserved.
//

#import "JWStopItem.h"


@implementation JWStopItem

- (instancetype)initWithOrder:(NSInteger)order stopName:(NSString *)stopName stopId:(NSString *)stopId
{
    if (self = [super init]) {
        self.order = order;
        self.stopName = stopName;
        self.stopId = stopId;
    }
    return self;
}

- (void)setFromDictionary:(NSDictionary *)dict
{
    self.order = [dict[@"order"] integerValue];
    self.stopName = dict[@"sn"];
    self.stopId = dict[@"sId"];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@%@", super.description, @{
        @"order" : @(self.order),
        @"stopName" : self.stopName
    }];
}

@end
