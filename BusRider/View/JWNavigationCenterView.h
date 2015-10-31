//
//  JWNavigationCenterView.h
//  BusRider
//
//  Created by John Wong on 1/16/15.
//  Copyright (c) 2015 John Wong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JWSwitchRotationButton.h"

@class JWNavigationCenterView;

@protocol JWNavigationCenterDelegate

- (void)buttonItem:(JWNavigationCenterView *)buttonItem setOn:(BOOL)isOn;

@end


@interface JWNavigationCenterView : JWSwitchRotationButton

@property (nonatomic, weak) id<JWNavigationCenterDelegate> delegate;

- (instancetype)initWithTitle:(NSString *)title isBold:(BOOL)isBold;
- (void)setTitle:(NSString *)title;

@end
