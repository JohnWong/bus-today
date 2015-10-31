//
//  JWButtonWithAnimation.m
//  BusRider
//
//  Created by John Wong on 12/10/14.
//  Copyright (c) 2014 John Wong. All rights reserved.
//

#import "JWButtonWithAnimation.h"

#define kJWRefreshAnimationKey @"JWRefreshAnimationKey"


@interface JWButtonWithAnimation ()

@property (nonatomic, assign) BOOL shouldStop;

@end


@implementation JWButtonWithAnimation

- (void)startAnimation
{
    // make refresh button rotate
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.duration = 1.0;
    animation.repeatCount = CGFLOAT_MAX;
    animation.fromValue = @0.0f;
    animation.toValue = @M_PI;
    animation.delegate = self;
    [self.imageView.layer addAnimation:animation forKey:kJWRefreshAnimationKey];
}

- (void)stopAnimation
{
    [self.imageView.layer removeAnimationForKey:kJWRefreshAnimationKey];
}

@end
