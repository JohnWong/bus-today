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

- (void)setItem:(id)item forKey:(NSString *)key {
    NSData *itemData = [NSKeyedArchiver archivedDataWithRootObject:item];
    [self setObject:itemData forKey:key];
}

- (id)itemForKey:(NSString *)key {
    NSUserDefaults *sharedUserDefaults = [self userDefaults];
    NSData *itemData = [sharedUserDefaults objectForKey:key];
    return [NSKeyedUnarchiver unarchiveObjectWithData:itemData];
}

+ (void)saveCollectItem:(JWCollectItem *)item {
    JWUserDefaultsUtil *userDefaults = [self standardUserDefaults];
    NSArray *lineList = [userDefaults itemForKey:JWKeyLineStop];
    if (lineList == nil) {
        lineList = @[item];
    } else  {
        for (NSInteger i = lineList.count - 1; i >= 0 ; i--) {
            JWCollectItem *savedItem = lineList[i];
            if ([savedItem.lineId isEqualToString:item.lineId]) {
                NSMutableArray *mutableArray = [lineList mutableCopy];
                [mutableArray removeObjectAtIndex:i];
                lineList = mutableArray;
                break;
            }
        }
        lineList = [lineList arrayByAddingObject:item];
    }
    [userDefaults setItem:lineList forKey:JWKeyLineStop];
}

+ (void)removeCollectItemWithLineId:(NSString *)lineId {
    JWUserDefaultsUtil *userDefaults = [self standardUserDefaults];
    NSArray *lineList = [userDefaults itemForKey:JWKeyLineStop];
    if (lineList == nil) {
        return;
    }
    for (NSInteger i = lineList.count - 1; i >= 0 ; i--) {
        JWCollectItem *savedItem = lineList[i];
        if ([savedItem.lineId isEqualToString:lineId]) {
            NSMutableArray *mutableArray = [lineList mutableCopy];
            [mutableArray removeObjectAtIndex:i];
            lineList = mutableArray;
            break;
        }
    }
    [userDefaults setItem:lineList forKey:JWKeyLineStop];
}

+ (JWCollectItem *)collectItemForLineId:(NSString *)lineId {
    JWUserDefaultsUtil *userDefaults = [self standardUserDefaults];
    NSArray *lineList = [userDefaults itemForKey:JWKeyLineStop];
    if (lineList == nil) {
        return nil;
    } else {
        for (JWCollectItem *item in lineList) {
            if ([item.lineId isEqualToString:lineId]) {
                return item;
            }
        }
        return nil;
    }
}

+ (NSArray *)allCollectItems {
    JWUserDefaultsUtil *userDefaults = [self standardUserDefaults];
    return [userDefaults itemForKey:JWKeyLineStop];
}

@end
