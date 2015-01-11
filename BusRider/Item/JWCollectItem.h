//
//  JWCollectItem.h
//  BusRider
//
//  Created by John Wong on 1/11/15.
//  Copyright (c) 2015 John Wong. All rights reserved.
//

#import "JWItem.h"

@interface JWCollectItem : NSObject <NSCoding>

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
 *  当前站点id
 */
@property (nonatomic, strong) NSString *stopId;
/**
 *  当前站点名称
 */
@property (nonatomic, strong) NSString *stopName;

- (instancetype)initWithLineId:(NSString *)lineId lineNumber:(NSString *)lineNumber from:(NSString *)from to:(NSString *)to stopId:(NSString *)stopId stopName:(NSString *)stopName NS_DESIGNATED_INITIALIZER;

@end
