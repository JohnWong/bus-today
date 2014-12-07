//
//  JWBusCardView.m
//  BusRider
//
//  Created by John Wong on 12/6/14.
//  Copyright (c) 2014 John Wong. All rights reserved.
//

#import "JWBusCardView.h"

@interface JWBusCardView()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *fromToLabel;
@property (nonatomic, strong) UILabel *durationLabel;
@property (nonatomic, strong) UILabel *stationLabel;

@end

@implementation JWBusCardView

#pragma mark lifecycle
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.titleLabel];
        [self addSubview:self.fromToLabel];
        [self addSubview:self.durationLabel];
        
        [self addSubview:self.stationLabel];
    }
    return self;
}

#pragma mark getter
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, 32)];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:18];
    }
    return _titleLabel;
}

- (UILabel *)fromToLabel {
    if (!_fromToLabel) {
        _fromToLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _titleLabel.bottom, self.width, 18)];
        _fromToLabel.textColor = [UIColor whiteColor];
        _fromToLabel.font = [UIFont systemFontOfSize:16];
    }
    return _fromToLabel;
}

- (UILabel *)durationLabel {
    if (!_durationLabel) {
        _durationLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _fromToLabel.bottom, self.width, 16)];
        _durationLabel.textColor = [UIColor whiteColor];
        _durationLabel.font = [UIFont systemFontOfSize:14];
    }
    return _durationLabel;
}

#pragma mark callable
- (void)setItem:(JWBusInfoItem *)item {
    self.titleLabel.text = [NSString stringWithFormat:@"%@路", item.lineNumber];
    self.fromToLabel.text = [NSString stringWithFormat:@"%@ -> %@", item.from, item.to];
    self.durationLabel.text = [NSString stringWithFormat:@"首: %@ 末: %@", item.firstTime, item.lastTime];
}

@end
