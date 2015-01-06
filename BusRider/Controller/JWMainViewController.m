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

#define JWCellIdSearch @"JWCellIdSearch"
#define JWSeguePushLine @"JWSeguePushLine"

@interface JWMainViewController () <UISearchBarDelegate, UITableViewDataSource>

@property (nonatomic, strong) JWSearchRequest *searchRequest;
@property (nonatomic, strong) JWBusLineItem *busLineItem;

@end

@implementation JWMainViewController

#pragma mark lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:JWSeguePushLine]) {
        if ([segue.destinationViewController isKindOfClass:[JWBusLineViewController class]]) {
            JWBusLineViewController *busLineViewController = (JWBusLineViewController *)segue.destinationViewController;
            busLineViewController.busLineItem = self.busLineItem;            
        }
    }
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        return 5;
    } else {
        return 3;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:JWCellIdSearch forIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 56;
}

#pragma mark UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSString *keyWord = searchBar.text;
    self.searchRequest.keyWord = keyWord;
    __weak typeof(self) weakSelf = self;
    [self.searchRequest loadWithCompletion:^(NSDictionary *dict, NSError *error) {
        if (error) {
            [JWViewUtil showError:error];
            return;
        }
        NSInteger result = [dict[@"result"] integerValue];
        if (result == 1) {
            // list result
        } else if (result == 2) {
            weakSelf.busLineItem = [[JWBusLineItem alloc] initWithDictionary:dict];
            [weakSelf performSegueWithIdentifier:JWSeguePushLine sender:self];
        }
    }];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
}

#pragma mark getter
- (JWSearchRequest *)searchRequest {
    if (!_searchRequest) {
        _searchRequest = [[JWSearchRequest alloc] init];
    }
    return _searchRequest;
}

@end
