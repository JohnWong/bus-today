//
//  JWUserDefaultsUtil.m
//  BusRider
//
//  Created by John Wong on 1/8/15.
//  Copyright (c) 2015 John Wong. All rights reserved.
//

#import "JWUserDefaultsUtil.h"

#define JWSuiteName @"group.johnwong.busrider"

static NSString *const JWKeyCollectedItem = @"JWKeyCollectedItem";
static NSString *const JWKeyTodayBusLine = @"JWKeyTodayBusLine";
static NSString *const JWKeyCity = @"JWKeyCity";
static NSString *const JWKeyPushSearchController = @"JWKeyPushSearchController";
static NSString *const JWKeyCityList = @"JWKeyCityList";
static NSString *const JWKeyCityListDate = @"JWKeyCityListDate";


@interface JWUserDefaultsUtil ()

@property (nonatomic, strong) NSUserDefaults *userDefaults;

@end


@implementation JWUserDefaultsUtil

- (instancetype)initWithUserDefaults:(NSUserDefaults *)userDefaults
{
    if (self = [super init]) {
        self.userDefaults = userDefaults;
    }
    return self;
}

+ (instancetype)groupUserDefaults
{
    static JWUserDefaultsUtil *groupUserDefaults;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        groupUserDefaults = [[self alloc] initWithUserDefaults:[[NSUserDefaults alloc] initWithSuiteName:JWSuiteName]];
    });
    return groupUserDefaults;
}

- (void)setObject:(id)userInfo forKey:(NSString *)key
{
    NSUserDefaults *sharedUserDefaults = self.userDefaults;
    [sharedUserDefaults setObject:userInfo forKey:key];
    [sharedUserDefaults synchronize];
}

- (void)removeObjectForKey:(NSString *)key
{
    NSUserDefaults *sharedUserDefaults = self.userDefaults;
    [sharedUserDefaults removeObjectForKey:key];
    [sharedUserDefaults synchronize];
}

- (id)objectForKey:(NSString *)key
{
    NSUserDefaults *sharedUserDefaults = self.userDefaults;
    return [sharedUserDefaults objectForKey:key];
}

- (void)setItem:(id)item forKey:(NSString *)key
{
    NSData *itemData = [NSKeyedArchiver archivedDataWithRootObject:item];
    [self setObject:itemData forKey:key];
}

- (id)itemForKey:(NSString *)key
{
    NSUserDefaults *sharedUserDefaults = self.userDefaults;
    NSData *itemData = [sharedUserDefaults objectForKey:key];
    if (itemData) {
        return [NSKeyedUnarchiver unarchiveObjectWithData:itemData];
    } else {
        return nil;
    }
}

+ (void)setCityItem:(JWCityItem *)item
{
    [[self groupUserDefaults] setItem:item forKey:JWKeyCity];
}

+ (JWCityItem *)cityItem
{
    return [[self groupUserDefaults] itemForKey:JWKeyCity];
}

