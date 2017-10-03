//
//  JWRequestModel.h
//  BusRider
//
//  Created by John Wong on 12/16/14.
//  Copyright (c) 2014 John Wong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^JWCompletion)(NSDictionary *dict, NSError *error);
typedef void (^JWProgress)(CGFloat percent);


@interface JWRequest : NSObject

@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSDictionary *params;
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString *actionName;

- (void)loadWithCompletion:(JWCompletion)completion;
- (void)loadWithCompletion:(JWCompletion)completion progress:(JWProgress)progress;
/**
 *  网络请求前检查参数，返回nil表示检查无误。否则返回错误的domain
 */
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString *validateParams;

@end
