//
//  JWLineTableViewController.m
//  BusRider
//
//  Created by John Wong on 12/10/14.
//  Copyright (c) 2014 John Wong. All rights reserved.
//

#import "JWLineTableViewController.h"

@interface JWLineTableViewController ()

@end

@implementation JWLineTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TestCell" forIndexPath:indexPath];
    if (indexPath.row == 1) {
        cell.backgroundColor = HEXCOLOR(0xff0000);
    }
    cell.contentView.frame = CGRectMake(10, 0, cell.width - 20, cell.height);
    cell.contentView.backgroundColor = HEXCOLOR(0xffffff);
    
    return cell;
}

@end
