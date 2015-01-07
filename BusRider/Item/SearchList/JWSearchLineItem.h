//
//  JWSearchLineItem.h
//  BusRider
//
//  Created by John Wong on 1/7/15.
//  Copyright (c) 2015 John Wong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JWItem.h"

/**
 *  Used by JWSearchListItem
 */
@interface JWSearchLineItem : JWItem

/**
 *  线路ID
 */
@property (nonatomic, strong) NSString *lineId;
/**
 *  线路名称
 */
@property (nonatomic, strong) NSString *lineNumber;

@end
