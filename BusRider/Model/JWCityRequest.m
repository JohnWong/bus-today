//
//  JWCityRequest.m
//  BusRider
//
//  Created by John Wong on 1/19/15.
//  Copyright (c) 2015 John Wong. All rights reserved.
//

#import "JWCityRequest.h"
#import "JWUserDefaultsUtil.h"

NSString *const kJWData = @"key";


@implementation JWCityRequest

- (NSString *)actionName
{
    return @"city!morecities";
}

- (void)loadWithCompletion:(JWCompletion)completion
{
    NSArray *cityList = [JWUserDefaultsUtil cityList];
    if (cityList.count > 0) {
        completion(@{
            kJWData : cityList
        },
                   nil);
    } else {
        [super loadWithCompletion:^(NSDictionary *dict, NSError *error) {
            NSArray *array = [JWCityItem arrayFromDictionary:dict];
            completion(@{
                         kJWData: array
                         }, error);
            [JWUserDefaultsUtil saveCityList:array];
        }];
    }
}

@end
