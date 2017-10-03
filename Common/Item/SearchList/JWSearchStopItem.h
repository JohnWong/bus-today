//
//  JWSearchStopItem.h
//  BusRider
//
//  Created by John Wong on 1/7/15.
//  Copyright (c) 2015 John Wong. All rights reserved.
//

#import "JWItem.h"

/**
 *  Used by JWSearchListItem
 */
@interface JWSearchStopItem : JWItem

/**
 *  车站名称
 */
@property (nonatomic, strong) NSString *stopName;
/**
 *  站点ID
 */
@property (nonatomic, strong) NSString *stopId;

- (instancetype)initWithStopId:(NSString *)stopId stopName:(NSString *)stopName NS_DESIGNATED_INITIALIZER;

@end
