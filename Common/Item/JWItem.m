//
//  JWItem.m
//  BusRider
//
//  Created by John Wong on 12/17/14.
//  Copyright (c) 2014 John Wong. All rights reserved.
//

#import "JWItem.h"

@implementation JWItem

- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        [self setFromDictionary:dict];
    }
    return self;
}

- (void)setFromDictionary:(NSDictionary *)dict {}

@end
