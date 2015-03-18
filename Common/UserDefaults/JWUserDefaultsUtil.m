//
//  JWUserDefaultsUtil.m
//  BusRider
//
//  Created by John Wong on 1/8/15.
//  Copyright (c) 2015 John Wong. All rights reserved.
//

#import "JWUserDefaultsUtil.h"

#define JWSuiteName @"group.johnwong.busrider"

#define JWKeyCollectedLine  @"JWKeyCollectedLine"
#define JWKeyTodayBusLine   @"JWKeyTodayBusLine"
#define JWKeyCity           @"JWKeyCity"

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
    static JWUserDefaultsUtil *standardUserDefaults;
    if (!standardUserDefaults) {
        standardUserDefaults = [[self alloc] initWithUserDefaults:[NSUserDefaults standardUserDefaults]];
    }
    return standardUserDefaults;
}

+ (instancetype)groupUserDefaults {
    static JWUserDefaultsUtil *groupUserDefaults;
    if (!groupUserDefaults) {
        groupUserDefaults = [[self alloc] initWithUserDefaults:[[NSUserDefaults alloc] initWithSuiteName:JWSuiteName]];
    }
    return groupUserDefaults;
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
    if (itemData) {
        return [NSKeyedUnarchiver unarchiveObjectWithData:itemData];
    } else {
        return nil;
    }
}

+ (void)setCityItem:(JWCityItem *)item {
    [[self groupUserDefaults] setItem:item forKey:JWKeyCity];
}

+ (JWCityItem *)cityItem {
    return [[self groupUserDefaults] itemForKey:JWKeyCity];
}

+ (void)addCollectItem:(JWCollectItem *)item {
    NSString *key = [JWUserDefaultsUtil combinedkey:JWKeyCollectedLine];
    if (key) {
        JWUserDefaultsUtil *userDefaults = [self standardUserDefaults];
        NSMutableArray *lineList = [[userDefaults itemForKey:key] mutableCopy];
        if (lineList == nil) {
            lineList = [[NSMutableArray alloc] initWithObjects:item, nil];
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
            [lineList addObject:item];
        }
        [userDefaults setItem:[NSArray arrayWithArray:lineList] forKey:key];
    }
}

+ (void)removeCollectItemWithLineId:(NSString *)lineId {
    
    NSString *key = [JWUserDefaultsUtil combinedkey:JWKeyCollectedLine];
    if (key) {
        JWUserDefaultsUtil *userDefaults = [self standardUserDefaults];
        NSArray *lineList = [userDefaults itemForKey:key];
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
        [userDefaults setItem:lineList forKey:key];
    }
}

+ (JWCollectItem *)collectItemForLineId:(NSString *)lineId {
    NSString *key = [JWUserDefaultsUtil combinedkey:JWKeyCollectedLine];
    if (key) {
        JWUserDefaultsUtil *userDefaults = [self standardUserDefaults];
        NSArray *lineList = [userDefaults itemForKey:key];
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
    } else {
        return nil;
    }
}

+ (NSArray *)allCollectItems {
    NSString *key = [JWUserDefaultsUtil combinedkey:JWKeyCollectedLine];
    if (key) {
        JWUserDefaultsUtil *userDefaults = [self standardUserDefaults];
        return [userDefaults itemForKey:key];
    } else {
        return nil;
    }
}

+ (NSString *)combinedkey:(NSString *)key {
    JWCityItem *cityItem = [self cityItem];
    if (cityItem) {
        return [NSString stringWithFormat:@"%@-%@", cityItem.cityId, key];
    } else {
        return nil;
    }
}

+ (void)setTodayBusLine:(JWCollectItem *)busLine {
    NSString *key = [self combinedkey:JWKeyTodayBusLine];
    if (key) {
        [[self groupUserDefaults] setItem:busLine forKey:key];
    }
}

+ (JWCollectItem *)todayBusLine {
    NSString *key = [self combinedkey:JWKeyTodayBusLine];
    if (key) {
        return [[self groupUserDefaults] itemForKey:key];
    } else {
        return nil;
    }
}

+ (void)removeTodayBusLine {
    NSString *key = [self combinedkey:JWKeyTodayBusLine];
    if (key) {
        return [[self groupUserDefaults] removeObjectForKey:key];
    }
}

@end
