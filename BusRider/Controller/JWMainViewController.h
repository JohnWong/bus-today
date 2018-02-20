//
//  JWMainViewController.h
//  BusRider
//
//  Created by John Wong on 12/15/14.
//  Copyright (c) 2014 John Wong. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface JWMainViewController : UIViewController

/**
 *  Pass to JWBusLineViewController
 */
@property (nonatomic, strong) NSString *selectedLineId;

/**
 *  Pass to JWBusLineViewController
 */
@property (nonatomic, strong) NSString *selectedLineNumber;

@end
