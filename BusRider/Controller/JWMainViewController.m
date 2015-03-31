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
#import "UINavigationController+SGProgress.h"
#import "JWMainTableViewCell.h"
#import "JWStopTableViewController.h"
#import "JWBusInfoItem.h"
#import "JWNavigationCenterView.h"
#import "JWCityRequest.h"
#import "JWCityItem.h"
#import "AHKActionSheet.h"
#import "CBStoreHouseRefreshControl.h"

#define JWCellIdMain                @"JWCellIdMain"
#define JWCellIdEmpty               @"JWCellIdEmpty"
#define JWCellIdSearch              @"JWCellIdSearch"

typedef NS_ENUM(NSInteger, JWSearchResultType) {
    JWSearchResultTypeNone = 0,
    JWSearchResultTypeList = 1,
    JWSearchResultTypeSingle = 2
};

@interface JWMainViewController () <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, JWNavigationCenterDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) JWSearchRequest *searchRequest;
@property (nonatomic, strong) JWSearchListItem *searchListItem;
/**
 *  array of JWSearchLineItem
 */
@property (nonatomic, strong) NSMutableArray *collectLineItem;

@property (strong, nonatomic) IBOutlet UISearchDisplayController *searchController;

/**
 *  Pass to JWBusLineViewController
 */
@property (nonatomic, strong) JWBusLineItem *busLineItem;
/**
 *  Pass to JWBusLineViewController
 */
@property (nonatomic, strong) JWBusInfoItem *busInfoItem;
/**
 *  Pass to JWStopViewController
 */
@property (nonatomic, strong) JWSearchStopItem *selectedStop;
@property (nonatomic, strong) JWNavigationCenterView *cityButtonItem;
@property (nonatomic, strong) JWCityRequest *cityRequest;
@property (nonatomic, strong) CBStoreHouseRefreshControl *storeHouseRefreshControl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation JWMainViewController

#pragma mark lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.cityButtonItem];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.searchController.searchResultsTableView registerNib:[UINib nibWithNibName:@"JWSearchTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:JWCellIdSearch];
    self.tableView.backgroundColor = HEXCOLOR(0xefeff6);
    [self.tableView registerNib:[UINib nibWithNibName:@"JWMainTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:JWCellIdMain];
//    self.tableView.tableFooterView = [[UIView alloc] init];
    self.searchController.searchBar.showsScopeBar = YES;
    self.storeHouseRefreshControl = [CBStoreHouseRefreshControl attachToScrollView:self.tableView
                                                                  target:self
                                                           refreshAction:@selector(loadData)
                                                                   plist:@"bus"
                                                                   color:HEXCOLOR(0x007AFF)
                                                               lineWidth:1
                                                              dropHeight:60
                                                                   scale:1
                                                    horizontalRandomness:150
                                                 reverseLoadingAnimation:YES
                                                 internalAnimationFactor:1];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass(self.class)];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.storeHouseRefreshControl scrollViewDidAppear];
    [self loadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass(self.class)];
    [self.navigationController cancelSGProgress];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:JWSeguePushLineWithData]) {
        if ([segue.destinationViewController isKindOfClass:[JWBusLineViewController class]]) {
            JWBusLineViewController *busLineViewController = (JWBusLineViewController *)segue.destinationViewController;
            busLineViewController.busLineItem = self.busLineItem;
            busLineViewController.busInfoItem = self.busInfoItem;
        }
    } else if ([segue.identifier isEqualToString:JWSeguePushLineWithId]) {
        if ([segue.destinationViewController isKindOfClass:[JWBusLineViewController class]]) {
            JWBusLineViewController *busLineViewController = (JWBusLineViewController *)segue.destinationViewController;
            busLineViewController.lineId = self.selectedLineId;
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
        return self.collectLineItem.count ? : 1;
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
        if (self.collectLineItem.count > 0) {
            JWMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:JWCellIdMain forIndexPath:indexPath];
            JWCollectItem *item = self.collectLineItem[indexPath.row];
            cell.titleLabel.text = item.lineNumber;
            cell.subTitle.text = [NSString stringWithFormat:@"%@-%@", item.from, item.to];
            return cell;
        } else {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:JWCellIdEmpty];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:JWCellIdEmpty];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.textLabel.text = @"您还没有收藏的公交线路";
            return cell;
        }
    } else {
        JWSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:JWCellIdSearch forIndexPath:indexPath];
        if (indexPath.section == 0 && self.searchListItem.lineList.count > 0) {
            JWSearchLineItem *lineItem = self.searchListItem.lineList[indexPath.row];
            cell.titleLabel.text = lineItem.lineNumber;
            cell.iconView.image = [UIImage imageNamed:@"JWIconCellBus"];
        } else {
            JWSearchStopItem *stopItem = self.searchListItem.stopList[indexPath.row];
            cell.titleLabel.text = stopItem.stopName;
            cell.iconView.image = [UIImage imageNamed:@"JWIconCellStop"];
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == self.tableView) {
        if (self.collectLineItem.count > 0) {
            JWCollectItem *item = self.collectLineItem[indexPath.row];
            self.selectedLineId = item.lineId;
            [self performSegueWithIdentifier:JWSeguePushLineWithId sender:self];
        }
    } else {
        if (indexPath.section == 0 && self.searchListItem.lineList.count > 0) {
            JWSearchLineItem *lineItem = self.searchListItem.lineList[indexPath.row];
            self.selectedLineId = lineItem.lineId;
            [self performSegueWithIdentifier:JWSeguePushLineWithId sender:self];
        } else {
            self.selectedStop = self.searchListItem.stopList[indexPath.row];
            [self performSegueWithIdentifier:JWSeguePushStopList sender:self];
        }
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (indexPath.row < self.collectLineItem.count) {
            JWCollectItem *item = self.collectLineItem[indexPath.row];
            [JWUserDefaultsUtil removeCollectItemWithLineId:item.lineId];
            [self.collectLineItem removeObjectAtIndex:indexPath.row];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
}

#pragma mark JWNavigationCenterDelegate
- (void)buttonItem:(JWNavigationCenterView *)buttonItem setOn:(BOOL)isOn {
    if (isOn) {
        [self showCityList];
    }
}

#pragma mark UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    JWCityItem *cityItem = [JWUserDefaultsUtil cityItem];
    if (cityItem) {
        return YES;
    } else {
        [self showCityList];
        return NO;
    }
}

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

