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
#import "UIScrollView+SVPullToRefresh.h"
#import "JWViewUtil.h"
#import "JWStopLineTypeItem.h"
#import "JWStopLineItem.h"

@interface JWStopTableViewController ()

@property (nonatomic, strong) JWStopRequest *stopRequest;
/**
 *  array of JWStopLineTypeItem
 */
@property (nonatomic, strong) NSArray *lineTypeList;

@end

@implementation JWStopTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.title = self.stopItem.stopName;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self loadRequest];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    __weak typeof(self) weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf.tableView.pullToRefreshView stopAnimating];
        [weakSelf loadRequest];
    }];
    
}

- (void)updateViews {
    [self.tableView reloadData];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JWStopLineCell" forIndexPath:indexPath];
    JWStopLineTypeItem *typeItem = self.lineTypeList[indexPath.section];
    JWStopLineItem *lineItem = typeItem.lineList[indexPath.row];
    NSString *leftStopDesc;
    switch (lineItem.leftStops) {
        case -2:
            leftStopDesc = @"--";
            break;
        case -1:
            leftStopDesc = @"尚未发车";
            break;
        default:
            leftStopDesc = [NSString stringWithFormat:@"%ld站", lineItem.leftStops];
            break;
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@ | %@", lineItem.lineNumer, leftStopDesc];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@-%@", lineItem.from, lineItem.to];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    JWStopLineTypeItem *typeItem = self.lineTypeList[section];
    return [NSString stringWithFormat:@"开往%@", typeItem.nextStop];
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
        if (error) {
            
        } else {
            self.lineTypeList = [JWStopLineTypeItem arrayFromDictionary:dict];
            [weakSelf updateViews];
        }
    } progress:^(CGFloat percent) {
        [weakSelf.navigationController setSGProgressPercentage:percent andTitle:@"加载中..."];
    }];
}

@end
