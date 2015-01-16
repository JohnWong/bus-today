//
//  JWNavigationCenterView.h
//  BusRider
//
//  Created by John Wong on 1/16/15.
//  Copyright (c) 2015 John Wong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JWNavigationCenterDelegate

- (void)setOn:(BOOL)isOn;

@end

/**
 *  包含1个label和一个button
 */
@interface JWNavigationCenterView : UIView

@property (nonatomic, weak) id<JWNavigationCenterDelegate> delegate;

- (instancetype)initWithTitle:(NSString *)title;
- (void)setTitle:(NSString *)title;
- (void)setOn:(BOOL)isOn;

@end
