//
//  JWBusLineItem.m
//  BusRider
//
//  Created by John Wong on 12/18/14.
//  Copyright (c) 2014 John Wong. All rights reserved.
//

#import "JWBusLineItem.h"
#import "JWItemArray.h"
#import "JWStopItem.h"
#import "JWBusItem.h"

@implementation JWBusLineItem

- (void)setFromDictionary:(NSDictionary *)dict {
    self.lineItem = [[JWLineItem alloc] initWithDictionary:dict];
    self.stopItems = [JWItemArray arrayWithItemClass:JWStopItem.class dictArray:dict[@"map"]];
    self.busItems = [JWItemArray arrayWithItemClass:JWBusItem.class dictArray:dict[@"bus"]];
    
}

@end
