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

#define JWCellIdCollect @"JWCellIdCollect"
#define JWCellIdSearch @"JWCellIdSearch"
#define JWSeguePushLineWithData @"JWSeguePushLineWithData"
#define JWSeguePushLineWithId @"JWSeguePushLineWithId"

typedef NS_ENUM(NSInteger, JWSearchResultType) {
    JWSearchResultTypeNone = 0,
    JWSearchResultTypeList = 1,
    JWSearchResultTypeSingle = 2
};

@interface JWMainViewController () <UISearchBarDelegate, UITableViewDataSource>

@property (nonatomic, strong) JWSearchRequest *searchRequest;
@property (nonatomic, strong) JWSearchListItem *searchListItem;
@property (strong, nonatomic) IBOutlet UISearchDisplayController *searchController;

/**
 *  Pass to JWBusLineViewController
 */
@property (nonatomic, strong) JWBusLineItem *busLineItem;
/**
 *  Pass to JWBusLineViewController
 */
@property (nonatomic, strong) JWSearchLineItem *selectedLine;

@end

@implementation JWMainViewController

#pragma mark lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.searchController.searchResultsTableView registerNib:[UINib nibWithNibName:@"JWSearchTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:JWCellIdSearch];
    [self.tableView registerNib:[UINib nibWithNibName:@"JWSearchTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:JWCellIdSearch];
    self.tableView.tableFooterView = [[UIView alloc] init];
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
    }
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        return 5;
    } else {
        if (self.searchListItem) {
            if (section == 0) {
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
            return 2;
        } else {
            return 0;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tableView) {
        JWSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:JWCellIdSearch forIndexPath:indexPath];
        return cell;
    } else {
        JWSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:JWCellIdSearch forIndexPath:indexPath];
        if (indexPath.section == 0) {
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
        if (section == 0) {
            return @"公交路线";
        } else {
            return @"公交站点";
        }
    }
    return nil;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tableView) {
        
    } else {
        if (indexPath.section == 0) {
            JWSearchLineItem *searchLineItem = self.searchListItem.lineList[indexPath.row];
            self.selectedLine = searchLineItem;
            [self performSegueWithIdentifier:JWSeguePushLineWithId sender:self];
        } else {
            
        }
    }
}

#pragma mark UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSString *searchText = searchBar.text;
    // TODO request and show progress
    if (searchText && searchText.length > 0) {
        [self loadRequestWithKeyword:searchText isShowProgress:YES];
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText && searchText.length > 0) {
        [self loadRequestWithKeyword:searchText isShowProgress:YES];
    }
}

#pragma mark getter
- (JWSearchRequest *)searchRequest {
    if (!_searchRequest) {
        _searchRequest = [[JWSearchRequest alloc] init];
    }
    return _searchRequest;
}

#pragma mark action
- (void)loadRequestWithKeyword:(NSString *)keyword isShowProgress:(BOOL)isShowProgress{
    self.searchRequest.keyWord = keyword;
    __weak typeof(self) weakSelf = self;
    [self.searchRequest loadWithCompletion:^(NSDictionary *dict, NSError *error) {
        if (error) {
            if (isShowProgress) {
                // TODO show progress hud and hold interaction
                [JWViewUtil showError:error];
            }
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
            weakSelf.busLineItem = [[JWBusLineItem alloc] initWithDictionary:dict];
            [weakSelf performSegueWithIdentifier:JWSeguePushLineWithData sender:self];
        }
    }];
}

@end
