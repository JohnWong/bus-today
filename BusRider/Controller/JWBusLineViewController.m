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
#import "JWLineRequest.h"
#import "JWBusItem.h"
#import "UIScrollView+SVPullToRefresh.h"

#define kJWButtonHeight 50

@interface JWBusLineViewController()


@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastTimeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (nonatomic, strong) JWLineRequest *lineRequest;

@end

@implementation JWBusLineViewController

#pragma mark lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.contentView.layer.cornerRadius = 4;
    self.contentView.layer.borderWidth = kOnePixel;
    self.contentView.layer.borderColor = HEXCOLOR(0xD7D8D9).CGColor ;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reverseDirection)];
    
    [self updateView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.scrollView addPullToRefreshWithActionHandler:^{
        [self.scrollView.pullToRefreshView startAnimating];
        [self loadRequest];
    }];
    
}

- (void)updateView {
    self.title = [NSString stringWithFormat:@"%@路", self.busLineItem.lineItem.lineNumber];
    
    JWLineItem *lineItem = self.busLineItem.lineItem;
    self.titleLabel.text = [NSString stringWithFormat:@"%@路(%@-%@)", lineItem.lineNumber, lineItem.from, lineItem.to];
    self.firstTimeLabel.text = lineItem.firstTime;
    self.lastTimeLabel.text = lineItem.lastTime;

    NSInteger count = self.busLineItem? self.busLineItem.stopItems.count : 0;
    self.contentHeightConstraint.constant = count * kJWButtonHeight;
    
    for (UIView *view in self.contentView.subviews) {
        if (view != self.lineView) {
            [view removeFromSuperview];
        }
    }
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
    
    for (JWBusItem *busItem in self.busLineItem.busItems) {
        UIImage *image = [UIImage imageNamed:@"JWIconBus"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.origin = CGPointMake(20 - image.size.width / 2, (busItem.order - 1) * kJWButtonHeight - image.size.height / 2);
        [self.contentView addSubview:imageView];
        NSLog(@"%ld", busItem.order);
    }
}

#pragma mark getter
- (JWLineRequest *)lineRequest {
    if (!_lineRequest) {
        _lineRequest = [[JWLineRequest alloc] init];
        _lineRequest.lineId = self.busLineItem.lineItem.lineId;
    }
    return _lineRequest;
}

#pragma mark action
- (void)reverseDirection {
    self.lineRequest.lineId = self.busLineItem.lineItem.otherLineId;
    [self loadRequest];
}

- (void)loadRequest {
    [self.lineRequest loadWithCompletion:^(NSDictionary *dict, NSError *error) {
        [self.scrollView.pullToRefreshView stopAnimating];
        if (error) {
            // TODO
            return;
        } else {
            self.busLineItem = [[JWBusLineItem alloc] initWithDictionary:dict];
            [self updateView];
        }
    }];
}

@end
