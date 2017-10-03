//
//  JWCollectItem.h
//  BusRider
//
//  Created by John Wong on 1/11/15.
//  Copyright (c) 2015 John Wong. All rights reserved.
//

#import "JWItem.h"

typedef enum : NSUInteger {
    JWCollectItemTypeLine,
    JWCollectItemTypeStop,
} JWCollectItemType;


@interface JWCollectItem : JWItem <NSCoding>

@property (nonatomic, assign) JWCollectItemType itemType;

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
 *  当前站点名称
 */
@property (nonatomic, strong) NSString *stopName;
/**
 *  站点序号
 */
@property (nonatomic, assign) NSInteger order;
/**
 站点类型的收藏
 */
@property (nonatomic, strong) NSString *stopId;

- (instancetype)initWithLineId:(NSString *)lineId lineNumber:(NSString *)lineNumber from:(NSString *)from to:(NSString *)to stopName:(NSString *)stopName order:(NSInteger)order NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithStopId:(NSString *)stopId stopName:(NSString *)stopName NS_DESIGNATED_INITIALIZER;
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSDictionary *toDictionary;

@end
