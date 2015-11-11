//
//  JWSessionManager.h
//  BusRider
//
//  Created by John Wong on 11/11/15.
//  Copyright © 2015 John Wong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WatchConnectivity/WatchConnectivity.h>


@interface JWSessionManager : NSObject <WCSessionDelegate>

+ (instancetype)defaultManager;
- (void)activate;

@end


@interface JWSessionManager (JWContext)

- (void)updateApplicationContext:(NSDictionary<NSString *, id> *)context;

@end
