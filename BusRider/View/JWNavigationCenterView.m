//
//  JWNavigationCenterView.m
//  BusRider
//
//  Created by John Wong on 1/16/15.
//  Copyright (c) 2015 John Wong. All rights reserved.
//

#import "JWNavigationCenterView.h"
#import "JWViewUtil.h"
#import "JWSwitchRotationButton.h"

@interface JWNavigationCenterView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) JWSwitchRotationButton *button;

@end

@implementation JWNavigationCenterView

- (instancetype)initWithTitle:(NSString *)title {
    if (self = [super initWithFrame:CGRectMake(0, 0, 0, 24)]) {
        [self addSubview:self.titleLabel];
        [self addSubview:self.button];
        [self setTitle:title];
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
    self.titleLabel.width = title ? [title sizeWithFont:self.titleLabel.font].width : 0;
    self.button.left = self.titleLabel.width;
    self.width = self.titleLabel.width + self.button.width;
    if (title) {
        self.button.hidden = NO;
    }
}

#pragma mark getter
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [JWViewUtil labelWithFrame:CGRectMake(0, (self.height - 20) / 2.0, 0, 20) text:nil size:17 color:[UIColor blackColor]];
    }
    return _titleLabel;
}

- (JWSwitchRotationButton *)button {
    if (!_button) {
        _button = [[JWSwitchRotationButton alloc] initWithFrame:CGRectMake(0, 0, self.height, self.height)];
        [_button setImage:[UIImage imageNamed:@"JWIconExpand"] forState:UIControlStateNormal];
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
        _button.hidden = YES;
        [_button addGestureRecognizer:tapRecognizer];
    }
    return _button;
}

- (void)didTap:(UIButton *)sender {
    self.button.on = !self.button.on;
    if (self.delegate) {
        [self.delegate setOn:self.button.isOn];
    }
}

- (void)setOn:(BOOL)isOn {
    [self.button setOn:isOn];
}

@end
