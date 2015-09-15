//
//  JWCityItem.m
//  BusRider
//
//  Created by John Wong on 1/19/15.
//  Copyright (c) 2015 John Wong. All rights reserved.
//

#import "JWCityItem.h"

#define JWKeyCityId @"cityId"
#define JWKeyCityName @"cityName"
#define JWKeyCityVersion @"cityVersion"

@implementation JWCityItem

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.cityId = [aDecoder decodeObjectForKey:JWKeyCityId];
        self.cityName = [aDecoder decodeObjectForKey:JWKeyCityName];
        self.cityVersion = [[aDecoder decodeObjectForKey:JWKeyCityVersion] integerValue];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.cityId forKey:JWKeyCityId];
    [aCoder encodeObject:self.cityName forKey:JWKeyCityName];
    [aCoder encodeObject:@(self.cityVersion) forKey:JWKeyCityVersion];
}

- (void)setFromDictionary:(NSDictionary *)dict {
    self.cityId = dict[@"cityId"];
    self.cityName = dict[@"cityName"];
    self.cityVersion = [dict[@"cityVersion"] integerValue];
}

+ (NSArray *)arrayFromDictionary:(NSDictionary *)dict {
    NSArray *cities = [self arrayFromDictionaryArray:dict[@"cities"]];
    NSMutableArray *ret = [NSMutableArray array];
    for (JWCityItem *item in cities) {
        [ret addObject:item];
    }
    return ret;
}

@end
