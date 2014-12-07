//
//  AppDelegate.m
//  BusRider
//
//  Created by John Wong on 12/2/14.
//  Copyright (c) 2014 John Wong. All rights reserved.
//

#import "AppDelegate.h"
#import "JWBusInfoItem.h"
#import "STHTTPRequest.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
//    NSString *lineId = @"0571-0428-0";//@"0571-044-0";
//    //    NSString *urlStr=[NSString stringWithFormat:@"http://api.chelaile.net.cn:7000/bus/line!map2.action?lineId=%@&s=IOS&v=2.9&cityId=004&sign=", lineId];
//    NSString *urlStr=[NSString stringWithFormat:@"http://localhost:7000/bus/line!map2.action?lineId=%@&s=IOS&v=2.9&cityId=004&sign=", lineId];
//    
//    STHTTPRequest *request = [STHTTPRequest requestWithURLString:urlStr];
//    request.completionBlock = ^(NSDictionary *headers, NSString *body) {
//        NSString *jsonString = [[body stringByReplacingOccurrencesOfString:@"**YGKJ" withString:@""] stringByReplacingOccurrencesOfString:@"YGKJ##" withString:@""];
//        NSError *error = nil;
//        id dict = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
//        if (error == nil && [dict isKindOfClass:[NSDictionary class]]) {
//            NSDictionary *busInfo = (NSDictionary *)dict[@"jsonr"][@"data"];
//            NSLog(@"%@", busInfo);
//            
//            /*
//             NSMutableArray *mapArray = [busInfo[@"map"] mutableCopy];
//             NSArray *busArray = busInfo[@"bus"];
//             NSInteger itemHeight = 32;
//             NSInteger margin = 12;
//             self.containerView.frame = CGRectMake(0, margin, self.view.width, (busArray.count + 1) * itemHeight);
//             self.preferredContentSize = CGSizeMake(self.view.width, self.containerView.height + margin * 2);
//             
//             for (int i = 0; i < busArray.count; i++) {
//             NSDictionary *busDict = busArray[i];
//             NSInteger order = [busDict[@"order"] integerValue] - 1;
//             NSMutableDictionary *mapDict = [mapArray[order] mutableCopy];
//             mapDict[@"bus"] = busDict;
//             [mapArray replaceObjectAtIndex:order withObject:mapDict];
//             }
//             
//             NSInteger top = 0;
//             NSInteger lastOrder = 0;
//             for (NSDictionary * mapDict in mapArray) {
//             NSDictionary *busDict = mapDict[@"bus"];
//             if (busDict) {
//             JWStopInfoItem *stopInfoItem = [[JWStopInfoItem alloc] initWithDictionary:mapDict];
//             if ([stopInfoItem.title isEqualToString: @"文一西路狮山路口"]) {
//             stopInfoItem.lastOrder = lastOrder;
//             }
//             JWBusStopView *busStopView = [[JWBusStopView alloc] initWithFrame:CGRectMake(0, top * itemHeight, self.view.width, itemHeight - 1)];
//             top ++;
//             [busStopView setItem:stopInfoItem];
//             [self.containerView addSubview:busStopView];
//             lastOrder = [busDict[@"order"] integerValue];
//             } else if ([mapDict[@"stopName"] isEqualToString:@"文一西路狮山路口"]) {
//             JWStopInfoItem *stopInfoItem = [[JWStopInfoItem alloc] initWithDictionary:mapDict];
//             stopInfoItem.lastOrder = lastOrder;
//             JWBusStopView *busStopView = [[JWBusStopView alloc] initWithFrame:CGRectMake(0, top * itemHeight, self.view.width, itemHeight - 1)];
//             top ++;
//             [busStopView setItem:stopInfoItem];
//             [self.containerView addSubview:busStopView];
//             }
//             }
//             */
//            JWBusInfoItem *busInfoItem = [[JWBusInfoItem alloc] initWithDict:busInfo];
//        }
//    };
//    request.errorBlock = ^(NSError *error) {
//        NSLog(@"%@", error);
//    };
//    
//    [request startAsynchronous];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
