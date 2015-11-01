//
//  JWLineRequest.m
//  BusRider
//
//  Created by John Wong on 12/30/14.
//  Copyright (c) 2014 John Wong. All rights reserved.
//

#import "JWLineRequest.h"


@implementation JWLineRequest

- (NSDictionary *)params
{
    return @{
        @"lineId" : self.lineId ?: @"",
        @"targetOrder" : self.targetOrder ? @(self.targetOrder) : @""
    };
}

- (NSString *)actionName
{
    return @"line!lineDetail";
}

- (NSString *)validateParams
{
    if (!self.lineId || self.lineId.length <= 0) {
        return @"请先到应用中选择路线";
    }
    return nil;
}

@end
