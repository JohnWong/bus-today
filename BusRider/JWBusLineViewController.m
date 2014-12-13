//
//  JWBusLineViewController.m
//  BusRider
//
//  Created by John Wong on 12/12/14.
//  Copyright (c) 2014 John Wong. All rights reserved.
//

#import "JWBusLineViewController.h"
#import "JWStopNameButton.h"

#define kJWButtonHeight 49

@interface JWBusLineViewController()

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (nonatomic, strong) UIScrollView *view;

@end

@implementation JWBusLineViewController

#pragma mark lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setViews];
}

- (void)setViews {
    NSInteger count = 5;
    self.contentView.height = count * kJWButtonHeight;
    ((NSLayoutConstraint *)self.contentView.constraints[0]).constant = count * kJWButtonHeight;
    
    for (int i = 0; i < count; i ++) {
        UIView *button = [[JWStopNameButton alloc] initWithFrame:CGRectMake(0, i * kJWButtonHeight, self.contentView.width, kJWButtonHeight)];
        [self.contentView addSubview:button];
        [self.contentView addConstraints:@[
                                           [NSLayoutConstraint
                                            constraintWithItem:button
                                            attribute:NSLayoutAttributeLeading
                                            relatedBy:NSLayoutRelationEqual
                                            toItem:self.contentView
                                            attribute:NSLayoutAttributeLeading
                                            multiplier:1.0
                                            constant:0],
                                           [NSLayoutConstraint
                                            constraintWithItem:button
                                            attribute:NSLayoutAttributeTrailing
                                            relatedBy:NSLayoutRelationEqual
                                            toItem:self.contentView
                                            attribute:NSLayoutAttributeTrailing
                                            multiplier:1.0
                                            constant:0],
                                           [NSLayoutConstraint
                                            constraintWithItem:button
                                            attribute:NSLayoutAttributeTop
                                            relatedBy:NSLayoutRelationEqual
                                            toItem:self.contentView
                                            attribute:NSLayoutAttributeTop
                                            multiplier:1.0
                                            constant:button.top],
                                           [NSLayoutConstraint
                                            constraintWithItem:button
                                            attribute:NSLayoutAttributeHeight
                                            relatedBy:NSLayoutRelationEqual
                                            toItem:nil
                                            attribute:NSLayoutAttributeNotAnAttribute
                                            multiplier:1.0
                                            constant:button.height]
                                           ]
         ];
    }
}

@end
