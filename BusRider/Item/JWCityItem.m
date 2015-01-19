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

@implementation JWCityItem

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.cityId = [aDecoder decodeObjectForKey:JWKeyCityId];
        self.cityName = [aDecoder decodeObjectForKey:JWKeyCityName];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.cityId forKey:JWKeyCityId];
    [aCoder encodeObject:self.cityName forKey:JWKeyCityName];
}

- (void)setFromDictionary:(NSDictionary *)dict {
    self.cityId = dict[@"cityId"];
    self.cityName = dict[@"cityName"];
}

+ (NSArray *)arrayFromDictionary:(NSDictionary *)dict {
    return [self arrayFromDictionaryArray:dict[@"cities"]];
}

@end
