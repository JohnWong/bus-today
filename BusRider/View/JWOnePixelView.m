//
//  JWOnePixelView.m
//  BusRider
//
//  Created by John Wong on 12/11/14.
//  Copyright (c) 2014 John Wong. All rights reserved.
//

#import "JWOnePixelView.h"

@implementation JWOnePixelView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        for (NSLayoutConstraint *constraint in self.constraints) {
            if (constraint.firstAttribute == NSLayoutAttributeHeight) {
                constraint.constant = kOnePixel;
            }
        }
    }
    return self;
}

@end
