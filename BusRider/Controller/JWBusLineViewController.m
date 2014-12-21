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
#import "JWSearchRequest.h"

#define kJWButtonHeight 50

@interface JWBusLineViewController()


@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastTimeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation JWBusLineViewController

#pragma mark lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [NSString stringWithFormat:@"%@路", self.busLineItem.lineItem.lineNumber];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reverseDirection)];
    [self setHeaderViews];
    [self setContentViews];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)setHeaderViews {
    JWLineItem *lineItem = self.busLineItem.lineItem;
    self.titleLabel.text = [NSString stringWithFormat:@"%@路(%@-%@)", lineItem.lineNumber, lineItem.from, lineItem.to];
    self.firstTimeLabel.text = lineItem.firstTime;
    self.lastTimeLabel.text = lineItem.lastTime;
}

- (void)setContentViews {
    
    self.contentView.layer.cornerRadius = 4;
    self.contentView.layer.borderWidth = kOnePixel;
    self.contentView.layer.borderColor = HEXCOLOR(0xD7D8D9).CGColor ;
    
    NSInteger count = self.busLineItem? self.busLineItem.stopItems.count : 0;
    self.contentHeightConstraint.constant = count * kJWButtonHeight;
    
    for (int i = 0; i < count; i ++) {
        JWStopItem *stopItem = self.busLineItem.stopItems[i];
        JWStopNameButton *stopButton = [[JWStopNameButton alloc] initWithFrame:CGRectMake(0, i * kJWButtonHeight, self.contentView.width, kJWButtonHeight)];;
        [stopButton setIndex:i + 1 title:stopItem.stopName isLast:i == count - 1];
        [self.contentView addSubview:stopButton];
        
        // add constraints
        [stopButton addConstraint:[NSLayoutConstraint constraintWithItem:stopButton
                                                               attribute:NSLayoutAttributeHeight
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:nil
                                                               attribute:NSLayoutAttributeNotAnAttribute
                                                              multiplier:1.0
                                                                constant:kJWButtonHeight]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:stopButton
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeTop
                                                                    multiplier:1.0
                                                                      constant:kJWButtonHeight * i]
         ];
    }
}

#pragma mark action
- (void)reverseDirection {
    JWSearchRequest *request = [[JWSearchRequest alloc] init];
    request.keyWord = @"123123";
     [request loadWithCompletion:^(NSDictionary *dict, NSError *error) {
         
     }];
}

@end
