//
//  JWItem.h
//  BusRider
//
//  Created by John Wong on 12/17/14.
//  Copyright (c) 2014 John Wong. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface JWItem : NSObject

- (instancetype)init NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithDictionary:(NSDictionary *)dict NS_DESIGNATED_INITIALIZER;
- (void)setFromDictionary:(NSDictionary *)dict;
/**
 *  Get array of JWItem from array of NSDictionary
 *
 *  @param array of NSDictionary
 *
 *  @return array of JWItem
 */
+ (NSArray *)arrayFromDictionaryArray:(NSArray *)array;

@end
