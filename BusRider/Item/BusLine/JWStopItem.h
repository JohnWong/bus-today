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
 *  站点经纬度
 */
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
/**
 *  站点序号
 */
@property (nonatomic, assign) NSInteger order;
/**
 *  站点ID
 */
@property (nonatomic, strong) NSString *stopId;
/**
 *  站点名称
 */
@property (nonatomic, strong) NSString *stopName;

- (instancetype)initWithStopId:(NSString *)stopId stopName:(NSString *)stopName;

@end
