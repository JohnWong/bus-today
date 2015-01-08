//
//  JWUserDefaultsUtil.m
//  BusRider
//
//  Created by John Wong on 1/8/15.
//  Copyright (c) 2015 John Wong. All rights reserved.
//

#import "JWUserDefaultsUtil.h"

#define JWSuiteName @"group.visionary.busrider"

#define JWKeyLineStop @"JWKeyLineStop"

@interface JWUserDefaultsUtil ()

@property (nonatomic, strong) NSUserDefaults *userDefaults;

@end

@implementation JWUserDefaultsUtil

- (instancetype)initWithUserDefaults:(NSUserDefaults *)userDefaults {
    if (self = [super init]) {
        self.userDefaults = userDefaults;
    }
    return self;
}

+ (instancetype)standardUserDefaults {
    return [[self alloc] initWithUserDefaults:[NSUserDefaults standardUserDefaults]];
}

+ (instancetype)groupUserDefaults {
    return [[self alloc] initWithUserDefaults:[[NSUserDefaults alloc] initWithSuiteName:JWSuiteName]];
}

- (void)setObject:(id)userInfo forKey:(NSString *)key {
    NSUserDefaults *sharedUserDefaults = [self userDefaults];
    [sharedUserDefaults setObject:userInfo forKey:key];
    [sharedUserDefaults synchronize];
}

- (void)removeObjectForKey:(NSString *)key {
    NSUserDefaults *sharedUserDefaults = [self userDefaults];
    [sharedUserDefaults removeObjectForKey:key];
    [sharedUserDefaults synchronize];
}

- (id)objectForKey:(NSString *)key {
    NSUserDefaults *sharedUserDefaults = [self userDefaults];
    return [sharedUserDefaults objectForKey:key];
}

+ (void)saveLineNumber:(NSString *)lineNumber lineId:(NSString *)lineId stopId:(NSString *)stopId {
    JWUserDefaultsUtil *userDefaults = [self standardUserDefaults];
    NSArray *lineList = [userDefaults objectForKey:JWKeyLineStop];
    NSDictionary *dict = @{
                           @"stopId": stopId,
                           @"lineId": lineId,
                           @"lineNumber": lineNumber
                           };
    if (lineList == nil) {
        lineList = [NSArray arrayWithObject:dict];
    } else  {
        for (NSInteger i = lineList.count - 1; i >= 0 ; i--) {
            NSDictionary *dict = lineList[i];
            NSString *storedLineId = dict[@"lineId"];
            if ([storedLineId isEqualToString:lineId]) {
                NSMutableArray *mutableArray = [lineList mutableCopy];
                [mutableArray removeObjectAtIndex:i];
                lineList = mutableArray;
                break;
            }
        }
        lineList = [lineList arrayByAddingObject:dict];
    }
    [userDefaults setObject:lineList forKey:JWKeyLineStop];
    
}

+ (void)removeLineId:(NSString *)lineId {
    JWUserDefaultsUtil *userDefaults = [self standardUserDefaults];
    NSArray *lineList = [userDefaults objectForKey:JWKeyLineStop];
    if (lineList == nil) {
        return;
    }
    for (NSInteger i = lineList.count - 1; i >= 0 ; i--) {
        NSDictionary *dict = lineList[i];
        NSString *storedLineId = dict[@"lineId"];
        if ([storedLineId isEqualToString:lineId]) {
            NSMutableArray *mutableArray = [lineList mutableCopy];
            [mutableArray removeObjectAtIndex:i];
            lineList = mutableArray;
            break;
        }
    }
    [userDefaults setObject:lineList forKey:JWKeyLineStop];
}

+ (NSString *)stopIdForLineId:(NSString *)lineId {
    JWUserDefaultsUtil *userDefaults = [self standardUserDefaults];
    NSArray *lineList = [userDefaults objectForKey:JWKeyLineStop];
    if (lineList == nil) {
        return nil;
    } else {
        for (NSDictionary *dict in lineList) {
            if ([dict[@"lineId"] isEqualToString:lineId]) {
                return dict[@"stopId"];
            }
        }
        return nil;
    }
}

+ (NSArray *)allStopIdAndLineId {
    JWUserDefaultsUtil *userDefaults = [self standardUserDefaults];
    return [userDefaults objectForKey:JWKeyLineStop];
}

@end
