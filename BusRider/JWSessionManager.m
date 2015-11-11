//
//  JWSessionManager.m
//  BusRider
//
//  Created by John Wong on 11/11/15.
//  Copyright © 2015 John Wong. All rights reserved.
//

#import "JWSessionManager.h"


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
    if (_session && _session.paired && _session.watchAppInstalled && _session) {
        return _session;
    }
    return nil;
}

- (void)sessionWatchStateDidChange:(WCSession *)session
{
}

- (void)sessionReachabilityDidChange:(WCSession *)session
{
}

@end


@implementation JWSessionManager (JWContext)

- (void)updateApplicationContext:(NSDictionary<NSString *, id> *)context
{
    NSError *error = nil;
    if (![[self validSession] updateApplicationContext:context error:&error]) {
        NSLog(@"%@", error.localizedDescription);
    }
}

- (void)session:(WCSession *__nonnull)session didFinishUserInfoTransfer:(WCSessionUserInfoTransfer *)userInfoTransfer error:(nullable NSError *)error
{
}

- (void)session:(WCSession *)session didReceiveUserInfo:(NSDictionary<NSString *, id> *)userInfo
{
}

@end
