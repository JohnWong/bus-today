//
//  JWBusLineViewController.m
//  BusRider
//
//  Created by John Wong on 12/12/14.
//  Copyright (c) 2014 John Wong. All rights reserved.
//

#import "JWBusLineViewController.h"
#import "JWStopNameButton.h"
#import "JWLineRequest.h"
#import "JWBusItem.h"
#import "UIScrollView+SVPullToRefresh.h"
#import "UINavigationController+SGProgress.h"
#import "JWUserDefaultsUtil.h"
#import "JWSwitchChangeButton.h"
#import <NotificationCenter/NotificationCenter.h>
#import "JWViewUtil.h"
#import "JWCollectItem.h"
#import "JWFormatter.h"
#import "JWNavigationCenterView.h"
#import "AHKActionSheet.h"
#import "JWStopTableViewController.h"

#define kJWButtonHeight 50
#define kJWButtonBaseTag 2000

@interface JWBusLineViewController() <JWNavigationCenterDelegate>

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

@property (nonatomic, strong) JWNavigationCenterView *stopButtonItem;
@property (nonatomic, strong) JWLineRequest *lineRequest;
/**
 *  Pass to JWBusLineViewController
 */
@property (nonatomic, strong) JWSearchStopItem *selectedStopItem;

@end

@implementation JWBusLineViewController

#pragma mark lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.contentView.layer.cornerRadius = 4;
    self.contentView.layer.borderWidth = kOnePixel;
    self.contentView.layer.borderColor = HEXCOLOR(0xD7D8D9).CGColor ;
    
    JWCollectItem *collectItem = [JWUserDefaultsUtil collectItemForLineId:self.lineId];
    if (collectItem && collectItem.order && collectItem.stopName) {
        JWStopItem *stopItem = [[JWStopItem alloc] initWithOrder:collectItem.order stopName:collectItem.stopName];
        self.selectedStopOrder = stopItem.order;
    }
    self.navigationItem.titleView = self.stopButtonItem;
    
    /**
     *  If data is given, just update views. Or lineId is given, load request at once. To set view correctly, updateViews is called in viewDidAppear.
     */
    if (!self.busLineItem) {
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
    if (self.busLineItem) {
        [self updateViews];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController cancelSGProgress];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:JWSeguePushStop]) {
        JWStopTableViewController *stopViewController = segue.destinationViewController;
        stopViewController.stopItem = self.selectedStopItem;
    }
}

