//
//  JWStopItem.h
//  BusRider
//
//  Created by John Wong on 12/17/14.
//  Copyright (c) 2014 John Wong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "JWItem.h"
/**
 *  Used by JWBusLineItem
 */
@interface JWStopItem : JWItem

/**
 *  站点序号
 */
@property (nonatomic, assign) NSInteger order;
/**
 *  站点名称
 */
@property (nonatomic, strong) NSString *stopName;
/**
 *  站点ID，换向时使用，可能变掉。
 */
@property (nonatomic, strong) NSString *stopId;

- (instancetype)initWithOrder:(NSInteger)order stopName:(NSString *)stopName stopId:(NSString *)stopId NS_DESIGNATED_INITIALIZER;

@end
