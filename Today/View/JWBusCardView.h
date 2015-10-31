//
//  JWBusCardView.h
//  BusRider
//
//  Created by John Wong on 12/6/14.
//  Copyright (c) 2014 John Wong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JWBusInfoItem.h"


@interface JWBusCardView : UIView

- (void)setLoadingView;
- (void)setErrorView:(NSString *)errorMessage;
- (void)setItem:(JWBusInfoItem *)item;

@end
