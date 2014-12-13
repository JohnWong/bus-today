//
//  JWStopNameButton.m
//  BusRider
//
//  Created by John Wong on 12/13/14.
//  Copyright (c) 2014 John Wong. All rights reserved.
//

#import "JWStopNameButton.h"

@implementation JWStopNameButton

- (id)initWithFrame:(CGRect)frame {
    if ((self = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class)  owner:self options:nil][0])) {
        [self setFrame:frame];
    }
    return self;
}

@end
