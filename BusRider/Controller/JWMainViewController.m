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

#define kJWSearchCellId @"kJWSearchCellId"

@interface JWMainViewController () <UISearchBarDelegate, UITableViewDataSource>

@property (nonatomic, strong) JWSearchRequest *searchRequest;

@end

@implementation JWMainViewController

#pragma mark lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
}


#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kJWSearchCellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kJWSearchCellId];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row];
    return cell;
}

#pragma mark UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSString *keyWord = searchBar.text;
    self.searchRequest.keyWord = keyWord;
    [self.searchRequest loadWithCompletion:^(NSDictionary *dict, NSError *error) {
        if (error) {
            
            return;
        }
        NSInteger result = [dict[@"result"] integerValue];
        if (result == 1) {
            // list result
        } else if (result == 2) {
            JWBusLineItem *busLineItem = [[JWBusLineItem alloc] initWithDictionary:dict];
            
            
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
