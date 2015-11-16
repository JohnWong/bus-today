//
//  JWStopRequest.m
//  BusRider
//
//  Created by John Wong on 1/13/15.
//  Copyright (c) 2015 John Wong. All rights reserved.
//

#import "JWStopRequest.h"


@implementation JWStopRequest

- (NSDictionary *)params
{
    return @{
        @"stationId" : self.stationId ?: @""
    };
}

- (NSString *)actionName
{
    return @"stop!stationDetail";
}

- (NSString *)validateParams
{
    if (self.stationId.length <= 0) {
        return @"站点名不能为空";
    }
    return nil;
}

@end
