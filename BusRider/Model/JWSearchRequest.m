//
//  JWSearchRequest.m
//  BusRider
//
//  Created by John Wong on 12/17/14.
//  Copyright (c) 2014 John Wong. All rights reserved.
//

#import "JWSearchRequest.h"


@implementation JWSearchRequest

- (NSDictionary *)params
{
    return @{
        @"key" : self.keyWord ?: @""
    };
}

- (NSString *)actionName
{
    return @"query!fuzzy";
}

- (NSString *)validateParams
{
    if (!self.keyWord || self.keyWord.length <= 0) {
        return @"搜索关键字不能为空";
    }
    return nil;
}

@end
