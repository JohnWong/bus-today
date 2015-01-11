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
#import "JWLineRequest.h"
#import "JWBusItem.h"
#import "UIScrollView+SVPullToRefresh.h"
#import "JWBusInfoItem.h"
#import "UINavigationController+SGProgress.h"
#import "JWUserDefaultsUtil.h"
#import "JWSwitchChangeButton.h"
#import <NotificationCenter/NotificationCenter.h>
#import "JWViewUtil.h"
#import "JWCollectItem.h"

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
@property (weak, nonatomic) IBOutlet JWSwitchChangeButton *todayButton;

@property (nonatomic, strong) JWLineRequest *lineRequest;
@property (nonatomic, strong) JWStopItem *selectedStopItem;
@property (nonatomic, strong) JWBusInfoItem *busInfoItem;
@property (nonatomic, strong) NSString *lineNumber;
@property (nonatomic, strong) NSString *lineId;

@end

@implementation JWBusLineViewController

#pragma mark lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.contentView.layer.cornerRadius = 4;
    self.contentView.layer.borderWidth = kOnePixel;
    self.contentView.layer.borderColor = HEXCOLOR(0xD7D8D9).CGColor ;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:[JWUserDefaultsUtil collectItemForLineId:self.lineId] ? @"JWIconCollectOn" : @"JWIconCollectOff"] style:UIBarButtonItemStylePlain target:self action:@selector(collect:)];
    self.title = self.lineNumber;
    
    JWCollectItem *collectItem = [JWUserDefaultsUtil collectItemForLineId:self.lineId];
    if (collectItem) {
        JWStopItem *stopItem = [[JWStopItem alloc] init];
        stopItem.stopId = collectItem.stopId;
        stopItem.stopName = collectItem.stopName;
        self.selectedStopItem = stopItem;
    }
    
    /**
     *  If data is given, just update views. Or lineId is given, load request at once.
     */
    if (self.busLineItem) {
        [self updateViews];
    } else {
        [self loadRequest];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    __weak typeof(self) weakSelf = self;
    [self.scrollView addPullToRefreshWithActionHandler:^{
        [weakSelf.scrollView.pullToRefreshView stopAnimating];
        [weakSelf loadRequest];
    }];
    
}

