//
//  JWSessionManager.m
//  BusRider
//
//  Created by John Wong on 11/11/15.
//  Copyright © 2015 John Wong. All rights reserved.
//

#import "JWSessionManager.h"
#import "JWUserDefaultsUtil.h"

static NSString *const kCity = @"city";
static NSString *const kToday = @"today";


@implementation JWSessionManager
{
    WCSession *_session;
}

+ (instancetype)defaultManager
{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        if ([WCSession isSupported]) {
            _session = [WCSession defaultSession];
            _session.delegate = self;
        }
    }
    return self;
}

- (void)activate
{
    [_session activateSession];
}

- (WCSession *)validSession
{
#if TARGET_OS_WATCH
    return _session;
#else
    if (_session && _session.paired && _session.watchAppInstalled) {
        return _session;
    }
    return nil;
#endif
}

- (void)sessionWatchStateDidChange:(WCSession *)session
{
    //    NSLog(@"JW: session change %d %d", session.watchAppInstalled, session.reachable);
    if ([self validSession]) {
        [self sync];
    }
}

- (void)sessionReachabilityDidChange:(WCSession *)session
{
#if TARGET_OS_WATCH
    NSLog(@"JW: reachability change");
#else
    NSLog(@"JW: reachability change %d %d", session.watchAppInstalled, session.reachable);
#endif
    if ([self validSession]) {
        [self sync];
    }
}

@end


@implementation JWSessionManager (JWContext)

- (void)sync
{
    NSMutableDictionary<NSString *, id> *mutableDict = [NSMutableDictionary dictionary];
    JWCityItem *cityItem = [JWUserDefaultsUtil cityItem];
    if (cityItem) {
        mutableDict[kCity] = cityItem.toDictionary;
    }
    JWCollectItem *today = [JWUserDefaultsUtil todayBusLine];
    if (today) {
        mutableDict[kToday] = today.toDictionary;
    }
    NSError *error = nil;
    WCSession *validSession = [self validSession];
    if (!validSession) {
#if TARGET_OS_WATCH
        NSLog(@"JW: no valid session");
#else
        NSLog(@"JW: no valid session %d %d", _session.paired, _session.watchAppInstalled);
#endif
    } else if (![[self validSession] updateApplicationContext:mutableDict error:&error]) {
        NSLog(@"JW: update context fail %@", error.localizedDescription);
    }
}

- (void)session:(WCSession *)session didReceiveApplicationContext:(NSDictionary<NSString *, id> *)applicationContext
{
    BOOL changed = NO;
    if (applicationContext[kCity]) {
        JWCityItem *city = [[JWCityItem alloc] initWithDictionary:applicationContext[kCity]];
        JWCityItem *original = [JWUserDefaultsUtil cityItem];
        if (![city isEqual:original]) {
            [JWUserDefaultsUtil setCityItem:city];
            changed = YES;
        }
    }
    if (applicationContext[kToday]) {
        JWCollectItem *today = [[JWCollectItem alloc] initWithDictionary:applicationContext[kToday]];
        JWCollectItem *original = [JWUserDefaultsUtil todayBusLine];
        if (![today isEqual:original]) {
            [JWUserDefaultsUtil setTodayBusLine:today];
            changed = YES;
        }
    }
    if (changed) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationContextUpdate object:nil];
        });
    }
}

@end
