//
//  JWBusRequest.m
//  BusRider
//
//  Created by John Wong on 12/16/14.
//  Copyright (c) 2014 John Wong. All rights reserved.
//

#import "JWBusRequest.h"

@implementation JWBusRequest

- (NSDictionary *)params {
    return @{
             @"lineId": self.lineId ? : @""
             };
}

- (NSString *)actionName {
    return @"line!map2";
}

- (void)loadWithCompletion:(JWCompletion)completion progress:(JWProgress)progress {
    if (!self.lineId || self.lineId.length <= 0) {
        NSError *error = [NSError errorWithDomain:@"请先到应用中选择路线" code:0 userInfo:nil];
        completion(nil, error);
    } else {
        [super loadWithCompletion:completion progress:progress];
    }
}

@end
