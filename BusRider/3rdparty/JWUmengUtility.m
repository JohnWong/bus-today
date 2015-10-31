//
//  JWUmengUtility.m
//  BusRider
//
//  Created by John Wong on 3/16/15.
//  Copyright (c) 2015 John Wong. All rights reserved.
//

#import "JWUmengUtility.h"


@implementation JWUmengUtility

static NSString *JWUmengAppkey = @"5505ca7bfd98c5b3bc000020";

+ (void)setupUmeng
{
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    [MobClick startWithAppkey:JWUmengAppkey
                 reportPolicy:BATCH
                    channelId:nil];
    /*
     Class cls = NSClassFromString(@"UMANUtil");
     SEL deviceIDSelector = @selector(openUDIDString);
     NSString *deviceID = nil;
     if(cls && [cls respondsToSelector:deviceIDSelector]){
     deviceID = [cls performSelector:deviceIDSelector];
     }
     NSData* jsonData = [NSJSONSerialization dataWithJSONObject:@{@"oid" : deviceID}
     options:NSJSONWritingPrettyPrinted
     error:nil];
     
     NSLog(@"%@", [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
     */
}

@end
