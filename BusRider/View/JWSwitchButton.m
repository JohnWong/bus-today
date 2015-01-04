//
//  JWSwitchButton.m
//  BusRider
//
//  Created by John Wong on 1/3/15.
//  Copyright (c) 2015 John Wong. All rights reserved.
//

#import "JWSwitchButton.h"
#import <CoreGraphics/CoreGraphics.h>

@implementation JWSwitchButton

#pragma mark lifecycle
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:(NSCoder *)aDecoder]) {
        [self addTarget:self action:@selector(didTap:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

#pragma mark action
- (void)didTap:(UIButton *)sender {
    self.on = !self.on;
}

@end
