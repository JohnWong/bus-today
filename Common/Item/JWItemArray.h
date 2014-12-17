//
//  JWItemArray.h
//  BusRider
//
//  Created by John Wong on 12/18/14.
//  Copyright (c) 2014 John Wong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JWItemArray : NSObject

+ (NSArray *)arrayWithItemClass:(Class)cls dictArray:(NSArray *)array;

@end
