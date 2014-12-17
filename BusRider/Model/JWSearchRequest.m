//
//  JWSearchRequest.m
//  BusRider
//
//  Created by John Wong on 12/17/14.
//  Copyright (c) 2014 John Wong. All rights reserved.
//

#import "JWSearchRequest.h"

@implementation JWSearchRequest

- (NSDictionary *)params {
    return @{
             @"LsName": self.keyWord
             };
}

- (NSString *)actionName {
    return @"query!search";
}

@end