- (void)updateViews {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:[JWUserDefaultsUtil collectItemForLineId:self.lineId] ? @"JWIconCollectOn" : @"JWIconCollectOff"] style:UIBarButtonItemStylePlain target:self action:@selector(collect:)];
    
    JWLineItem *lineItem = self.busLineItem.lineItem;
    [self.stopButtonItem setTitle:lineItem.lineNumber];
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
    
    JWCollectItem *todayItem = [JWUserDefaultsUtil todayBusLine];
    NSInteger todayStopOrder = 0;
    if (todayItem && [self.lineId isEqualToString:todayItem.lineId]) {
        todayStopOrder = todayItem.order;
    }
    NSInteger focusStopOrder = self.selectedStopOrder ? : todayStopOrder;
    for (int i = 0; i < count; i ++) {
        JWStopItem *stopItem = self.busLineItem.stopItems[i];
        JWStopNameButton *stopButton = [[JWStopNameButton alloc] initWithFrame:CGRectMake(0, i * kJWButtonHeight, self.contentView.width, kJWButtonHeight)];;
        BOOL isSelected = self.selectedStopOrder && stopItem.order == self.selectedStopOrder;
        [stopButton setIndex:i + 1 title:stopItem.stopName last:i == count - 1 today:todayStopOrder && stopItem.order == todayStopOrder selected:isSelected];
        
        stopButton.titleButton.tag = kJWButtonBaseTag + i;
        [stopButton.titleButton addTarget:self action:@selector(didSelectStop:) forControlEvents:UIControlEventTouchUpInside];
        if (isSelected) {
            self.stopLabel.text = [NSString stringWithFormat:@"距%@", stopItem.stopName];
        }
        if (focusStopOrder && focusStopOrder == stopItem.order) {
            NSInteger scrollTo = self.contentView.top + stopButton.bottom - (self.view.height - 132);
            if (scrollTo < - self.scrollView.contentInset.top) {
                scrollTo = - self.scrollView.contentInset.top;
            }
            [UIView animateWithDuration:0.25 + 0.002 * scrollTo animations:^{
                self.scrollView.contentOffset =  CGPointMake(0, scrollTo);
            }];
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
                self.updateLabel.text = self.busInfoItem.pastTime < 0 ? @"上一辆车发出时间不详" : [NSString stringWithFormat:@"上一辆车发出%ld分钟", (long)self.busInfoItem.pastTime];
                break;
            case JWBusStateNotFound:
                self.mainLabel.text = @"--";
                self.unitLabel.text = @"";
                self.updateLabel.text = self.busInfoItem.noBusTip;
                break;
            case JWBusStateNear:
                if (self.busInfoItem.distance < 1000) {
                    self.mainLabel.text = [NSString stringWithFormat:@"%ld", (long)self.busInfoItem.distance];
                    self.unitLabel.text = @"米";
                } else {
                    self.mainLabel.text = [NSString stringWithFormat:@"%.1f", self.busInfoItem.distance / 1000.0];
                    self.unitLabel.text = @"千米";
                }
                self.updateLabel.text = [NSString stringWithFormat:@"%@前报告位置", [JWFormatter formatedTime:self.busInfoItem.updateTime]];
                break;
            case JWBusStateFar:
                self.mainLabel.text = [NSString stringWithFormat:@"%ld", (long)self.busInfoItem.remains];
                self.unitLabel.text = @"站";
                self.updateLabel.text = [NSString stringWithFormat:@"%@前报告位置", [JWFormatter formatedTime:self.busInfoItem.updateTime]];
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
    JWCollectItem *todayItem = [JWUserDefaultsUtil todayBusLine];
    if (todayItem) {
        NSString *lineId = todayItem.lineId;
        NSInteger stopOrder = todayItem.order;
        if (lineId && [lineId isEqualToString:self.busLineItem.lineItem.lineId] && stopOrder && stopOrder == self.selectedStopOrder) {
            self.todayButton.on = YES;
            return;
        }
    }
    self.todayButton.on = NO;
}

- (void)didSelectStop:(UIButton *)sender {
    JWStopItem *stopItem = self.busLineItem.stopItems[sender.tag - kJWButtonBaseTag];
    self.selectedStopOrder = stopItem.order;
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
    NSString *stopName;
    for (JWStopItem *stopItem in self.busLineItem.stopItems) {
        if (stopItem.order == self.selectedStopOrder) {
            stopName = stopItem.stopName;
            break;
        }
    }
    JWCollectItem *collectItem = [[JWCollectItem alloc] initWithLineId:self.lineId lineNumber:self.busLineItem.lineItem.lineNumber from:self.busLineItem.lineItem.from to:self.busLineItem.lineItem.to stopName:stopName order:self.selectedStopOrder];
    [JWUserDefaultsUtil addCollectItem:collectItem];
}

#pragma mark getter
- (JWLineRequest *)lineRequest {
    if (!_lineRequest) {
        _lineRequest = [[JWLineRequest alloc] init];
    }
    return _lineRequest;
}

- (NSString *)lineId {
    if (!_lineId && self.busLineItem) {
        _lineId = self.busLineItem.lineItem.lineId;
    }
    return _lineId;
}

- (JWNavigationCenterView *)stopButtonItem {
    if (!_stopButtonItem) {
        _stopButtonItem = [[JWNavigationCenterView alloc] initWithTitle:nil];
        _stopButtonItem.delegate = self;
    }
    return _stopButtonItem;
}

#pragma mark JWNavigationCenterDelegate
- (void)buttonItem:(JWNavigationCenterView *)buttonItem setOn:(BOOL)isOn {
    if (isOn) {
        AHKActionSheet *actionSheet = [[AHKActionSheet alloc] initWithTitle:@"选择站点"];
        actionSheet.cancelButtonTitle = @"取消";
        actionSheet.buttonHeight = 44;
        __weak typeof(self) weakSelf = self;
        actionSheet.cancelHandler = ^(AHKActionSheet *actionSheet) {
            [weakSelf.stopButtonItem setOn:NO];
        };
        for (JWStopItem *stopItem in self.busLineItem.stopItems) {
            __weak typeof(self) weakSelf = self;
            [actionSheet addButtonWithTitle:stopItem.stopName image:[UIImage imageNamed:@"JWIconBusThin"] type:AHKActionSheetButtonTypeDefault handler:^(AHKActionSheet *actionSheet) {
                [weakSelf.stopButtonItem setOn:NO];
                JWSearchStopItem *searchStopItem = [[JWSearchStopItem alloc] init];
                searchStopItem.stopName = stopItem.stopName;
                searchStopItem.order = stopItem.order;
                weakSelf.selectedStopItem = searchStopItem;
                [weakSelf performSegueWithIdentifier:JWSeguePushStop sender:weakSelf];
            }];
        }
        [actionSheet show];
    }
}

#pragma mark action
- (void)loadRequest {
    __weak typeof(self) weakSelf = self;
    self.lineRequest.lineId = self.lineId;
    [self.lineRequest loadWithCompletion:^(NSDictionary *dict, NSError *error) {
        [weakSelf.navigationController setSGProgressPercentage:100];
        if (error) {
            
        } else {
            weakSelf.busLineItem = [[JWBusLineItem alloc] initWithDictionary:dict];
            if (weakSelf.selectedStopOrder) {
                weakSelf.busInfoItem = [[JWBusInfoItem alloc] initWithUserStopOrder:weakSelf.selectedStopOrder busInfo:dict];
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
    if (self.busLineItem && self.busLineItem.lineItem && self.busLineItem.lineItem.lineId && self.selectedStopOrder) {
        if (self.todayButton.isOn) {
            [self removeTodayInfo];
        } else {
            [self setTodayInfoWithLineId:self.busLineItem.lineItem.lineId lineNumber:self.busLineItem.lineItem.lineNumber stopOrder:self.selectedStopOrder];
        }
        [self updateViews];
    } else {
        [JWViewUtil showInfoWithMessage:@"请先点击选择当前站点"];
    }
}

- (IBAction)refresh:(id)sender {
    [self loadRequest];
}

- (void)setTodayInfoWithLineId:(NSString *)lineId lineNumber:(NSString *)lineNumber stopOrder:(NSInteger)order {
    JWCollectItem *todayItem = [[JWCollectItem alloc] initWithLineId:lineId lineNumber:lineNumber from:nil to:nil stopName:nil order:self.selectedStopOrder];
    [JWUserDefaultsUtil setTodayBusLine:todayItem];
}

- (void)removeTodayInfo {
    [JWUserDefaultsUtil removeTodayBusLine];
}

@end
