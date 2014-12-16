//
//  JWMainViewController.m
//  BusRider
//
//  Created by John Wong on 12/15/14.
//  Copyright (c) 2014 John Wong. All rights reserved.
//

#import "JWMainViewController.h"

#define kJWSearchCellId @"kJWSearchCellId"

@interface JWMainViewController () <UISearchBarDelegate, UITableViewDataSource>

@end

@implementation JWMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

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

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
}

@end
