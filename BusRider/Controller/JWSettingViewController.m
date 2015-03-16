//
//  JWSettingViewController.m
//  BusRider
//
//  Created by John Wong on 3/17/15.
//  Copyright (c) 2015 John Wong. All rights reserved.
//

#import "JWSettingViewController.h"

@interface JWSettingViewController ()

@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

@end

@implementation JWSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    self.versionLabel.text = app_Version;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
