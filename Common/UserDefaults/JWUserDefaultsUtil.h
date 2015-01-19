//
//  JWUserDefaultsUtil.h
//  BusRider
//
//  Created by John Wong on 1/8/15.
//  Copyright (c) 2015 John Wong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JWCollectItem.h"

#define JWKeyBusLine @"BusLine"
#define JWKeyCity @"City"

@interface JWUserDefaultsUtil : NSObject

+ (instancetype)standardUserDefaults;
+ (instancetype)groupUserDefaults;

- (void)setObject:(id)userInfo forKey:(NSString *)key;
- (void)removeObjectForKey:(NSString *)key;
- (id)objectForKey:(NSString *)key;
- (void)setItem:(id)item forKey:(NSString *)key;
- (id)itemForKey:(NSString *)key;

//---------------------------------------------------------------
// 收藏店铺的方法
+ (void)saveCollectItem:(JWCollectItem *)item;
+ (JWCollectItem *)collectItemForLineId:(NSString *)lineId;
+ (void)removeCollectItemWithLineId:(NSString *)lineId;
/**
 *  返回所有收藏的线路信息
 *
 *  @return array of JWCollectItem
 */
+ (NSArray *)allCollectItems;

@end
