//
//  JWItem.h
//  BusRider
//
//  Created by John Wong on 12/17/14.
//  Copyright (c) 2014 John Wong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JWItem : NSObject

- (id)initWithDictionary:(NSDictionary *)dict;
- (void)setFromDictionary:(NSDictionary *)dict;

@end
