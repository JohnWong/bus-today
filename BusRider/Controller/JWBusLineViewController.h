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
 *  传过来的线路id
 */
@property (nonatomic, strong) NSString *lineId;

/**
 *  传过来的线路名称
 */
@property (nonatomic, strong) NSString *lineNumber;

/**
 *  换向时使用
 */
@property (nonatomic, strong) NSString *selectedStopId;

@end
