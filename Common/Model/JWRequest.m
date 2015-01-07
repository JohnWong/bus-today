//
//  JWRequest.m
//  BusRider
//
//  Created by John Wong on 12/16/14.
//  Copyright (c) 2014 John Wong. All rights reserved.
//

#import "JWRequest.h"
#import "STHTTPRequest.h"

#define JWDataErrorKey @"JWDataError"

@interface JWRequest ()

@property (nonatomic, strong) STHTTPRequest *request;

@end

@implementation JWRequest

- (void)loadWithCompletion:(JWCompletion)completion {
    [self loadWithCompletion:completion progress:nil];
}

- (void)loadWithCompletion:(JWCompletion)completion progress:(JWProgress)progress {
    NSString *checkResult = [self validateParams];
    if (checkResult) {
        NSError *error = [NSError errorWithDomain:checkResult code:0 userInfo:nil];
        completion(nil, error);
        return;
    }
    NSLog(@"JWRequest: load %@", [self urlPath]);
    
    __weak typeof(self) weakSelf = self;
    if (self.request) {
        [self.request cancel];
    }
    self.request = [STHTTPRequest requestWithURLString:[self urlPath]];
    self.request.completionBlock = ^(NSDictionary *headers, NSString *body) {
        NSString *jsonString = [[body stringByReplacingOccurrencesOfString:@"**YGKJ" withString:@""] stringByReplacingOccurrencesOfString:@"YGKJ##" withString:@""];
        NSError *error = nil;
        id dict = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
        if (error == nil && [dict isKindOfClass:[NSDictionary class]]) {
            NSDictionary *jsonr = dict[@"jsonr"];
            NSDictionary *infoDict = jsonr[@"data"];
            if (infoDict.count > 0) {
                NSLog(@"JWRequest: response %@", infoDict);
                completion(infoDict, nil);
            } else {
                error = [NSError errorWithDomain:JWDataErrorKey
                                            code:301
                                        userInfo:@{
                                                   NSLocalizedDescriptionKey:jsonr[@"errmsg"]
                                                   }];
                NSLog(@"JWRequest: error %@", error);
                completion(nil, error);
            }
            
        } else {
            NSLog(@"JWRequest: error %@", error);
            completion(nil, error);
        }
    };
    self.request.errorBlock = ^(NSError *error) {
        NSLog(@"JWRequest: error %@, %@", [weakSelf urlPath], error);
        if ([error.localizedDescription isEqualToString:@"Connection was cancelled."]) {
            return;
        }
        completion(nil, error);
    };
    self.request.downloadProgressBlock = ^(NSData *data, NSUInteger totalBytesReceived, long long totalBytesExpectedToReceive) {
        NSLog(@"JWRequest: progress %ld / %lld", totalBytesReceived, totalBytesExpectedToReceive);
        if (progress) {
            progress(totalBytesReceived * 100 / totalBytesExpectedToReceive);
        }
    };
    [self.request startAsynchronous];
}

- (NSString *)urlPath {
    NSMutableString *paramString = [[NSMutableString alloc] init];
    NSDictionary *paramDict = [self params];
    for (NSString *key in paramDict) {
        [paramString appendFormat:@"&%@=%@", key, paramDict[key]];
    }
    return [NSString stringWithFormat:@"http://%@/bus/%@.action?s=IOS&v=2.9&cityId=004&sign=%@", kJWHost, [self actionName], paramString];
}

- (NSString *)validateParams {
    return nil;
}

@end
