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

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.cityId = [aDecoder decodeObjectForKey:JWKeyCityId];
        self.cityName = [aDecoder decodeObjectForKey:JWKeyCityName];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.cityId forKey:JWKeyCityId];
    [aCoder encodeObject:self.cityName forKey:JWKeyCityName];
}

- (void)setFromDictionary:(NSDictionary *)dict
{
    self.cityId = dict[@"cityId"];
    self.cityName = dict[@"cityName"];
}

- (NSDictionary *)toDictionary
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"cityId"] = self.cityId;
    dict[@"cityName"] = self.cityName;
    return [dict copy];
}

+ (NSArray *)arrayFromDictionary:(NSDictionary *)dict
{
    NSArray *cities = [self arrayFromDictionaryArray:dict[@"cities"]];
    NSMutableArray *ret = [NSMutableArray array];
    for (JWCityItem *item in cities) {
        [ret addObject:item];
    }
    return ret;
}

- (BOOL)isEqual:(id)object
{
    if ([object isKindOfClass:self.class]) {
        typeof(self) cityItem = object;
        return [self.cityId isEqualToString:cityItem.cityId] &&
            [self.cityName isEqualToString:cityItem.cityName];
    }
    return NO;
}

@end
