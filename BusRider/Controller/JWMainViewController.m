//
//  JWMainViewController.m
//  BusRider
//
//  Created by John Wong on 12/15/14.
//  Copyright (c) 2014 John Wong. All rights reserved.
//

#import "JWMainViewController.h"
#import "JWSearchRequest.h"
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
#import "JWMainEmptyTableViewCell.h"
#import "JWSessionManager.h"
#import "JWNetworkUtility.h"
#import <objc/runtime.h>

#define JWCellIdMain @"JWCellIdMain"
#define JWCellIdEmpty @"JWCellIdEmpty"
#define JWCellIdSearch @"JWCellIdSearch"

typedef NS_ENUM(NSInteger, JWSearchResultType) {
    JWSearchResultTypeNone = 0,
    JWSearchResultTypeList = 1,
    JWSearchResultTypeSingle = 2
};


@interface JWMainViewController () <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, JWNavigationCenterDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchBarHeight;
@property (nonatomic, strong) JWSearchRequest *searchRequest;
@property (nonatomic, strong) JWSearchListItem *searchListItem;
@property (nonatomic, strong) NSString *cityName;
/**
 *  array of JWSearchLineItem
 */
@property (nonatomic, strong) NSMutableArray *collectLineItem;

@property (strong, nonatomic) IBOutlet UISearchDisplayController *searchController;

/**
 *  Pass to JWBusLineViewController
 */
@property (nonatomic, strong) JWSearchLineItem *lineItem;
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
- (void)viewDidLoad
{
    [super viewDidLoad];
    _cityName = [JWUserDefaultsUtil cityItem].cityName;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.cityButtonItem];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.searchController.searchResultsTableView registerNib:[UINib nibWithNibName:@"JWSearchTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:JWCellIdSearch];
    self.tableView.backgroundColor = HEXCOLOR(0xefeff6);
    [self.tableView registerNib:[UINib nibWithNibName:@"JWMainTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:JWCellIdMain];
    [self.tableView registerNib:[UINib nibWithNibName:@"JWMainEmptyTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:JWCellIdEmpty];
    //    self.tableView.tableFooterView = [[UIView alloc] init];
    self.searchController.searchBar.showsScopeBar = YES;
    self.storeHouseRefreshControl = [CBStoreHouseRefreshControl attachToScrollView:self.tableView
                                                                            target:self
                                                                     refreshAction:@selector(loadData)
                                                                             plist:@"bus"
                                                                             color:HEXCOLOR(0x007AFF)
                                                                         lineWidth:1
                                                                        dropHeight:90
                                                                             scale:1
                                                              horizontalRandomness:150
                                                           reverseLoadingAnimation:YES
                                                           internalAnimationFactor:1];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload) name:kNotificationContextUpdate object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"johnwong: %f", CACurrentMediaTime());
}

- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"johnwong: %f", CACurrentMediaTime());
    [super viewDidAppear:animated];
    [self.storeHouseRefreshControl scrollViewDidAppear];
    [self loadData];
    JWCityItem *cityItem = [JWUserDefaultsUtil cityItem];
    if (cityItem && ![cityItem.cityName isEqualToString:_cityName]) {
        _cityName = cityItem.cityName;
        _cityButtonItem = nil;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.cityButtonItem];
    }

    // 测试方法调用
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        int network = [JWNetworkUtility networkType];
        NSLog(@"Network: %d", network);
    });
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController cancelSGProgress];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:JWSeguePushLineWithId]) {
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

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
        return self.collectLineItem.count ?: 1;
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView) {
        if (self.collectLineItem.count > 0) {
            JWMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:JWCellIdMain forIndexPath:indexPath];
            JWCollectItem *item = self.collectLineItem[indexPath.row];
            cell.titleLabel.text = item.lineNumber;
            cell.subTitle.text = [NSString stringWithFormat:@"%@-%@", item.from, item.to];
            return cell;
        } else {
            JWMainEmptyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:JWCellIdEmpty forIndexPath:indexPath];
            cell.titleLabel.text = @"未收藏公交线路";
            cell.subTitle.text = @"点击搜索框找到想要的线路。收藏后就会出现在这里";
            return cell;
        }
    } else {
        JWSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:JWCellIdSearch forIndexPath:indexPath];
        if (indexPath.section == 0 && self.searchListItem.lineList.count > 0) {
            JWSearchLineItem *lineItem = self.searchListItem.lineList[indexPath.row];
            cell.titleLabel.text = lineItem.lineNumber;
            cell.iconView.image = [UIImage imageNamed:@"JWIconCellBus"];
            cell.subTitleLabel.text = [NSString stringWithFormat:@"%@-%@", lineItem.from, lineItem.to];
        } else {
            JWSearchStopItem *stopItem = self.searchListItem.stopList[indexPath.row];
            cell.titleLabel.text = stopItem.stopName;
            cell.iconView.image = [UIImage imageNamed:@"JWIconCellStop"];
            cell.subTitleLabel.text = nil;
        }
        return cell;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView) {
        if (self.collectLineItem.count == 0) {
            return 54;
        } else {
            return 54;
        }
    } else {
        return 44;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (indexPath.row < self.collectLineItem.count) {
            JWCollectItem *item = self.collectLineItem[indexPath.row];
            [JWUserDefaultsUtil removeCollectItemWithLineId:item.lineId];
            [self.collectLineItem removeObjectAtIndex:indexPath.row];
            if (self.collectLineItem.count > 0) {
                [self.tableView deleteRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
            } else {
                [self.tableView reloadData];
            }
        }
    }
}

