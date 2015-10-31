//
//  JWCharIconView.m
//  BusRider
//
//  Created by John Wong on 12/7/14.
//  Copyright (c) 2014 John Wong. All rights reserved.
//

#import "JWCharIconView.h"


@interface JWCharIconView ()

@property (nonatomic, strong) UILabel *centerLabel;

@end


@implementation JWCharIconView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.layer.cornerRadius = 3.5;
        self.layer.borderColor = kJWMinorColor.CGColor;
        self.layer.borderWidth = 0.5;
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.centerLabel];
        self.clipsToBounds = NO;
    }
    return self;
}

#pragma mark getter
- (UILabel *)centerLabel
{
    if (!_centerLabel) {
        CGFloat margin = 1;
        _centerLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin, margin, self.width - margin * 2, self.height - margin * 2)];
        _centerLabel.text = self.text;
        _centerLabel.font = [UIFont systemFontOfSize:self.height - margin * 2];
        _centerLabel.textAlignment = NSTextAlignmentCenter;
        _centerLabel.textColor = kJWMinorColor;
    }
    return _centerLabel;
}

- (void)setText:(NSString *)text
{
    self.centerLabel.text = text;
}

- (void)setColor:(UIColor *)color
{
    self.layer.borderColor = color.CGColor;
    self.centerLabel.textColor = color;
}

@end
