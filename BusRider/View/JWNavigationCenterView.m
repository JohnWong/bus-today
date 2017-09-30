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

//@property (nonatomic, strong) UILabel *titleLabel;
//@property (nonatomic, strong) JWSwitchRotationButton *button;

@end


@implementation JWNavigationCenterView

- (instancetype)initWithTitle:(NSString *)title isBold:(BOOL)isBold
{
    if (self = [super initWithFrame:CGRectMake(0, 0, 0, 24)]) {
        [self addSubview:self.titleLabel];
        if (isBold) {
            self.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        } else {
            self.titleLabel.font = [UIFont systemFontOfSize:17];
        }
        self.alpha = 0;
        [self setTitle:title];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

        [self setImage:[[UIImage imageNamed:@"JWIconExpand"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
        [self addGestureRecognizer:tapRecognizer];
    }
    return self;
}

- (void)setTitle:(NSString *)title
{
    [self setTitle:title forState:UIControlStateNormal];
    CGFloat width = (title ? [title sizeWithAttributes:@{NSFontAttributeName : self.titleLabel.font}].width : 0);
    CGFloat imageWidth = 18;
    self.width = width + imageWidth;
    self.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWidth, 0, imageWidth);
    self.imageEdgeInsets = UIEdgeInsetsMake(0, width + (imageWidth - 14) / 2.0, 0, (imageWidth - 14) / 2.0);
    if (title) {
        self.alpha = 1;
    }
}

- (void)didTap:(UIButton *)sender
{
    self.on = !self.on;
}

- (void)setOn:(BOOL)on
{
    [super setOn:on];
    if (self.delegate) {
        [self.delegate buttonItem:self setOn:self.isOn];
    }
}

@end