- (JWCityRequest *)cityRequest {
    if (!_cityRequest) {
        _cityRequest = [[JWCityRequest alloc] init];
    }
    return _cityRequest;
}

- (NSMutableArray *)collectLineItem {
    if (!_collectLineItem) {
        _collectLineItem = [[[[JWUserDefaultsUtil allCollectItems] reverseObjectEnumerator] allObjects] mutableCopy];
    }
    return _collectLineItem;
}

- (JWNavigationCenterView *)cityButtonItem {
    if (!_cityButtonItem) {
        JWCityItem *cityItem = [JWUserDefaultsUtil cityItem];
        _cityButtonItem = [[JWNavigationCenterView alloc] initWithTitle:cityItem ? cityItem.cityName : @"城市" isBold:NO];
        _cityButtonItem.delegate = self;
    }
    return _cityButtonItem;
}

#pragma mark action
- (void)loadData {
    _collectLineItem = nil;
    [self.tableView reloadData];
    [self.storeHouseRefreshControl performSelector:@selector(finishingLoading) withObject:nil afterDelay:0.3 inModes:@[NSRunLoopCommonModes]];
}

- (void)showCityList {
    __weak typeof(self) weakSelf = self;
    [self.cityRequest loadWithCompletion:^(NSDictionary *dict, NSError *error) {
        if (error) {
            [JWViewUtil showError:error];
            [weakSelf.cityButtonItem setOn:NO];
        } else {
            NSArray *array = [JWCityItem arrayFromDictionary:dict];
            AHKActionSheet *actionSheet = [[AHKActionSheet alloc] initWithTitle:@"选择城市"];
            actionSheet.cancelButtonTitle = @"取消";
            actionSheet.buttonHeight = 44;
            actionSheet.animationDuration = 0.4;
            actionSheet.cancelHandler = ^(AHKActionSheet *actionSheet) {
                [weakSelf.cityButtonItem setOn:NO];
            };
            for (JWCityItem *cityItem in array) {
                [actionSheet addButtonWithTitle:cityItem.cityName image:[UIImage imageNamed:@"JWIconCity"] type:AHKActionSheetButtonTypeDefault handler:^(AHKActionSheet *actionSheet) {
                    [weakSelf.cityButtonItem setOn:NO];
                    [weakSelf.cityButtonItem setTitle:cityItem.cityName];
                    [JWUserDefaultsUtil setCityItem:cityItem];
                    [weakSelf loadData];
                }];
            }
            [actionSheet show];
        }
    }];
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
            JWBusLineItem *busLineItem = [[JWBusLineItem alloc] initWithDictionary:dict];
            weakSelf.busLineItem = busLineItem;
            
            JWCollectItem *collectItem = [JWUserDefaultsUtil collectItemForLineId:busLineItem.lineItem.lineId];
            if (collectItem && collectItem.order && collectItem.stopName) {
                JWStopItem *stopItem = [[JWStopItem alloc] initWithOrder:collectItem.order stopName:collectItem.stopName];
                weakSelf.busInfoItem = [[JWBusInfoItem alloc] initWithUserStopOrder:stopItem.order busInfo:dict];
            } else {
                weakSelf.busInfoItem = nil;
            }
            [weakSelf performSegueWithIdentifier:JWSeguePushLineWithData sender:weakSelf];
        }
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
