//
//  JWLineItem.h
//  BusRider
//
//  Created by John Wong on 12/17/14.
//  Copyright (c) 2014 John Wong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JWItem.h"
/**
 *  Used by JWBusLineItem
 */
@interface JWLineItem : JWItem
/**
 *  路线id
 */
@property (nonatomic, strong) NSString *lineId;
/**
 *  路线名称
 */
@property (nonatomic, strong) NSString *lineNumber;
/**
 *  始发站
 */
@property (nonatomic, strong) NSString *from;
/**
 *  终点站
 */
@property (nonatomic, strong) NSString *to;
/**
 *  首班时间
 */
@property (nonatomic, strong) NSString *firstTime;
/**
 *  末班时间
 */
@property (nonatomic, strong) NSString *lastTime;
/**
 *  反向线路id
 */
@property (nonatomic, strong) NSString *otherLineId;

@end
