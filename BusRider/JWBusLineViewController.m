//
//  JWBusLineViewController.m
//  BusRider
//
//  Created by John Wong on 12/12/14.
//  Copyright (c) 2014 John Wong. All rights reserved.
//

#import "JWBusLineViewController.h"

@interface JWBusLineViewController()

@property (weak, nonatomic) IBOutlet UIButton *busStopButton;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (nonatomic, strong) UIScrollView *view;

@end

@implementation JWBusLineViewController

#pragma mark lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    for (int i = 0; i < 5; i ++) {
        UIButton *button = [NSKeyedUnarchiver unarchiveObjectWithData:
                            [NSKeyedArchiver archivedDataWithRootObject:self.busStopButton]];
        button.frame = CGRectMake(0, i * self.busStopButton.height, self.view.width, self.busStopButton.height);
        button.hidden = NO;
        [self.contentView addSubview:button];
    }
    self.view.contentSize = CGSizeMake(self.view.width, self.busStopButton.height * 5);
}

@end
