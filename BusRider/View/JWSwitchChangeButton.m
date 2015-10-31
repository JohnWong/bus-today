//
//  JWSwitchChangeButton.m
//  BusRider
//
//  Created by John Wong on 1/3/15.
//  Copyright (c) 2015 John Wong. All rights reserved.
//

#import "JWSwitchChangeButton.h"


@implementation JWSwitchChangeButton

- (void)setOn:(BOOL)on
{
    [super setOn:on];
    if (on) {
        [self setImage:self.onImage forState:UIControlStateNormal];
        [self setImage:self.onImage forState:UIControlStateHighlighted];
    } else {
        [self setImage:self.offImage forState:UIControlStateNormal];
        [self setImage:self.offImage forState:UIControlStateHighlighted];
    }
}

@end
