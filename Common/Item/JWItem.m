//
//  JWItem.m
//  BusRider
//
//  Created by John Wong on 12/17/14.
//  Copyright (c) 2014 John Wong. All rights reserved.
//

#import "JWItem.h"

@implementation JWItem

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        [self setFromDictionary:dict];
    }
    return self;
}

- (void)setFromDictionary:(NSDictionary *)dict {}

+ (NSArray *)arrayFromDictionaryArray:(NSArray *)array {
    NSArray *ret = [[NSArray alloc] init];
    for (NSDictionary *dict in array) {
        id item = [[self alloc] initWithDictionary:dict];
        ret = [ret arrayByAddingObject:item];
    }
    return ret;
}

@end