+ (void)addCollectItem:(JWCollectItem *)item
{
    NSString *key = [JWUserDefaultsUtil combinedkey:JWKeyCollectedItem];
    if (key) {
        JWUserDefaultsUtil *userDefaults = [self groupUserDefaults];
        NSMutableArray *lineList = [[userDefaults itemForKey:key] mutableCopy];
        if (lineList == nil) {
            lineList = [[NSMutableArray alloc] initWithObjects:item, nil];
        } else {
            for (NSInteger i = lineList.count - 1; i >= 0; i--) {
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

+ (void)removeCollectItemForBlock:(BOOL (^)(JWCollectItem *item))block
{
    if (!block) {
        return;
    }
    NSString *key = [JWUserDefaultsUtil combinedkey:JWKeyCollectedItem];
    if (key) {
        JWUserDefaultsUtil *userDefaults = [self groupUserDefaults];
        NSArray *lineList = [userDefaults itemForKey:key];
        if (lineList == nil) {
            return;
        }
        for (NSInteger i = lineList.count - 1; i >= 0; i--) {
            JWCollectItem *savedItem = lineList[i];
            if (block(savedItem)) {
                NSMutableArray *mutableArray = [lineList mutableCopy];
                [mutableArray removeObjectAtIndex:i];
                lineList = mutableArray;
                break;
            }
        }
        [userDefaults setItem:lineList forKey:key];
    }
}

+ (void)removeCollectItemWithLineId:(NSString *)lineId
{
    [self removeCollectItemForBlock:^BOOL(JWCollectItem *item) {
        return item.itemType == JWCollectItemTypeLine && [item.lineId isEqualToString:lineId];
    }];
}

+ (void)removeCollectItemWithStopId:(NSString *)stopId
{
    [self removeCollectItemForBlock:^BOOL(JWCollectItem *item) {
        return item.itemType == JWCollectItemTypeStop && [item.stopId isEqualToString:stopId];
    }];
}

+ (JWCollectItem *)collectItemForBlock:(BOOL (^)(JWCollectItem *item))block
{
    if (!block) return nil;
    NSString *key = [JWUserDefaultsUtil combinedkey:JWKeyCollectedItem];
    if (key) {
        JWUserDefaultsUtil *userDefaults = [self groupUserDefaults];
        NSArray *lineList = [userDefaults itemForKey:key];
        if (lineList == nil) {
            return nil;
        } else {
            for (JWCollectItem *item in lineList) {
                if (block(item)) {
                    return item;
                }
            }
            return nil;
        }
    } else {
        return nil;
    }
}

+ (JWCollectItem *)collectItemForLineId:(NSString *)lineId
{
    return [self collectItemForBlock:^BOOL(JWCollectItem *item) {
        return item.itemType == JWCollectItemTypeLine && [item.lineId isEqualToString:lineId];
    }];
}

+ (JWCollectItem *)collectItemForStopId:(NSString *)stopId
{
    return [self collectItemForBlock:^BOOL(JWCollectItem *item) {
        return item.itemType == JWCollectItemTypeStop && [item.stopId isEqualToString:stopId];
    }];
}

+ (NSArray *)allCollectItems
{
    NSString *key = [JWUserDefaultsUtil combinedkey:JWKeyCollectedItem];
    if (key) {
        JWUserDefaultsUtil *userDefaults = [self groupUserDefaults];
        return [userDefaults itemForKey:key];
    } else {
        return nil;
    }
}

+ (NSString *)combinedkey:(NSString *)key
{
    JWCityItem *cityItem = [self cityItem];
    if (cityItem) {
        return [NSString stringWithFormat:@"%@-%@", cityItem.cityId, key];
    } else {
        return nil;
    }
}

+ (void)setTodayBusLine:(JWCollectItem *)busLine
{
    NSString *key = [self combinedkey:JWKeyTodayBusLine];
    if (key) {
        [[self groupUserDefaults] setItem:busLine forKey:key];
    }
}

+ (JWCollectItem *)todayBusLine
{
    NSString *key = [self combinedkey:JWKeyTodayBusLine];
    if (key) {
        return [[self groupUserDefaults] itemForKey:key];
    } else {
        return nil;
    }
}

+ (void)removeTodayBusLine
{
    NSString *key = [self combinedkey:JWKeyTodayBusLine];
    if (key) {
        return [[self groupUserDefaults] removeObjectForKey:key];
    }
}

+ (void)setPushSearchController:(BOOL)value
{
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:JWKeyPushSearchController];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)pushSearchController
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:JWKeyPushSearchController];
}

+ (NSString *)timeKey
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    formatter.dateFormat = @"yyyyMMdd";
    return [formatter stringFromDate:[NSDate date]];
}

+ (void)saveCityList:(NSArray *)array
{
    [((JWUserDefaultsUtil *)[self groupUserDefaults]) setItem:array forKey:JWKeyCityList];
    [((JWUserDefaultsUtil *)[self groupUserDefaults]).userDefaults setObject:[self timeKey] forKey:JWKeyCityListDate];
}

+ (NSArray *)cityList
{
    NSString *key = [self timeKey];
    NSString *savedKey = [((JWUserDefaultsUtil *)[self groupUserDefaults]).userDefaults stringForKey:JWKeyCityListDate];
    if ([key isEqualToString:savedKey]) {
        return [((JWUserDefaultsUtil *)[self groupUserDefaults]) itemForKey:JWKeyCityList];
    } else {
        [((JWUserDefaultsUtil *)[self groupUserDefaults]).userDefaults removeObjectForKey:JWKeyCityList];
        return nil;
    }
}

@end