- (void)updateViews {
    JWLineItem *lineItem = self.busLineItem.lineItem;
    self.titleLabel.text = [NSString stringWithFormat:@"%@(%@-%@)", lineItem.lineNumber, lineItem.from, lineItem.to];
    self.firstTimeLabel.text = lineItem.firstTime;
    self.lastTimeLabel.text = lineItem.lastTime;
    
    NSInteger count = self.busLineItem? self.busLineItem.stopItems.count : 0;
    self.contentHeightConstraint.constant = count * kJWButtonHeight;
    
    for (UIView *view in self.contentView.subviews) {
        if (view != self.lineView) {
            [view removeFromSuperview];
        }
    }
    
    NSDictionary *userInfo = [[JWUserDefaultsUtil groupUserDefaults] objectForKey:JWKeyBusLine];
    NSString *todayStopId;
    if (userInfo && [self.lineId isEqualToString:userInfo[@"lineId"]]) {
        todayStopId = userInfo[@"stopId"];
    }
    NSString *focusStopId = todayStopId ? : [JWUserDefaultsUtil collectItemForLineId:self.lineId].stopId;
    for (int i = 0; i < count; i ++) {
        JWStopItem *stopItem = self.busLineItem.stopItems[i];
        JWStopNameButton *stopButton = [[JWStopNameButton alloc] initWithFrame:CGRectMake(0, i * kJWButtonHeight, self.contentView.width, kJWButtonHeight)];;
        [stopButton setIndex:i + 1 title:stopItem.stopName last:i == count - 1 today:todayStopId && [stopItem.stopId isEqualToString:todayStopId]];
        
        stopButton.titleButton.tag = kJWButtonBaseTag + i;
        [stopButton.titleButton addTarget:self action:@selector(didSelectStop:) forControlEvents:UIControlEventTouchUpInside];
        if (self.selectedStopItem && [stopItem.stopId isEqualToString:self.selectedStopItem.stopId]) {
            stopButton.titleButton.selected = YES;
            self.stopLabel.text = [NSString stringWithFormat:@"距%@", stopItem.stopName];
        }
        if (focusStopId && [focusStopId isEqualToString:stopItem.stopId]) {
            // TODO
            self.scrollView.contentOffset =  CGPointMake(0, self.scrollView.contentOffset.y + self.contentView.top);
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
                self.updateLabel.text = self.busInfoItem.pastTime < 0 ? @"上一辆车发出时间不详" : [NSString stringWithFormat:@"上一辆车发出%ld分钟", self.busInfoItem.pastTime];
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
    [self updateTodayButton];
}

- (void)updateTodayButton {
    NSDictionary *userInfo = [[JWUserDefaultsUtil groupUserDefaults] objectForKey:JWKeyBusLine];
    if (userInfo) {
        NSString *lineId = userInfo[@"lineId"];
        NSString *stopId = userInfo[@"stopId"];
        if (lineId && [lineId isEqualToString:self.busLineItem.lineItem.lineId] && stopId && [stopId isEqualToString:self.selectedStopItem.stopId]) {
            self.todayButton.on = YES;
        } else {
            self.todayButton.on = NO;
        }
    } else {
        self.todayButton.on = NO;
    }
}

- (void)didSelectStop:(UIButton *)sender {
    self.selectedStopItem = [((JWStopItem *)self.busLineItem.stopItems[sender.tag - kJWButtonBaseTag]) copy];
    [self updateCollectItem];
    [self loadRequest];
}

- (void)updateCollectItem {
    JWCollectItem *collectItem = [JWUserDefaultsUtil collectItemForLineId:self.lineId];
    if (collectItem) {
        [self saveCollectItem];
    }
}

- (void)saveCollectItem {
    JWCollectItem *collectItem = [[JWCollectItem alloc] initWithLineId:self.lineId lineNumber:self.lineNumber from:self.busLineItem.lineItem.from to:self.busLineItem.lineItem.to stopId:self.selectedStopItem.stopId ? : @"" stopName:self.selectedStopItem.stopName];
    [JWUserDefaultsUtil saveCollectItem:collectItem];
}

#pragma mark getter
- (JWLineRequest *)lineRequest {
    if (!_lineRequest) {
        _lineRequest = [[JWLineRequest alloc] init];
    }
    return _lineRequest;
}

- (NSString *)lineId {
    if (!_lineId) {
        if (self.busLineItem) {
            _lineId = self.busLineItem.lineItem.lineId;
        } else {
            _lineId = self.searchLineItem.lineId;
        }
    }
    return _lineId;
}

- (NSString *)lineNumber {
    if (!_lineNumber) {
        if (self.busLineItem) {
            _lineNumber = self.busLineItem.lineItem.lineNumber;
        } else {
            _lineNumber = self.searchLineItem.lineNumber;
        }
    }
    return _lineNumber;
}

#pragma mark action
- (void)loadRequest {
    __weak typeof(self) weakSelf = self;
    self.lineRequest.lineId = self.lineId;
    [self.lineRequest loadWithCompletion:^(NSDictionary *dict, NSError *error) {
        [weakSelf.navigationController setSGProgressPercentage:100];
        if (error) {
            [JWViewUtil showError:error];
            return;
        } else {
            weakSelf.busLineItem = [[JWBusLineItem alloc] initWithDictionary:dict];
            if (weakSelf.selectedStopItem.stopId) {
                weakSelf.busInfoItem = [[JWBusInfoItem alloc] initWithUserStop:self.selectedStopItem.stopId busInfo:dict];
            }
            [weakSelf updateViews];
        }
    } progress:^(CGFloat percent) {
        [weakSelf.navigationController setSGProgressPercentage:percent andTitle:@"加载中..."];
    }];
}

- (IBAction)revertDirection:(id)sender {
    self.lineId = self.busLineItem.lineItem.otherLineId;
    [self loadRequest];
}

- (void)collect:(id)sender {
    if ([sender isKindOfClass:[UIBarButtonItem class]]) {
        UIBarButtonItem *barButton = (UIBarButtonItem *)sender;
        
        if (self.busLineItem) {
            self.title = self.busLineItem.lineItem.lineNumber;
            [self updateViews];
        } else {
            self.title = self.searchLineItem.lineNumber;
            [self loadRequest];
        }
        
        if ([JWUserDefaultsUtil collectItemForLineId:self.lineId]) {
            [JWUserDefaultsUtil removeCollectItemWithLineId:self.lineId];
            [barButton setImage:[UIImage imageNamed:@"JWIconCollectOff"]];
        } else {
            [self saveCollectItem];
            [barButton setImage:[UIImage imageNamed:@"JWIconCollectOn"]];
        }
    }
}

- (IBAction)sendToToday:(id)sender {
    if (self.busLineItem && self.busLineItem.lineItem && self.busLineItem.lineItem.lineId && self.selectedStopItem.stopId) {
        if (self.todayButton.isOn) {
            [self removeTodayInfo];
        } else {
            [self setTodayInfoWithLineId:self.busLineItem.lineItem.lineId stopId:self.selectedStopItem.stopId];
        }
        [self updateTodayButton];
    } else {
        [JWViewUtil showInfoWithMessage:@"请先点击选择当前站点"];
    }
}

- (IBAction)refresh:(id)sender {
    [self loadRequest];
}

- (NSString *)todayBundleId {
    NSString *mainId = [[NSBundle mainBundle] infoDictionary][(NSString *)kCFBundleIdentifierKey];
    return [mainId stringByAppendingString:@".Today"];
}

- (void)setTodayInfoWithLineId:(NSString *)lineId stopId:(NSString *)stopId {
    [[JWUserDefaultsUtil groupUserDefaults] setObject:@{@"lineId": lineId,
                                 @"stopId": stopId}
                        forKey:JWKeyBusLine];
    [[NCWidgetController widgetController] setHasContent:YES forWidgetWithBundleIdentifier:[self todayBundleId]];
    
}

- (void)removeTodayInfo {
    [[JWUserDefaultsUtil groupUserDefaults] removeObjectForKey:JWKeyBusLine];
    [[NCWidgetController widgetController] setHasContent:NO forWidgetWithBundleIdentifier:[self todayBundleId]];
}

@end
