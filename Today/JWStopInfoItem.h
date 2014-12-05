//
//  JWStopInfoItem.h
//  BusRider
//
//  Created by John Wong on 12/5/14.
//  Copyright (c) 2014 John Wong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JWStopInfoItem : UIView

@property (nonatomic, assign) NSInteger order;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) NSInteger lastOrder; // 上一个有车辆信息的站点序号
@property (nonatomic, assign) NSInteger stopRemains; // 最近车辆距本站车站数

- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (void)setFromDict:(NSDictionary *)dict;

@end
