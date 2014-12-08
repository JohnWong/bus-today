//
//  JWBusInfoItem.h
//  BusRider
//
//  Created by John Wong on 12/6/14.
//  Copyright (c) 2014 John Wong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, JWBusState) {
    JWBusStateNotStarted,
    JWBusStateFar,
    JWBusStateNear,
    JWBusStateNotFound
};

@interface JWBusInfoItem : NSObject

@property (nonatomic, assign) JWBusState state;
@property (nonatomic, assign) NSInteger order; // 当前车站序号
@property (nonatomic, strong) NSString *currentStop; // 当前车站
@property (nonatomic, strong) NSString *lineNumber; // 路线名称
@property (nonatomic, strong) NSString *from; // 始发站
@property (nonatomic, strong) NSString *to; // 终点站
@property (nonatomic, assign) NSInteger remains; // 最近一辆车还有几站，JWBusStateFar时有效
@property (nonatomic, strong) NSString *firstTime; // 首班时间
@property (nonatomic, strong) NSString *lastTime; // 末班时间
@property (nonatomic, assign) NSInteger updateTime; // 信息上次报告时间
@property (nonatomic, assign) NSInteger distance; // 车辆距离，JWBusStateNear时有效
@property (nonatomic, assign) NSInteger pastTime; // 上一辆车发出的分钟数

- (instancetype)initWithUserStop:(NSString *)userStop busInfo:(NSDictionary *)busInfo;
- (void)setUserStop:(NSString *)userStop busInfo:(NSDictionary *)dict;

@end
