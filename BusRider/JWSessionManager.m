//
//  JWSessionManager.m
//  BusRider
//
//  Created by John Wong on 11/11/15.
//  Copyright © 2015 John Wong. All rights reserved.
//

#import "JWSessionManager.h"
#import "JWUserDefaultsUtil.h"


@implementation JWSessionManager {
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
    if ([WCSession isSupported]) {
        [_session activateSession];
    }
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
    NSLog(@"JW: session change %d %d", session.watchAppInstalled, session.reachable);
    if ([self validSession]) {
        [self sync];
    }
}

- (void)sessionReachabilityDidChange:(WCSession *)session
{
#if TARGET_OS_WATCH
    NSLog(@"JW: reachability change %d", session.reachable);
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
        mutableDict[@"city"] = [cityItem toDictionary];
    }
    JWCollectItem *today = [JWUserDefaultsUtil todayBusLine];
    if (today) {
        mutableDict[@"today"] = [today toDictionary];
    }
    NSError *error = nil;
    WCSession *validSession = [self validSession];
    if (!validSession) {
#if TARGET_OS_WATCH
        NSLog(@"JW: no valid session %d", _session.reachable);
#else
        NSLog(@"JW: no valid session %d %d", _session.watchAppInstalled, _session.reachable);
#endif
    } else if (![[self validSession] updateApplicationContext:mutableDict error:&error]) {
        NSLog(@"JW: update context fail %@", error.localizedDescription);
    }
}

- (void)session:(WCSession *__nonnull)session didFinishUserInfoTransfer:(WCSessionUserInfoTransfer *)userInfoTransfer error:(nullable NSError *)error
{
}

- (void)session:(WCSession *)session didReceiveUserInfo:(NSDictionary<NSString *, id> *)userInfo
{
}

@end
