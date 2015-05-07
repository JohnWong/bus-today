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
- (void)viewDidLoad {
    [super viewDidLoad];
    
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
                                                                        dropHeight:60
                                                                             scale:1
                                                              horizontalRandomness:150
                                                           reverseLoadingAnimation:YES
                                                           internalAnimationFactor:1];
    
    [self loadRequest];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass(self.class)];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.storeHouseRefreshControl scrollViewDidAppear];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass(self.class)];
    [self.navigationController cancelSGProgress];
}

- (void)updateViews {
    [self.tableView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:JWSeguePushLineWithIdStop]) {
        JWBusLineViewController *lineViewController = segue.destinationViewController;
        lineViewController.lineId = self.selectedLineItem.lineId;
        lineViewController.selectedStopId = self.stopItem.stopId;
    }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.lineTypeList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    JWStopLineTypeItem *typeItem = self.lineTypeList[section];
    return typeItem.lineList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JWStopLineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:JWCellIdStopLine forIndexPath:indexPath];
    JWStopLineTypeItem *typeItem = self.lineTypeList[indexPath.section];
    JWStopLineItem *lineItem = typeItem.lineList[indexPath.row];
    NSString *leftStopDesc;
    switch (lineItem.leftStops) {
        case -3:
            leftStopDesc = nil;
            break;
        case -2:
            leftStopDesc = @"暂无数据";
            break;
        case -1:
            leftStopDesc = @"尚未发车";
            break;
        default:
            leftStopDesc = [NSString stringWithFormat:@"%ld站", (long)lineItem.leftStops];
            break;
    }
    [cell setTitle:[NSString stringWithFormat:@"%@", lineItem.lineNumer]
          subTitle:[NSString stringWithFormat:@"%@-%@", lineItem.from, lineItem.to]
       rightDetail:leftStopDesc];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    JWStopLineTypeItem *typeItem = self.lineTypeList[section];
    return [NSString stringWithFormat:@"开往%@", typeItem.nextStop];
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 56;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 32;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JWStopLineTypeItem *typeItem = self.lineTypeList[indexPath.section];
    JWStopLineItem *lineItem = typeItem.lineList[indexPath.row];
    self.selectedLineItem = lineItem;
    [self performSegueWithIdentifier:JWSeguePushLineWithIdStop sender:self];
}

#pragma mark getter
- (JWStopRequest *)stopRequest {
    if (!_stopRequest) {
        _stopRequest = [[JWStopRequest alloc] init];
    }
    return _stopRequest;
}

#pragma mark action
- (void)loadRequest {
    
    __weak typeof(self) weakSelf = self;
    self.stopRequest.stopName = self.stopItem.stopName;
    [self.stopRequest loadWithCompletion:^(NSDictionary *dict, NSError *error) {
        [weakSelf.navigationController setSGProgressPercentage:100];
        [self.storeHouseRefreshControl performSelector:@selector(finishingLoading) withObject:nil afterDelay:0.3 inModes:@[NSRunLoopCommonModes]];
        if (error) {
            
        } else {
            weakSelf.lineTypeList = [JWStopLineTypeItem arrayFromDictionary:dict];
            [weakSelf updateViews];
        }
    } progress:^(CGFloat percent) {
        [weakSelf.navigationController setSGProgressPercentage:percent andTitle:@"加载中..."];
    }];
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.storeHouseRefreshControl scrollViewDidScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self.storeHouseRefreshControl scrollViewDidEndDragging];
}

@end
