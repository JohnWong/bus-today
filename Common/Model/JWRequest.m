//
//  JWRequest.m
//  BusRider
//
//  Created by John Wong on 12/16/14.
//  Copyright (c) 2014 John Wong. All rights reserved.
//

#import "JWRequest.h"
#import "STHTTPRequest.h"
#import "JWUserDefaultsUtil.h"
#import "JWCityItem.h"

#define JWDataErrorKey @"JWDataError"

//#define FAKE

#ifdef FAKE
#define kJWHost @"localhost:7000"
#else
#define kJWHost @"api.chelaile.net.cn:7000"
#endif


@interface JWRequest ()

@property (nonatomic, strong) STHTTPRequest *request;

@end


@implementation JWRequest

- (NSString *)actionName
{
    NSAssert(NO, @"override this method %s", __FUNCTION__);
    return nil;
}

- (NSDictionary *)params
{
    return nil;
}

- (void)loadWithCompletion:(JWCompletion)completion
{
    [self loadWithCompletion:completion progress:nil];
}

- (void)loadWithCompletion:(JWCompletion)completion progress:(JWProgress)progress
{
    NSString *checkResult = self.validateParams;
    if (checkResult) {
        NSError *error = [NSError errorWithDomain:JWDataErrorKey code:0 userInfo:@{
            NSLocalizedDescriptionKey : checkResult
        }];
        completion(nil, error);
        return;
    }
    NSLog(@"JWRequest: load %@", [self urlPath]);

    if (self.request) {
        [self.request cancel];
    }
    if (progress) {
        progress(20);
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
                                            NSLocalizedDescriptionKey : jsonr[@"errmsg"]
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
        if (error.code == kSTHTTPRequestCancellationError ||
            error.code == -999) { // Connection was cancelled.
            return;
        }
        completion(nil, error);
    };
    self.request.downloadProgressBlock = ^(NSData *data, int64_t totalBytesReceived, int64_t totalBytesExpectedToReceive) {
        NSLog(@"JWRequest: progress %ld / %lld", (unsigned long)totalBytesReceived, totalBytesExpectedToReceive);
        if (progress) {
            CGFloat percent = totalBytesReceived * 100 / (totalBytesExpectedToReceive == NSURLResponseUnknownLength ? 10240 : totalBytesReceived);
            if (percent > 0.2) {
                progress(percent);
            }
        }
    };
    [self.request startAsynchronous];
}

- (NSString *)urlPath
{
    NSMutableString *paramString = [[NSMutableString alloc] init];
    NSDictionary *paramDict = self.params;
    for (NSString *key in paramDict) {
        [paramString appendFormat:@"&%@=%@", key, paramDict[key]];
    }
    NSString *cityId = @"";
    JWCityItem *cityItem = [JWUserDefaultsUtil cityItem];
    if (cityItem) {
        cityId = [NSString stringWithFormat:@"&cityId=%@", cityItem.cityId];
    }
    return [NSString stringWithFormat:@"http://%@/%@/%@.action?sign=&v=5.2.0&s=IOS&sv=9.1&vc=10070%@%@",
                                      kJWHost,
                                      [self isKindOfClass:NSClassFromString(@"JWCityRequest")] ? @"goocity" : @"bus",
                                      self.actionName,
                                      cityId,
                                      [paramString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
}

- (NSString *)validateParams
{
    return nil;
}

- (void)dealloc
{
    [_request cancel];
}

@end
