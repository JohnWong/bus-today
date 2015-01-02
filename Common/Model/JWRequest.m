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

@implementation JWRequest

- (void)loadWithCompletion:(JWCompletion)completion {
    NSLog(@"JWRequest: load %@", [self urlPath]);
    __weak typeof(self) weakSelf = self;
    STHTTPRequest *request = [STHTTPRequest requestWithURLString:[self urlPath]];
    request.completionBlock = ^(NSDictionary *headers, NSString *body) {
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
    request.errorBlock = ^(NSError *error) {
        NSLog(@"Request Error: %@, %@", [weakSelf urlPath], error);
        completion(nil, error);
    };
    [request startAsynchronous];
}

- (NSString *)urlPath {
    NSMutableString *paramString = [[NSMutableString alloc] init];
    NSDictionary *paramDict = [self params];
    for (NSString *key in paramDict) {
        [paramString appendFormat:@"&%@=%@", key, paramDict[key]];
    }
    return [NSString stringWithFormat:@"http://%@/bus/%@.action?s=IOS&v=2.9&cityId=004&sign=%@", kJWHost, [self actionName], paramString];
}

@end
