//
//  JWMainViewController.m
//  BusRider
//
//  Created by John Wong on 12/15/14.
//  Copyright (c) 2014 John Wong. All rights reserved.
//

#import "JWMainViewController.h"
#import "JWSearchRequest.h"
#import "JWBusLineItem.h"
#import "JWBusLineViewController.h"
#import "JWViewUtil.h"
#import "JWSearchListItem.h"
#import "JWSearchLineItem.h"
#import "JWSearchStopItem.h"
#import "JWSearchTableViewCell.h"
#import "JWUserDefaultsUtil.h"
#import "SVPullToRefresh.h"
#import "UINavigationController+SGProgress.h"
#import "JWMainTableViewCell.h"
#import "JWStopTableViewController.h"

#define JWCellIdMain                @"JWCellIdMain"
#define JWCellIdSearch              @"JWCellIdSearch"
#define JWSeguePushLineWithData     @"JWSeguePushLineWithData"
#define JWSeguePushLineWithId       @"JWSeguePushLineWithId"
#define JWSeguePushStopList         @"JWSeguePushStopList"

typedef NS_ENUM(NSInteger, JWSearchResultType) {
    JWSearchResultTypeNone = 0,
    JWSearchResultTypeList = 1,
    JWSearchResultTypeSingle = 2
};

@interface JWMainViewController () <UISearchBarDelegate, UITableViewDataSource>

@property (nonatomic, strong) JWSearchRequest *searchRequest;
@property (nonatomic, strong) JWSearchListItem *searchListItem;
/**
 *  array of JWSearchLineItem
 */
@property (nonatomic, strong) NSArray *collectLineItem;

@property (strong, nonatomic) IBOutlet UISearchDisplayController *searchController;

/**
 *  Pass to JWBusLineViewController
 */
@property (nonatomic, strong) JWBusLineItem *busLineItem;
/**
 *  Pass to JWBusLineViewController
 */
@property (nonatomic, strong) JWSearchLineItem *selectedLine;
/**
 *  Pass to JWStopViewController
 */
@property (nonatomic, strong) JWSearchStopItem *selectedStop;

@end

@implementation JWMainViewController

#pragma mark lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.searchController.searchResultsTableView registerNib:[UINib nibWithNibName:@"JWSearchTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:JWCellIdSearch];
    [self.tableView registerNib:[UINib nibWithNibName:@"JWMainTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:JWCellIdMain];
    self.tableView.tableFooterView = [[UIView alloc] init];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self loadData];
    __weak typeof(self) weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf loadData];
        [weakSelf.tableView.pullToRefreshView stopAnimating];
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:JWSeguePushLineWithData]) {
        if ([segue.destinationViewController isKindOfClass:[JWBusLineViewController class]]) {
            JWBusLineViewController *busLineViewController = (JWBusLineViewController *)segue.destinationViewController;
            busLineViewController.busLineItem = self.busLineItem;            
        }
    } else if ([segue.identifier isEqualToString:JWSeguePushLineWithId]) {
        if ([segue.destinationViewController isKindOfClass:[JWBusLineViewController class]]) {
            JWBusLineViewController *busLineViewController = (JWBusLineViewController *)segue.destinationViewController;
            busLineViewController.searchLineItem = self.selectedLine;
        }
    } else if ([segue.identifier isEqualToString:JWSeguePushStopList]) {
        if ([segue.destinationViewController isKindOfClass:[JWStopTableViewController class]]) {
            JWStopTableViewController *stopTableViewController = (JWStopTableViewController *)segue.destinationViewController;
            stopTableViewController.stopItem = self.selectedStop;
        }
    }
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        return self.collectLineItem ? self.collectLineItem.count : 0;
    } else {
        if (self.searchListItem) {
            if (section == 0 && self.searchListItem.lineList.count > 0) {
                return self.searchListItem.lineList.count;
            } else {
                return self.searchListItem.stopList.count;
            }
        } else {
            return 0;
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.tableView) {
        return 1;
    } else {
        if (self.searchListItem) {
            return (self.searchListItem.lineList.count == 0 ? 0 : 1) + (self.searchListItem.stopList.count == 0 ? 0 : 1);
        } else {
            return 0;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tableView) {
        JWMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:JWCellIdMain forIndexPath:indexPath];
        JWCollectItem *item = self.collectLineItem[indexPath.row];
        cell.titleLabel.text = item.lineNumber;
        cell.subTitle.text = [NSString stringWithFormat:@"%@-%@", item.from, item.to];
        return cell;
    } else {
        JWSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:JWCellIdSearch forIndexPath:indexPath];
        if (indexPath.section == 0 && self.searchListItem.lineList.count > 0) {
            JWSearchLineItem *lineItem = self.searchListItem.lineList[indexPath.row];
            cell.titleLabel.text = lineItem.lineNumber;
        } else {
            JWSearchStopItem *stopItem = self.searchListItem.stopList[indexPath.row];
            cell.titleLabel.text = stopItem.stopName;
        }
        return cell;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        
    } else {
        if (section == 0 && self.searchListItem.lineList.count > 0) {
            return @"公交路线";
        } else {
            return @"公交站点";
        }
    }
    return nil;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tableView) {
        return 54;
    } else {
        return 44;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tableView) {
        JWCollectItem *item = self.collectLineItem[indexPath.row];
        self.selectedLine = [[JWSearchLineItem alloc] init];
        self.selectedLine.lineId = item.lineId;
        self.selectedLine.lineNumber = item.lineNumber;
        [self performSegueWithIdentifier:JWSeguePushLineWithId sender:self];
    } else {
        if (indexPath.section == 0 && self.searchListItem.lineList.count > 0) {
            self.selectedLine = self.searchListItem.lineList[indexPath.row];
            [self performSegueWithIdentifier:JWSeguePushLineWithId sender:self];
        } else {
            self.selectedStop = self.searchListItem.stopList[indexPath.row];
            [self performSegueWithIdentifier:JWSeguePushStopList sender:self];
        }
    }
}

