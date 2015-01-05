//
//  JWRequestWithAlert.m
//  BusRider
//
//  Created by John Wong on 12/20/14.
//  Copyright (c) 2014 John Wong. All rights reserved.
//

#import "JWRequestWithAlert.h"

@implementation JWRequestWithAlert

- (void)loadWithCompletion:(JWCompletion)completion progress:(JWProgress)progress {
    JWCompletion completionWithAlert = ^(NSDictionary *dict, NSError *error) {
        if (error) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:error.userInfo[NSLocalizedDescriptionKey]?:error.domain
                                                                                     message:nil
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [alertController dismissViewControllerAnimated:YES completion:nil];
            }];
            [alertController addAction:alertAction];
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
        }
        completion(dict, error);
    };
    [super loadWithCompletion:completionWithAlert progress:progress];
}

@end
