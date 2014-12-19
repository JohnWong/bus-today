//
//  JWRequestWithAlert.m
//  BusRider
//
//  Created by John Wong on 12/20/14.
//  Copyright (c) 2014 John Wong. All rights reserved.
//

#import "JWRequestWithAlert.h"

@implementation JWRequestWithAlert

- (void)loadWithCompletion:(JWCompletion)completion {
    JWCompletion completionWithAlert = ^(NSDictionary *dict, NSError *error) {
        if (error) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"网络错误"
                                                                                     message:nil
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [alertController dismissViewControllerAnimated:YES completion:nil];
            }];
            [alertController addAction:alertAction];
            [UIApplication sharedApplication]
            [self presentViewController:alertController animated:YES completion:nil];
            
        }
        completion(dict, error);
    };
    [super loadWithCompletion:completionWithAlert];
}

@end
