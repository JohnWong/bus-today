//
//  JWBusLineItem.h
//  BusRider
//
//  Created by John Wong on 12/18/14.
//  Copyright (c) 2014 John Wong. All rights reserved.
//

#import "JWItem.h"
#import "JWLineItem.h"

/**
 *  包含了一个JWLineItem和多个JWStopItem、JWBusItem
 */
@interface JWBusLineItem : JWItem

@property (nonatomic, strong) JWLineItem *lineItem;

/**
 *  Array of JWStopItem
 */
@property (nonatomic, strong) NSArray *stopItems;

/**
 *  Array of JWBusItem
 */
@property (nonatomic, strong) NSArray *busItems;

@end
