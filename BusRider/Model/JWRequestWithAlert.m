//
//  JWRequestWithAlert.m
//  BusRider
//
//  Created by John Wong on 12/20/14.
//  Copyright (c) 2014 John Wong. All rights reserved.
//

#import "JWRequestWithAlert.h"
#import "JWViewUtil.h"

@implementation JWRequestWithAlert

- (void)loadWithCompletion:(JWCompletion)completion progress:(JWProgress)progress {
    JWCompletion completionWithAlert = ^(NSDictionary *dict, NSError *error) {
        if (error) {
            [JWViewUtil showError:error];
        }
        completion(dict, error);
    };
    [super loadWithCompletion:completionWithAlert progress:progress];
}

@end
