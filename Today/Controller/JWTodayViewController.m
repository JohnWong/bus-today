//
//  JWTodayViewController.m
//  Today
//
//  Created by John Wong on 12/3/14.
//  Copyright (c) 2014 John Wong. All rights reserved.
//

#import "JWTodayViewController.h"
#import "STHTTPRequest.h"
#import "JWBusCardView.h"
#import "JWBusInfoItem.h"
#import <NotificationCenter/NotificationCenter.h>
#import "JWLineRequest.h"
#import "JWUserDefaultsUtil.h"


@interface JWTodayViewController () <NCWidgetProviding, NSURLConnectionDataDelegate>
{
    NSInteger _currentIdx;
}

@property (weak, nonatomic) IBOutlet JWBusCardView *busCardView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (nonatomic, strong) JWLineRequest *lineRequest;
@property (nonatomic, strong) JWCollectItem *todayItem;
@property (nonatomic, strong) NSMutableArray<JWCollectItem *> *allCollectItems;

@end


@implementation JWTodayViewController

#pragma mark lifecycle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.extensionContext.widgetLargestAvailableDisplayMode = NCWidgetDisplayModeExpanded;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.allCollectItems.count == 0) {
        _currentIdx = -1;
    } else {
        _currentIdx = 0;
    }
    [self refreshPageIndex];
    [self requestData];
}

- (void)requestData
{
    if (_currentIdx >= 0) {
        JWCollectItem *currentItem = self.allCollectItems[_currentIdx];
        [self requestLineInfoWithItem:currentItem handler:nil];
    }
}
- (void)refreshPageIndex
{
    if (self.allCollectItems.count <= 1) {
        [self.segmentControl setEnabled:NO forSegmentAtIndex:0];
        [self.segmentControl setEnabled:NO forSegmentAtIndex:1];
        return;
    }

    if (_currentIdx == 0) {
        [self.segmentControl setEnabled:NO forSegmentAtIndex:0];
        [self.segmentControl setEnabled:YES forSegmentAtIndex:1];
    } else if (_currentIdx == self.allCollectItems.count - 1) {
        [self.segmentControl setEnabled:YES forSegmentAtIndex:0];
        [self.segmentControl setEnabled:NO forSegmentAtIndex:1];
    }
}

#pragma mark NCWidgetProviding
- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)widgetActiveDisplayModeDidChange:(NCWidgetDisplayMode)activeDisplayMode withMaximumSize:(CGSize)maxSize
{
    if (activeDisplayMode == NCWidgetDisplayModeCompact) {
        self.preferredContentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 110);
    } else {
        self.preferredContentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 152);
    }
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler
{
    [self requestData];
}

- (void)requestLineInfoWithItem:(JWCollectItem *)item handler:(void (^)(NCUpdateResult))completionHandler
{
    [self.busCardView setLoadingView];

    self.lineRequest.lineId = item.lineId; // @"0571-044-0";
    self.lineRequest.targetOrder = item.order;
    __weak typeof(self) weakSelf = self;
    [self.lineRequest loadWithCompletion:^(NSDictionary *dict, NSError *error) {
        if (error) {
            [weakSelf.busCardView setErrorView:error.userInfo[NSLocalizedDescriptionKey] ?: error.domain];
            if (completionHandler) completionHandler(NCUpdateResultNewData);
        } else {
            JWBusInfoItem *busInfoItem = [[JWBusInfoItem alloc] initWithUserStopOrder:item.order busInfo:dict];
            [weakSelf.busCardView setItem:busInfoItem];
            if (completionHandler) completionHandler(NCUpdateResultNewData);
        }
    }];
}

#pragma mark getter
- (JWLineRequest *)lineRequest
{
    if (!_lineRequest) {
        _lineRequest = [[JWLineRequest alloc] init];
    }
    return _lineRequest;
}

- (JWCollectItem *)todayItem
{
    if (_todayItem == nil) {
        _todayItem = [JWUserDefaultsUtil todayBusLine];
    }
    return _todayItem;
}

- (NSMutableArray<JWCollectItem *> *)allCollectItems
{
    if (!_allCollectItems) {
        _allCollectItems = [NSMutableArray array];
        if (self.todayItem) {
            [_allCollectItems addObject:self.todayItem];
        }
        NSArray *array = [[JWUserDefaultsUtil allCollectItems] reverseObjectEnumerator].allObjects;
        if (array) {
            [array enumerateObjectsUsingBlock:^(JWCollectItem *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                if (obj.order > 0 &&
                    (![obj.lineId isEqualToString:self.todayItem.lineId] || obj.order != self.todayItem.order)) {
                    [_allCollectItems addObject:obj];
                }
            }];
        }
    }
    return _allCollectItems;
}

#pragma mark action
- (IBAction)pageChanged:(id)sender
{
    if (self.segmentControl.selectedSegmentIndex == 0) {
        if (_currentIdx <= 0) {
            return;
        }
        _currentIdx--;
    } else if (self.segmentControl.selectedSegmentIndex == 1) {
        if (_currentIdx >= self.allCollectItems.count - 1) {
            return;
        }
        _currentIdx++;
    }
    [self refreshPageIndex];
    [self refreshData:nil];
}
- (IBAction)refreshData:(id)sender
{
    [self requestData];
}

- (IBAction)goSettings:(id)sender
{
    NSString *params = @"";
    if (_currentIdx >= 0) {
        JWCollectItem *item = self.allCollectItems[_currentIdx];
        params = [NSString stringWithFormat:@"?lineId=%@", item.lineId];
    }

    [self.extensionContext openURL:[NSURL URLWithString:[NSString stringWithFormat:@"jwapp://busrider%@", params]]
                 completionHandler:^(BOOL success) {
                     NSLog(@"open url result:%d", success);
                 }];
}

@end
