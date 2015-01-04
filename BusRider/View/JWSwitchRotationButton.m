//
//  JWSwitchRotationButton.m
//  BusRider
//
//  Created by John Wong on 1/3/15.
//  Copyright (c) 2015 John Wong. All rights reserved.
//

#import "JWSwitchRotationButton.h"

@implementation JWSwitchRotationButton

#pragma mark setter
- (void)setOn:(BOOL)on  {
    [super setOn:on];
    [UIView animateWithDuration:0.3 animations:^{
        if (on) {
            self.imageView.transform = CGAffineTransformMakeRotation(M_PI);
        } else {
            self.imageView.transform = CGAffineTransformMakeRotation(0);
        }
    }];
}

@end
