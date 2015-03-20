//
//  JWTodayViewController.m
//  Today
//
//  Created by John Wong on 12/3/14.
//  Copyright (c) 2014 John Wong. All rights reserved.
//

#import "JWTodayViewController.h"
#import "JWBusCardView.h"
#import "JWBusInfoItem.h"
#import <NotificationCenter/NotificationCenter.h>
#import "JWBusRequest.h"
#import "JWUserDefaultsUtil.h"

@interface JWTodayViewController () <NCWidgetProviding, NSURLConnectionDataDelegate>

@property (weak, nonatomic) IBOutlet JWBusCardView *busCardView;
@property (nonatomic, strong) JWBusRequest *busRequest;
@property (nonatomic, strong) NSString *lineId;
@property (nonatomic, assign) NSInteger stopOrder;

@end

@implementation JWTodayViewController

#pragma mark lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestLineInfo:nil];
}


#pragma mark NCWidgetProviding
- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    [self requestLineInfo:completionHandler];
}

- (void)requestLineInfo:(void (^)(NCUpdateResult))completionHandler {
    [self.busCardView setLoadingView];
    
    self.busRequest.lineId = self.lineId; // @"0571-044-0";
    __weak typeof(self) weakSelf = self;
    [self.busRequest loadWithCompletion:^(NSDictionary *dict, NSError *error) {
        if (error) {
            [weakSelf.busCardView setErrorView:error.userInfo[NSLocalizedDescriptionKey]?:error.domain];
            if (completionHandler) completionHandler(NCUpdateResultNewData);
        } else {
            JWBusInfoItem *busInfoItem = [[JWBusInfoItem alloc] initWithUserStopOrder:self.stopOrder busInfo:dict];
            [weakSelf.busCardView setItem:busInfoItem];
            if (completionHandler) completionHandler(NCUpdateResultNewData);
        }
    }];
}

#pragma mark getter
- (JWBusRequest *)busRequest {
    if (!_busRequest) {
        _busRequest = [[JWBusRequest alloc] init];
    }
    return _busRequest;
}

- (NSString *)lineId {
    if (!_lineId) {
        JWCollectItem *todayItem = [JWUserDefaultsUtil todayBusLine];
        NSLog(@"TodayItem: %@, %@, %@", todayItem.lineId, @(todayItem.order), todayItem.stopName);
        if (todayItem) {
            _lineId = todayItem.lineId;
        }
    }
    return _lineId;
}

- (NSInteger)stopOrder {
    if (_stopOrder <= 0) {
        JWCollectItem *todayItem = [JWUserDefaultsUtil todayBusLine];
        _stopOrder = todayItem.order;
    }
    return _stopOrder;
}

#pragma mark action
- (IBAction)refreshData:(id)sender {
    [self requestLineInfo:nil];
}

- (IBAction)goSettings:(id)sender {
    [self.extensionContext openURL:[NSURL URLWithString:@"jwapp://busrider"]
                 completionHandler:^(BOOL success) {
                     NSLog(@"open url result:%d",success);
                 }];
}

@end
