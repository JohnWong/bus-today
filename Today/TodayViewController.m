//
//  TodayViewController.m
//  Today
//
//  Created by John Wong on 12/3/14.
//  Copyright (c) 2014 John Wong. All rights reserved.
//

#import "TodayViewController.h"
#import "STHTTPRequest.h"
#import <NotificationCenter/NotificationCenter.h>

@interface TodayViewController () <NCWidgetProviding, NSURLConnectionDataDelegate>

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self requestLineInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}

- (void)requestLineInfo {
    NSString *lineId = @"0571-044-0";
    NSString *urlStr=[NSString stringWithFormat:@"http://api.chelaile.net.cn:7000/bus/line!map2.action?lineId=%@&s=IOS&v=2.9&cityId=004&sign=", lineId];
    
    STHTTPRequest *r = [STHTTPRequest requestWithURLString:urlStr];
    
    r.completionBlock = ^(NSDictionary *headers, NSString *body) {
        NSString *jsonString = [[body stringByReplacingOccurrencesOfString:@"**YGKJ" withString:@""] stringByReplacingOccurrencesOfString:@"YGKJ##" withString:@""];
        NSError *error = nil;
        id dict = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
        if (error == nil && [dict isKindOfClass:[NSDictionary class]]) {
            NSDictionary *lineInfo = (NSDictionary *)dict[@"jsonr"][@"data"];
            NSLog(@"%@", lineInfo);
        }
    };
    
    r.errorBlock = ^(NSError *error) {
        // ...
    };
    
    [r startAsynchronous];
}

@end
