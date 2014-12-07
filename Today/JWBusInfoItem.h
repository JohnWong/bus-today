//
//  JWBusInfoItem.h
//  BusRider
//
//  Created by John Wong on 12/6/14.
//  Copyright (c) 2014 John Wong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JWBusInfoItem : NSObject

@property (nonatomic, strong) NSString *currentStop; // 当前车站
@property (nonatomic, strong) NSString *lineNumber; // 路线名称
@property (nonatomic, strong) NSString *from; // 始发站
@property (nonatomic, strong) NSString *to; // 终点站
@property (nonatomic, assign) NSInteger remains; // 最近一辆车到本站距离
@property (nonatomic, strong) NSString *firstTime; // 首班时间
@property (nonatomic, strong) NSString *lastTime; // 末班时间
@property (nonatomic, assign) NSInteger updateTime; // 信息上次更新时间

@end
