//
//  JWTodayViewController.m
//  Today
//
//  Created by John Wong on 12/3/14.
//  Copyright (c) 2014 John Wong. All rights reserved.
//

#import "JWTodayViewController.h"
#import "STHTTPRequest.h"
#import "JWBusCardView.h"
#import "JWStopInfoItem.h"
#import "JWBusInfoItem.h"
#import <NotificationCenter/NotificationCenter.h>

@interface JWTodayViewController () <NCWidgetProviding, NSURLConnectionDataDelegate>

@property (weak, nonatomic) IBOutlet JWBusCardView *busCardView;

@end

@implementation JWTodayViewController

#pragma mark lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self requestLineInfo];
}


#pragma mark NCWidgetProviding
- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets {
    return UIEdgeInsetsMake(0, 0, 0, 12);
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}

- (void)requestLineInfo {
    NSString *lineId = @"0571-0428-0";//@"0571-044-0";
    NSString *userStop = @"浙江理工大学科艺学院";
    
    STHTTPRequest *request = [STHTTPRequest requestWithURLString:JWBusLineURL(lineId)];
    request.completionBlock = ^(NSDictionary *headers, NSString *body) {
        NSString *jsonString = [[body stringByReplacingOccurrencesOfString:@"**YGKJ" withString:@""] stringByReplacingOccurrencesOfString:@"YGKJ##" withString:@""];
        NSError *error = nil;
        id dict = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
        if (error == nil && [dict isKindOfClass:[NSDictionary class]]) {
            NSDictionary *busInfo = (NSDictionary *)dict[@"jsonr"][@"data"];
            NSLog(@"%@", busInfo);
            
            JWBusInfoItem *busInfoItem = [[JWBusInfoItem alloc] initWithUserStop:userStop busInfo:busInfo];
            [self.busCardView setItem:busInfoItem];
        }
    };
    request.errorBlock = ^(NSError *error) {
        NSLog(@"%@", error);
    };

    [request startAsynchronous];
}


#pragma mark action
- (IBAction)refreshData:(id)sender {
    [self requestLineInfo];
}

@end
