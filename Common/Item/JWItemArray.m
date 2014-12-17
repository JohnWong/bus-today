//
//  JWItemArray.m
//  BusRider
//
//  Created by John Wong on 12/18/14.
//  Copyright (c) 2014 John Wong. All rights reserved.
//

#import "JWItemArray.h"
#import "JWItem.h"

@implementation JWItemArray

+ (NSArray *)arrayWithItemClass:(Class)cls dictArray:(NSArray *)array {
    NSArray *ret = [[NSArray alloc] init];
    if ([cls isSubclassOfClass:JWItem.class]) {
        for (NSDictionary *dict in array) {
            JWItem *item = [[cls alloc] initWithDictionary:dict];
            ret = [ret arrayByAddingObject:item];
        }
    }
    return ret;
}

@end
