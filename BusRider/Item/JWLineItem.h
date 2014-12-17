//
//  JWLineItem.h
//  BusRider
//
//  Created by John Wong on 12/17/14.
//  Copyright (c) 2014 John Wong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JWItem.h"

@interface JWLineItem : JWItem

@property (nonatomic, strong) NSString *lineId; // 路线id
@property (nonatomic, strong) NSString *lineNumber; // 路线名称
@property (nonatomic, strong) NSString *from; // 始发站
@property (nonatomic, strong) NSString *to; // 终点站
@property (nonatomic, strong) NSString *firstTime; // 首班时间
@property (nonatomic, strong) NSString *lastTime; // 末班时间

@property (nonatomic, strong) NSString *otherLineId;  // 反向线路id
@property (nonatomic, assign) NSInteger pastTime; // 上一辆车发出的时间

@end
