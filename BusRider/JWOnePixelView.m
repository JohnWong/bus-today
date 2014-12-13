//
//  JWOnePixelView.m
//  BusRider
//
//  Created by John Wong on 12/11/14.
//  Copyright (c) 2014 John Wong. All rights reserved.
//

#import "JWOnePixelView.h"

@implementation JWOnePixelView

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        ((NSLayoutConstraint *)self.constraints[0]).constant = 1 / [UIScreen mainScreen].scale;
    }
    return self;
}

@end
