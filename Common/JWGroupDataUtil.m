//
//  JWGroupDataUtil.m
//  BusRider
//
//  Created by John Wong on 1/6/15.
//  Copyright (c) 2015 John Wong. All rights reserved.
//

#import "JWGroupDataUtil.h"

#define JWSuiteName @"group.visionary.busrider"

@implementation JWGroupDataUtil

+ (void)setObject:(id)userInfo forKey:(NSString *)key {
    NSUserDefaults *sharedUserDefaults = [[NSUserDefaults alloc] initWithSuiteName:JWSuiteName];
    [sharedUserDefaults setObject:userInfo forKey:key];
    [sharedUserDefaults synchronize];
}

+ (void)removeObjectForKey:(NSString *)key {
    NSUserDefaults *sharedUserDefaults = [[NSUserDefaults alloc] initWithSuiteName:JWSuiteName];
    [sharedUserDefaults removeObjectForKey:key];
    [sharedUserDefaults synchronize];
}

+ (id)objectForKey:(NSString *)key {
    NSUserDefaults *sharedUserDefaults = [[NSUserDefaults alloc] initWithSuiteName:JWSuiteName];
    return [sharedUserDefaults objectForKey:key];
}

@end
