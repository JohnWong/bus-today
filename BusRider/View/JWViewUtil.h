//
//  JWViewUtil.h
//  BusRider
//
//  Created by John Wong on 12/20/14.
//  Copyright (c) 2014 John Wong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JWViewUtil : NSObject

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
+ (UIImage *)resizableImageWithColor:(UIColor *)color;
+ (void)showErrorWithMessage:(NSString *)message;
+ (void)showSuccessWithMessage:(NSString *)message;
+ (void)showError:(NSError *)error;

@end
