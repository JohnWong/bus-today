//
//  JWBusLineItem.m
//  BusRider
//
//  Created by John Wong on 12/18/14.
//  Copyright (c) 2014 John Wong. All rights reserved.
//

#import "JWBusLineItem.h"
#import "JWStopItem.h"
#import "JWBusItem.h"


@implementation JWBusLineItem

- (void)setFromDictionary:(NSDictionary *)dict
{
    self.lineItem = [[JWLineItem alloc] initWithDictionary:dict];
    self.stopItems = [JWStopItem arrayFromDictionaryArray:dict[@"stations"]];
    self.busItems = [JWBusItem arrayFromDictionaryArray:dict[@"buses"]];
}

@end
