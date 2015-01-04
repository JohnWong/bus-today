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

#define kJWCellIdSearch @"kJWCellIdSearch"
#define kJWSeguePushLine @"kJWSeguePushLine"

@interface JWMainViewController () <UISearchBarDelegate, UITableViewDataSource>

@property (nonatomic, strong) JWSearchRequest *searchRequest;
@property (nonatomic, strong) JWBusLineItem *busLineItem;

@end

@implementation JWMainViewController

#pragma mark lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kJWSeguePushLine]) {
        if ([segue.destinationViewController isKindOfClass:[JWBusLineViewController class]]) {
            JWBusLineViewController *busLineViewController = (JWBusLineViewController *)segue.destinationViewController;
            busLineViewController.busLineItem = self.busLineItem;            
        }
    }
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kJWCellIdSearch];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kJWCellIdSearch];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row];
    return cell;
}

#pragma mark UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSString *keyWord = searchBar.text;
    self.searchRequest.keyWord = keyWord;
    __weak typeof(self) weakSelf = self;
    [self.searchRequest loadWithCompletion:^(NSDictionary *dict, NSError *error) {
        if (error) {
            return;
        }
        NSInteger result = [dict[@"result"] integerValue];
        if (result == 1) {
            // list result
        } else if (result == 2) {
            weakSelf.busLineItem = [[JWBusLineItem alloc] initWithDictionary:dict];
            [weakSelf performSegueWithIdentifier:kJWSeguePushLine sender:self];
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
