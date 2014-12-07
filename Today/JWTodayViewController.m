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
#import "JWBusCardView.h"
#import "JWStopInfoItem.h"
#import "JWBusInfoItem.h"
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
            NSDictionary *busInfo = (NSDictionary *)dict[@"jsonr"][@"data"];
            NSLog(@"%@", busInfo);
            
            /*
            NSMutableArray *mapArray = [busInfo[@"map"] mutableCopy];
            NSArray *busArray = busInfo[@"bus"];
            NSInteger itemHeight = 32;
            NSInteger margin = 12;
            self.containerView.frame = CGRectMake(0, margin, self.view.width, (busArray.count + 1) * itemHeight);
            self.preferredContentSize = CGSizeMake(self.view.width, self.containerView.height + margin * 2);
            
            for (int i = 0; i < busArray.count; i++) {
                NSDictionary *busDict = busArray[i];
                NSInteger order = [busDict[@"order"] integerValue] - 1;
                NSMutableDictionary *mapDict = [mapArray[order] mutableCopy];
                mapDict[@"bus"] = busDict;
                [mapArray replaceObjectAtIndex:order withObject:mapDict];
            }
            
            NSInteger top = 0;
            NSInteger lastOrder = 0;
            for (NSDictionary * mapDict in mapArray) {
                NSDictionary *busDict = mapDict[@"bus"];
                if (busDict) {
                    JWStopInfoItem *stopInfoItem = [[JWStopInfoItem alloc] initWithDictionary:mapDict];
                    if ([stopInfoItem.title isEqualToString: @"文一西路狮山路口"]) {
                        stopInfoItem.lastOrder = lastOrder;
                    }
                    JWBusStopView *busStopView = [[JWBusStopView alloc] initWithFrame:CGRectMake(0, top * itemHeight, self.view.width, itemHeight - 1)];
                    top ++;
                    [busStopView setItem:stopInfoItem];
                    [self.containerView addSubview:busStopView];
                    lastOrder = [busDict[@"order"] integerValue];
                } else if ([mapDict[@"stopName"] isEqualToString:@"文一西路狮山路口"]) {
                    JWStopInfoItem *stopInfoItem = [[JWStopInfoItem alloc] initWithDictionary:mapDict];
                    stopInfoItem.lastOrder = lastOrder;
                    JWBusStopView *busStopView = [[JWBusStopView alloc] initWithFrame:CGRectMake(0, top * itemHeight, self.view.width, itemHeight - 1)];
                    top ++;
                    [busStopView setItem:stopInfoItem];
                    [self.containerView addSubview:busStopView];
                }
            }
             */
            
            NSDictionary *lineInfo = busInfo[@"line"];
            JWBusInfoItem *busInfoItem = [[JWBusInfoItem alloc] init];
            busInfoItem.currentStop = @"文一西路狮山路口";
            busInfoItem.lineNumber = lineInfo[@"lineName"];
            busInfoItem.from = lineInfo[@"startStopName"];
            busInfoItem.to = lineInfo[@"endStopName"];
            busInfoItem.firstTime = lineInfo[@"firstTime"];
            busInfoItem.lastTime = lineInfo[@"lastTime"];
            
            JWBusCardView *cardView = [[JWBusCardView alloc] initWithFrame:CGRectMake(47, 0, self.view.width - 47, 75)];
            [cardView setItem:busInfoItem];
            [self.containerView addSubview:cardView];
            
        }
    };
    request.errorBlock = ^(NSError *error) {
    
    };

    [request startAsynchronous];
}

- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets {
    return UIEdgeInsetsMake(0, 0, 0, 12);
}

@end
