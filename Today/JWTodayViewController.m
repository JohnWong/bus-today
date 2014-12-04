//
//  JWTodayViewController.m
//  Today
//
//  Created by John Wong on 12/3/14.
//  Copyright (c) 2014 John Wong. All rights reserved.
//

#import "JWTodayViewController.h"
#import "STHTTPRequest.h"
#import "JWBusStopView.h"
#import <NotificationCenter/NotificationCenter.h>

@interface JWTodayViewController () <NCWidgetProviding, NSURLConnectionDataDelegate>

@property (weak, nonatomic) IBOutlet UIView *containerView;

@end

@implementation JWTodayViewController

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
    NSString *lineId = @"0571-0428-0";//@"0571-044-0";
//    NSString *urlStr=[NSString stringWithFormat:@"http://api.chelaile.net.cn:7000/bus/line!map2.action?lineId=%@&s=IOS&v=2.9&cityId=004&sign=", lineId];
    NSString *urlStr=[NSString stringWithFormat:@"http://localhost:7000/bus/line!map2.action?lineId=%@&s=IOS&v=2.9&cityId=004&sign=", lineId];
    
    STHTTPRequest *request = [STHTTPRequest requestWithURLString:urlStr];
    request.completionBlock = ^(NSDictionary *headers, NSString *body) {
        NSString *jsonString = [[body stringByReplacingOccurrencesOfString:@"**YGKJ" withString:@""] stringByReplacingOccurrencesOfString:@"YGKJ##" withString:@""];
        NSError *error = nil;
        id dict = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
        if (error == nil && [dict isKindOfClass:[NSDictionary class]]) {
            [self.containerView removeAllSubviews];
            NSDictionary *lineInfo = (NSDictionary *)dict[@"jsonr"][@"data"];
            NSLog(@"%@", lineInfo);
            
            NSArray *map = lineInfo[@"map"];
            NSInteger itemHeight = 24;
            NSInteger margin = 12;
            self.containerView.frame = CGRectMake(0, margin, self.view.width, map.count * itemHeight);
            self.preferredContentSize = CGSizeMake(self.view.width, self.containerView.height + margin * 2);
            for (int i = 0; i < map.count; i++) {
                NSDictionary *stopInfo = map[i];
                JWBusStopView *busStopView = [[JWBusStopView alloc] initWithFrame:CGRectMake(0, i * itemHeight, self.view.width, itemHeight - 1)];
                [busStopView setTitle:stopInfo[@"stopName"]];
                [self.containerView addSubview:busStopView];
            }
        }
    };
    [request startAsynchronous];
}

- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

@end
