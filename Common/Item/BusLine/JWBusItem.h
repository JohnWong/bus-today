//
//  JWBusItem.h
//  BusRider
//
//  Created by John Wong on 12/18/14.
//  Copyright (c) 2014 John Wong. All rights reserved.
//

#import "JWItem.h"
/**
 *  Used by JWBusLineItem
 */
@interface JWBusItem : JWItem

@property (nonatomic, assign, getter=isArrived) BOOL arrived;
@property (nonatomic, assign) NSInteger order;
@property (nonatomic, assign) NSInteger distance;
@property (nonatomic, assign) NSInteger lastTime;
@property (nonatomic, strong) NSString *stopId;

@end
