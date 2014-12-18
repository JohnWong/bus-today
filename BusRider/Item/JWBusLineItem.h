//
//  JWBusLineItem.h
//  BusRider
//
//  Created by John Wong on 12/18/14.
//  Copyright (c) 2014 John Wong. All rights reserved.
//

#import "JWItem.h"
#import "JWLineItem.h"

@interface JWBusLineItem : JWItem

@property (nonatomic, strong) JWLineItem *lineItem;
@property (nonatomic, strong) NSArray *stopItems; // JWStopItem
@property (nonatomic, strong) NSArray *busItems; // JWBusItem

@end
