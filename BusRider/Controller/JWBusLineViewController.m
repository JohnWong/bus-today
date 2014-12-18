//
//  JWBusLineViewController.m
//  BusRider
//
//  Created by John Wong on 12/12/14.
//  Copyright (c) 2014 John Wong. All rights reserved.
//

#import "JWBusLineViewController.h"
#import "JWStopNameButton.h"
#import "JWStopItem.h"

#define kJWButtonHeight 49

@interface JWBusLineViewController()


@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation JWBusLineViewController

#pragma mark lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [NSString stringWithFormat:@"%@路", self.busLineItem.lineItem.lineNumber];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reverseDirection)];
//    [self setViews];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)setViews {
    NSInteger count = 25;
    self.contentView.height = count * kJWButtonHeight;
//    ((NSLayoutConstraint *)self.contentView.constraints[0]).constant = count * kJWButtonHeight;
    
    for (int i = 0; i < count; i ++) {
        JWStopNameButton *stopButton = [[JWStopNameButton alloc] initWithFrame:CGRectMake(0, i * kJWButtonHeight, self.contentView.width, kJWButtonHeight)];;
        [stopButton setIndex:i + 1 title:@"蒋村公交中心站" isLast:i == count - 1];
        [self.contentView addSubview:stopButton];
    }
}

#pragma mark action
- (void)reverseDirection {
    
}

@end
