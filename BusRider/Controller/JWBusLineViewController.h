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

@interface JWBusLineViewController : UIViewController

/**
 *  传过来的线路信息
 */
@property (nonatomic, strong) JWBusLineItem *busLineItem;
/**
 *  传过来的线路id和名称
 */
@property (nonatomic, strong) JWSearchLineItem *searchLineItem;
/**
 *  当前用户站点
 */
@property (nonatomic, strong) JWStopItem *selectedStopItem;

@end
