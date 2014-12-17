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

@interface JWStopItem : JWItem

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, assign) NSInteger order;
@property (nonatomic, strong) NSString *stopId;
@property (nonatomic, strong) NSString *stopName;

@end
