//
//  JWStopRequest.m
//  BusRider
//
//  Created by John Wong on 1/13/15.
//  Copyright (c) 2015 John Wong. All rights reserved.
//

#import "JWStopRequest.h"

@implementation JWStopRequest

- (NSDictionary *)params {
    return @{
             @"stopName": self.stopName ? : @""
             };
}

- (NSString *)actionName {
    return @"stop!stoplist";
}

- (NSString *)validateParams {
    if (!self.stopName || self.stopName.length <= 0) {
        return @"站点名不能为空";
    }
    return nil;
}

@end
