//
//  JWSearchListItem.h
//  BusRider
//
//  Created by John Wong on 1/7/15.
//  Copyright (c) 2015 John Wong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JWItem.h"


@interface JWSearchListItem : JWItem

/**
 *  array of JWSearchLineItem;
 */
@property (nonatomic, strong) NSArray *lineList;
/**
 *  array of JWSearchStopItem
 */
@property (nonatomic, strong) NSArray *stopList;

@end