#pragma mark JWNavigationCenterDelegate
- (void)buttonItem:(JWNavigationCenterView *)buttonItem setOn:(BOOL)isOn
{
    if (isOn) {
        [self showCityList];
    }
}

#pragma mark UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    JWCityItem *cityItem = [JWUserDefaultsUtil cityItem];
    if (cityItem) {
        return YES;
    } else {
        [self showCityList];
        return NO;
    }
}


- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self adjustSearchBar];
}

- (void)adjustSearchBar
{
    // iOS 11需要特殊处理下
    if (@available(iOS 11.0, *)) {
    } else {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        UISearchBar *searchBar = self.searchController.searchBar;
        searchBar.height = self.searchBarHeight.constant;
        UITextField *textField = [searchBar safeValueForKey:@"_searchField"];
        if (textField) {
            textField.centerY = searchBar.height / 2;
        }

        UIButton *cancelButton = [searchBar safeValueForKey:@"_cancelButton"];
        if (cancelButton) {
            cancelButton.centerY = searchBar.height / 2;
        }

        UIView *containerView = [self.searchController safeValueForKey:@"_containerView"];
        if ([containerView isKindOfClass:NSClassFromString(@"UISearchDisplayControllerContainerView")]) {
            UIView *topView = [containerView safeValueForKey:@"_topView"];
            UIView *bottomView = [containerView safeValueForKey:@"_bottomView"];
            topView.top = searchBar.top;
            topView.height = searchBar.height;
            bottomView.top = topView.bottom;
            bottomView.height = containerView.height - bottomView.top;
        }
    });
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *searchText = searchBar.text;
    if (searchText && searchText.length > 0) {
        [self loadRequestWithKeyword:searchText showHUD:YES];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.searchListItem = nil;
    [self.searchController.searchResultsTableView reloadData];
}

#pragma mark getter
- (JWSearchRequest *)searchRequest
{
    if (!_searchRequest) {
        _searchRequest = [[JWSearchRequest alloc] init];
    }
    return _searchRequest;
}

- (JWCityRequest *)cityRequest
{
    if (!_cityRequest) {
        _cityRequest = [[JWCityRequest alloc] init];
    }
    return _cityRequest;
}

- (NSMutableArray *)collectLineItem
{
    if (!_collectLineItem) {
        _collectLineItem = [[[[JWUserDefaultsUtil allCollectItems] reverseObjectEnumerator] allObjects] mutableCopy];
    }
    return _collectLineItem;
}

- (JWNavigationCenterView *)cityButtonItem
{
    if (!_cityButtonItem) {
        _cityButtonItem = [[JWNavigationCenterView alloc] initWithTitle:_cityName ?: @"城市" isBold:NO];
        _cityButtonItem.delegate = self;
    }
    return _cityButtonItem;
}

#pragma mark action
- (void)loadData
{
    _collectLineItem = nil;
    [self.tableView reloadData];
    [self.storeHouseRefreshControl performSelector:@selector(finishingLoading) withObject:nil afterDelay:0.3 inModes:@[ NSRunLoopCommonModes ]];
}

- (void)showCityList
{
    __weak typeof(self) weakSelf = self;
    [self.cityRequest loadWithCompletion:^(NSDictionary *dict, NSError *error) {
        if (error) {
            [JWViewUtil showError:error];
            [weakSelf.cityButtonItem setOn:NO];
        } else {
            NSArray *array = dict[kJWData];
            if (array.count > 0) {
                [weakSelf showCityListActionSheet:array];
            }
        }
    }];
}

- (void)showCityListActionSheet:(NSArray *)array
{
    __weak typeof(self) weakSelf = self;
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
            [[JWSessionManager defaultManager] sync];
        }];
    }
    [actionSheet show];
}

- (void)reload
{
    NSString *city = [JWUserDefaultsUtil cityItem].cityName;
    [self.cityButtonItem setTitle:city];
    [self loadData];
}

- (void)loadRequestWithKeyword:(NSString *)keyword showHUD:(BOOL)isShowHUD
{
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
        NSInteger result = [dict[@"type"] integerValue];
        if (result == JWSearchResultTypeNone) {
            weakSelf.searchListItem = nil;
            [weakSelf.searchController.searchResultsTableView reloadData];
        } else {
            // list result
            weakSelf.searchListItem = [[JWSearchListItem alloc] initWithDictionary:dict];
            [weakSelf.searchController.searchResultsTableView reloadData];
        }
    }];
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
