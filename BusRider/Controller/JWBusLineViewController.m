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
#import "JWBusInfoItem.h"

#define kJWButtonHeight 50
#define kJWButtonBaseTag 2000

@interface JWBusLineViewController()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastTimeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *lineView;

// Bottom bar
@property (weak, nonatomic) IBOutlet UILabel *stopLabel;
@property (weak, nonatomic) IBOutlet UILabel *mainLabel;
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;
@property (weak, nonatomic) IBOutlet UILabel *updateLabel;

@property (nonatomic, strong) JWLineRequest *lineRequest;
@property (nonatomic, strong) NSString *selectedStopId;
@property (nonatomic, strong) JWBusInfoItem *busInfoItem;

@end

@implementation JWBusLineViewController

#pragma mark lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.contentView.layer.cornerRadius = 4;
    self.contentView.layer.borderWidth = kOnePixel;
    self.contentView.layer.borderColor = HEXCOLOR(0xD7D8D9).CGColor ;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:nil];
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    
//    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
//    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Please Wait..."]; //to give the attributedTitle
//    [refreshControl addTarget:self action:@selector(refreshControl:) forControlEvents:UIControlEventValueChanged];
//    [self.scrollView addSubview:refreshControl];
    
    [self updateViews];
}

- (void)refreshControl:(UIRefreshControl *)refreshControl
{
    [refreshControl endRefreshing];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    __weak typeof(self) weakSelf = self;
    [self.scrollView addPullToRefreshWithActionHandler:^{
        [weakSelf.scrollView.pullToRefreshView startAnimating];
        [weakSelf loadRequest];
    }];
    
}

- (void)updateViews {
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
    
    JWStopItem *selectedItem = nil;
    for (int i = 0; i < count; i ++) {
        JWStopItem *stopItem = self.busLineItem.stopItems[i];
        JWStopNameButton *stopButton = [[JWStopNameButton alloc] initWithFrame:CGRectMake(0, i * kJWButtonHeight, self.contentView.width, kJWButtonHeight)];;
        [stopButton setIndex:i + 1 title:stopItem.stopName isLast:i == count - 1];
        
        stopButton.titleButton.tag = kJWButtonBaseTag + i;
        [stopButton.titleButton addTarget:self action:@selector(didSelectStop:) forControlEvents:UIControlEventTouchUpInside];
        if ([stopItem.stopId isEqualToString:self.self.selectedStopId]) {
            selectedItem = stopItem;
            stopButton.titleButton.selected = YES;
            self.stopLabel.text = [NSString stringWithFormat:@"距%@", stopItem.stopName];
        }
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
    }
    
    [self updateBusInfo];
}

- (void)updateBusInfo {
    
    if (self.busInfoItem) {
        self.stopLabel.text = [NSString stringWithFormat:@"距%@", self.busInfoItem.currentStop];
        
        switch (self.busInfoItem.state) {
            case JWBusStateNotStarted:
                self.mainLabel.text = @"--";
                self.unitLabel.text = @"";
                self.updateLabel.text = [NSString stringWithFormat:@"上一辆车发出%ld分钟", self.busInfoItem.pastTime];
                break;
            case JWBusStateNotFound:
                self.mainLabel.text = @"--";
                self.unitLabel.text = @"";
                self.updateLabel.text = self.busInfoItem.noBusTip;
                break;
            case JWBusStateNear:
                if (self.busInfoItem.distance < 1000) {
                    self.mainLabel.text = [NSString stringWithFormat:@"%ld", self.busInfoItem.distance];
                    self.unitLabel.text = @"米";
                } else {
                    self.mainLabel.text = [NSString stringWithFormat:@"%.1f", self.busInfoItem.distance / 1000.0];
                    self.unitLabel.text = @"千米";
                }
                self.updateLabel.text = [NSString stringWithFormat:@"%ld%@前报告位置", self.busInfoItem.updateTime / (self.busInfoItem.updateTime < 60 ? 1 : 60), self.busInfoItem.updateTime < 60 ? @"秒" : @"分"];
                break;
            case JWBusStateFar:
                self.mainLabel.text = [NSString stringWithFormat:@"%ld", self.busInfoItem.remains];
                self.unitLabel.text = @"站";
                self.updateLabel.text = [NSString stringWithFormat:@"%ld%@前报告位置", self.busInfoItem.updateTime / (self.busInfoItem.updateTime < 60 ? 1 : 60), self.busInfoItem.updateTime < 60 ? @"秒" : @"分"];
                break;
        }
    } else {
        self.stopLabel.text = @"--";
        self.mainLabel.text = @"--";
        self.unitLabel.text = @"";
        self.updateLabel.text = @"未选择当前站点";

    }
}

- (void)didSelectStop:(UIButton *)sender {
    self.selectedStopId = ((JWStopItem *)self.busLineItem.stopItems[sender.tag - kJWButtonBaseTag]).stopId;
    [self loadRequest];
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
- (void)loadRequest {
    [self.lineRequest loadWithCompletion:^(NSDictionary *dict, NSError *error) {
//        [self.scrollView.pullToRefreshView stopAnimating];
        if (error) {
            // TODO
            return;
        } else {
            self.busLineItem = [[JWBusLineItem alloc] initWithDictionary:dict];
            if (self.selectedStopId) {
                self.busInfoItem = [[JWBusInfoItem alloc] initWithUserStop:self.selectedStopId busInfo:dict];
            }
            [self updateViews];
        }
    }];
}

- (IBAction)collect:(id)sender {
    
}

- (IBAction)revertDirection:(id)sender {
    self.lineRequest.lineId = self.busLineItem.lineItem.otherLineId;
    [self loadRequest];
}

- (IBAction)refresh:(id)sender {
    [self.scrollView triggerPullToRefresh];
}

@end
