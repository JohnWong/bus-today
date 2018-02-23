//
//  NSObject+ValueForKey.m
//  BusRider
//
//  Created by John Wong on 01/10/2017.
//  Copyright © 2017 John Wong. All rights reserved.
//

#import "NSObject+ValueForKey.h"
#import <objc/runtime.h>


@implementation NSObject (ValueForKey)

- (nullable id)JW_safeValueForKey:(NSString *)key
{
    if (key.length == 0) {
        return nil;
    }
    Ivar ivar = class_getInstanceVariable(self.class, key.UTF8String);
    if (ivar) {
        return object_getIvar(self, ivar);
    }
    if (class_getInstanceMethod(self.classForCoder, NSSelectorFromString(key))) {
        return [self valueForKey:key];
    }
    return nil;
}

@end
