//
//  JWStopTableViewController.m
//  BusRider
//
//  Created by John Wong on 1/13/15.
//  Copyright (c) 2015 John Wong. All rights reserved.
//

#import "JWStopTableViewController.h"
#import "JWStopRequest.h"
#import "UINavigationController+SGProgress.h"
#import "JWViewUtil.h"
#import "JWStopLineTypeItem.h"
#import "JWStopLineItem.h"
#import "JWStopLineTableViewCell.h"
#import "JWBusLineViewController.h"
#import "CBStoreHouseRefreshControl.h"
#import "JWUserDefaultsUtil.h"

#define JWCellIdStopLine @"JWCellIdStopLine"


@interface JWStopTableViewController ()

@property (nonatomic, strong) JWStopRequest *stopRequest;
/**
 *  array of JWStopLineTypeItem
 */
@property (nonatomic, strong) NSArray *lineTypeList;
@property (nonatomic, strong) JWStopLineItem *selectedLineItem;
@property (nonatomic, strong) CBStoreHouseRefreshControl *storeHouseRefreshControl;

@end


@implementation JWStopTableViewController

#pragma mark life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:[JWUserDefaultsUtil collectItemForStopId:self.stopItem.stopId] ? @"已收藏" : @"收藏" style:UIBarButtonItemStylePlain target:self action:@selector(collect:)];

    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.title = self.stopItem.stopName;

    [self.tableView registerNib:[UINib nibWithNibName:@"JWStopLineTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:JWCellIdStopLine];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.storeHouseRefreshControl = [CBStoreHouseRefreshControl attachToScrollView:self.tableView
                                                                            target:self
                                                                     refreshAction:@selector(loadRequest)
                                                                             plist:@"bus"
                                                                             color:HEXCOLOR(0x007AFF)
                                                                         lineWidth:1
                                                                        dropHeight:90
                                                                             scale:1
                                                              horizontalRandomness:150
                                                           reverseLoadingAnimation:YES
                                                           internalAnimationFactor:1];

    [self loadRequest];
}

- (void)collect:(id)sender
{
    if ([sender isKindOfClass:[UIBarButtonItem class]]) {
        UIBarButtonItem *barButton = (UIBarButtonItem *)sender;

        if ([JWUserDefaultsUtil collectItemForStopId:self.stopItem.stopId]) {
            [JWUserDefaultsUtil removeCollectItemWithStopId:self.stopItem.stopId];
            barButton.title = @"收藏";
        } else {
            [self saveCollectItem];
            barButton.title = @"已收藏";
        }
    }
}

- (void)saveCollectItem
{
    JWCollectItem *collectItem = [[JWCollectItem alloc] initWithStopId:self.stopItem.stopId stopName:self.stopItem.stopName];
    [JWUserDefaultsUtil addCollectItem:collectItem];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.storeHouseRefreshControl scrollViewDidAppear];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController cancelSGProgress];
}

- (void)updateViews
{
    [self.tableView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:JWSeguePushLineWithIdStop]) {
        JWBusLineViewController *lineViewController = segue.destinationViewController;
        lineViewController.lineId = self.selectedLineItem.lineId;
        lineViewController.lineNumber = self.selectedLineItem.lineNumer;
        lineViewController.selectedStopId = self.stopItem.stopId;
    }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.lineTypeList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    JWStopLineTypeItem *typeItem = self.lineTypeList[section];
    return typeItem.lineList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JWStopLineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:JWCellIdStopLine forIndexPath:indexPath];
    JWStopLineTypeItem *typeItem = self.lineTypeList[indexPath.section];
    JWStopLineItem *lineItem = typeItem.lineList[indexPath.row];
    [cell setTitle:[NSString stringWithFormat:@"%@", lineItem.lineNumer]
           subTitle:[NSString stringWithFormat:@"%@-%@", lineItem.from, lineItem.to]
        rightDetail:lineItem.desc];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    JWStopLineTypeItem *typeItem = self.lineTypeList[section];
    return typeItem.nextStop;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 32;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JWStopLineTypeItem *typeItem = self.lineTypeList[indexPath.section];
    JWStopLineItem *lineItem = typeItem.lineList[indexPath.row];
    self.selectedLineItem = lineItem;
    [self performSegueWithIdentifier:JWSeguePushLineWithIdStop sender:self];
}

#pragma mark getter
- (JWStopRequest *)stopRequest
{
    if (!_stopRequest) {
        _stopRequest = [[JWStopRequest alloc] init];
    }
    return _stopRequest;
}

#pragma mark action
- (void)loadRequest
{
    __weak typeof(self) weakSelf = self;
    self.stopRequest.stationId = self.stopItem.stopId;
    [self.stopRequest loadWithCompletion:^(NSDictionary *dict, NSError *error) {
        if (error) {
            [JWViewUtil showError:error];
        }
        [weakSelf.navigationController setSGProgressPercentage:100];
        [self.storeHouseRefreshControl performSelector:@selector(finishingLoading) withObject:nil afterDelay:0.3 inModes:@[ NSRunLoopCommonModes ]];
        if (error) {
        } else {
            weakSelf.lineTypeList = [JWStopLineTypeItem arrayFromDictionary:dict];
            [weakSelf updateViews];
        }
    } progress:nil];
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.storeHouseRefreshControl scrollViewDidScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.storeHouseRefreshControl scrollViewDidEndDragging];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //    [self.storeHouseRefreshControl scrollViewDidEndDecelerating];
}

@end
