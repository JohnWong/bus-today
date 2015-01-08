//
//  JWUserDefaultsUtil.h
//  BusRider
//
//  Created by John Wong on 1/8/15.
//  Copyright (c) 2015 John Wong. All rights reserved.
//

#import <Foundation/Foundation.h>

#define JWKeyBusLine @"BusLine"

@interface JWUserDefaultsUtil : NSObject

+ (instancetype)standardUserDefaults;
+ (instancetype)groupUserDefaults;

- (void)setObject:(id)userInfo forKey:(NSString *)key;
- (void)removeObjectForKey:(NSString *)key;
- (id)objectForKey:(NSString *)key;

//---------------------------------------------------------------
// 收藏店铺的方法
+ (void)saveLineNumber:(NSString *)lineNumber lineId:(NSString *)lineId stopId:(NSString *)stopId;
+ (NSString *)stopIdForLineId:(NSString *)lineId;
+ (void)removeLineId:(NSString *)lineId;
+ (NSArray *)allStopIdAndLineId;

@end
