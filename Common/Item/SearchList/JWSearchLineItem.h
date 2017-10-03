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
/**
 *  起点站
 */
@property (nonatomic, strong) NSString *from;
/**
 *  终点站
 */
@property (nonatomic, strong) NSString *to;

- (instancetype)initWithLineId:(NSString *)lineId lineNumber:(NSString *)lineNumber NS_DESIGNATED_INITIALIZER;

@end
