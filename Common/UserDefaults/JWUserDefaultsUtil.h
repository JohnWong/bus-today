//
//  JWUserDefaultsUtil.h
//  BusRider
//
//  Created by John Wong on 1/8/15.
//  Copyright (c) 2015 John Wong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JWCollectItem.h"
#import "JWCityItem.h"

@interface JWUserDefaultsUtil : NSObject

#pragma mark today busline
+ (void)setTodayBusLine:(JWCollectItem *)busLine;
+ (JWCollectItem *)todayBusLine;
+ (void)removeTodayBusLine;

#pragma mark city
+ (void)setCityItem:(JWCityItem *)item;
+ (JWCityItem *)cityItem;

#pragma mark collect busline
+ (void)addCollectItem:(JWCollectItem *)item;
+ (JWCollectItem *)collectItemForLineId:(NSString *)lineId;
+ (void)removeCollectItemWithLineId:(NSString *)lineId;
/**
 *  返回所有收藏的线路信息
 *
 *  @return array of JWCollectItem
 */
+ (NSArray *)allCollectItems;

@end
