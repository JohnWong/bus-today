//
//  JWRequestModel.h
//  BusRider
//
//  Created by John Wong on 12/16/14.
//  Copyright (c) 2014 John Wong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^JWCompletion)(NSDictionary *dict, NSError *error);

@interface JWRequest : NSObject

@property (nonatomic, strong) NSDictionary *params;
@property (nonatomic, strong) NSString *actionName;

- (void)loadWithCompletion:(JWCompletion)completion;

@end
