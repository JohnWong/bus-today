//
//  JWGroupDataUtil.h
//  BusRider
//
//  Created by John Wong on 1/6/15.
//  Copyright (c) 2015 John Wong. All rights reserved.
//

#import <Foundation/Foundation.h>

#define JWKeyBusLine @"BusLine"

@interface JWGroupDataUtil : NSObject

+ (void)setObject:(id)userInfo forKey:(NSString *)key;
+ (void)removeObjectForKey:(NSString *)key;
+ (id)objectForKey:(NSString *)key;

@end
