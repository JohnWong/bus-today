//
//  JWFormatter.h
//  BusRider
//
//  Created by John Wong on 1/13/15.
//  Copyright (c) 2015 John Wong. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface JWFormatter : NSObject

+ (NSString *)formatedLineNumber:(NSString *)lineNumber;
+ (NSString *)formatedCost:(NSInteger)time;
+ (NSString *)formatedTime:(NSTimeInterval)time;
+ (NSString *)formatedDistance:(NSInteger)distance;

@end
