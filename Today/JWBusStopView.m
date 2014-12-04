//
//  JWBusStopView.m
//  BusRider
//
//  Created by John Wong on 12/5/14.
//  Copyright (c) 2014 John Wong. All rights reserved.
//

#import "JWBusStopView.h"

@interface JWBusStopView()

@property (nonatomic, strong) UIView *leftView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation JWBusStopView

#pragma mark lifecycle
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.leftView];
        [self addSubview:self.titleLabel];
    }
    return self;
}

#pragma mark getter
- (UIView *)leftView {
    if (!_leftView) {
        _leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 47, self.height)];
        NSInteger radius = 8;
        UIView *centerView = [[UIView alloc] initWithFrame:CGRectMake((_leftView.width - radius) / 2, (_leftView.height - radius) / 2, radius, radius)];
        centerView.layer.cornerRadius = radius / 2.0;
        centerView.backgroundColor = HEXCOLOR(0x4cd964);
        [_leftView addSubview:centerView];
    }
    return _leftView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(47, 0, self.width - 47, self.height)];
        _titleLabel.textColor = [UIColor whiteColor];
    }
    return _titleLabel;
}

#pragma mark callable
- (void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
}

@end
