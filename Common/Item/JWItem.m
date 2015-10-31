//
//  JWItem.m
//  BusRider
//
//  Created by John Wong on 12/17/14.
//  Copyright (c) 2014 John Wong. All rights reserved.
//

#import "JWItem.h"


@implementation JWItem

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setFromDictionary:dict];
    }
    return self;
}

- (instancetype)init
{
    return [super init];
}

- (void)setFromDictionary:(NSDictionary *)dict {}

+ (NSArray *)arrayFromDictionaryArray:(NSArray *)array
{
    NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithCapacity:array.count];
    for (NSDictionary *dict in array) {
        id item = [[self alloc] initWithDictionary:dict];
        [mutableArray addObject:item];
    }
    return [NSArray arrayWithArray:mutableArray];
}

@end
