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
    }
    return _leftView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(47, 0, self.width - 47, self.height)];
        _titleLabel.font = [UIFont systemFontOfSize:22];
        _titleLabel.textColor = [UIColor whiteColor];
    }
    return _titleLabel;
}

#pragma mark callable
- (void)setItem:(JWStopInfoItem *)item {
    if (item.lastOrder > 0) {
        self.titleLabel.text = item.lastOrder > 0? [NSString stringWithFormat:@"%@ (还有%ld站)", item.title, item.stopRemains] : item.title;
        self.titleLabel.textColor = HEXCOLOR(0xEF0708);
        self.titleLabel.font = [UIFont boldSystemFontOfSize:22];
        NSInteger imageSize = 16;
        UIImageView *busView = [[UIImageView alloc] initWithFrame:CGRectMake((self.leftView.width - imageSize) / 2, (self.leftView.height - imageSize) / 2, imageSize, imageSize)];
        busView.image = [UIImage imageNamed:@"JWIconBus"];
        [self.leftView addSubview:busView];
    } else {
        self.titleLabel.text = item.title;
        NSInteger radius = 8;
        UIView *centerView = [[UIView alloc] initWithFrame:CGRectMake((_leftView.width - radius) / 2, (_leftView.height - radius) / 2, radius, radius)];
        centerView.layer.cornerRadius = radius / 2.0;
        centerView.backgroundColor = HEXCOLOR(0x4cd964);
        [_leftView addSubview:centerView];
    }
    
}

@end
