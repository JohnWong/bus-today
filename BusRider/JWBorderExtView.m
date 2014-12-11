//
//  JWBorderExtView.m
//  BusRider
//
//  Created by John Wong on 12/11/14.
//  Copyright (c) 2014 John Wong. All rights reserved.
//

#import "JWBorderExtView.h"
#import <QuartzCore/QuartzCore.h>

@interface JWBorderExtView()

@property (nonatomic, strong) CAShapeLayer *maskLayer;

@end

@implementation JWBorderExtView

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

#pragma mark getter
- (CAShapeLayer *)maskLayer {
    if (!_maskLayer) {
        _maskLayer = [[CAShapeLayer alloc] init];
        _maskLayer.frame = self.bounds;
        [self.layer addSublayer:_maskLayer];
    }
    return _maskLayer;
}

- (void)setCorner:(UIRectCorner)corners radius:(CGFloat)radius{
//    self.clipsToBounds = NO;
//    self.layer.borderColor = [UIColor redColor].CGColor;
//    self.layer.borderWidth = 1.0f;
//    
//    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
//                                                   byRoundingCorners: corners
//                                                         cornerRadii:CGSizeMake(radius, radius)];
//    self.maskLayer.path = maskPath.CGPath;
    
    self.clipsToBounds = NO;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds    byRoundingCorners:UIRectCornerTopLeft cornerRadii:CGSizeMake(radius, radius)];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    maskLayer.lineWidth = 1.0;
    maskLayer.strokeColor = [UIColor greenColor].CGColor;
    maskLayer.fillColor = [UIColor whiteColor].CGColor;
    [self.layer addSublayer:maskLayer];
}


@end
