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
#import "JWUserDefaultsUtil.h"
#import "JWSearchLineItem.h"
#import "JWMainViewController.h"
#import "Appirater.h"
#import "JWSessionManager.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>


@interface AppDelegate ()

@end


@implementation AppDelegate

static NSString *AppID = @"975022341";

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Fabric with:@[ [Crashlytics class] ]];

    //#ifdef DEBUG
    //    [Appirater setDebug:YES];
    //#endif
    [Appirater appLaunched:YES];

    [[JWSessionManager defaultManager] activate];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [Appirater appEnteredForeground:YES];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    JWCollectItem *todayItem = [JWUserDefaultsUtil todayBusLine];
    if (todayItem) {
        UINavigationController *navigationViewController = (UINavigationController *)self.window.rootViewController;
        [navigationViewController popToRootViewControllerAnimated:YES];
        JWMainViewController *mainViewController = (JWMainViewController *)navigationViewController.topViewController;
        mainViewController.selectedLineId = todayItem.lineId;
        mainViewController.selectedLineNumber = todayItem.lineNumber;
        [mainViewController performSegueWithIdentifier:JWSeguePushLineWithId sender:mainViewController];
    }
    return YES;
}

@end