#pragma mark UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSString *searchText = searchBar.text;
    if (searchText && searchText.length > 0) {
        [self loadRequestWithKeyword:searchText showHUD:YES];
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText && searchText.length > 0) {
        [self loadRequestWithKeyword:searchText showHUD:NO];
    }
}

#pragma mark getter
- (JWSearchRequest *)searchRequest {
    if (!_searchRequest) {
        _searchRequest = [[JWSearchRequest alloc] init];
    }
    return _searchRequest;
}

- (NSArray *)collectLineItem {
    if (!_collectLineItem) {
        _collectLineItem = [[[JWUserDefaultsUtil allCollectItems] reverseObjectEnumerator] allObjects];
    }
    return _collectLineItem;
}

#pragma mark action
- (void)loadData {
    [self.navigationController showSGProgressWithDuration:0.6];
    _collectLineItem = nil;
    [self.tableView reloadData];
}

- (void)loadRequestWithKeyword:(NSString *)keyword showHUD:(BOOL)isShowHUD{
    if (isShowHUD) {
        [JWViewUtil showProgress];
    }
    
    self.searchRequest.keyWord = keyword;
    __weak typeof(self) weakSelf = self;
    [self.searchRequest loadWithCompletion:^(NSDictionary *dict, NSError *error) {
        if (isShowHUD) {
            if (error) {
                [JWViewUtil showError:error];
            } else {
                [JWViewUtil hideProgress];
            }
        }
        if (error) {
            weakSelf.searchListItem = nil;
            [weakSelf.searchController.searchResultsTableView reloadData];
            return;
        }
        NSInteger result = [dict[@"result"] integerValue];
        if (result == JWSearchResultTypeNone) {
            weakSelf.searchListItem = nil;
            [weakSelf.searchController.searchResultsTableView reloadData];    
        } else if (result == JWSearchResultTypeList) {
            // list result
            weakSelf.searchListItem = [[JWSearchListItem alloc] initWithDictionary:dict];
            [weakSelf.searchController.searchResultsTableView reloadData];
        } else if (result == JWSearchResultTypeSingle) {
            // single result
            weakSelf.busLineItem = [[JWBusLineItem alloc] initWithDictionary:dict];
            [weakSelf performSegueWithIdentifier:JWSeguePushLineWithData sender:self];
        }
    }];
}

@end
