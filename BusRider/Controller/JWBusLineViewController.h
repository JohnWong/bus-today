//
//  JWBusLineViewController.h
//  BusRider
//
//  Created by John Wong on 12/12/14.
//  Copyright (c) 2014 John Wong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JWBusLineItem.h"
#import "JWSearchLineItem.h"
#import "JWStopItem.h"
#import "JWBusInfoItem.h"

@interface JWBusLineViewController : UIViewController

/**
 *  传过来的线路信息
 */
@property (nonatomic, strong) JWBusLineItem *busLineItem;
/**
 *  传过来的到站信息
 */
@property (nonatomic, strong) JWBusInfoItem *busInfoItem;

/**
 *  传过来的线路id
 */
@property (nonatomic, strong) NSString *lineId;
/**
 *  当前用户站点
 */
@property (nonatomic, strong) NSString *selectedStopId;

@end
