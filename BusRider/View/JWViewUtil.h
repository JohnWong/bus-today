//
//  JWViewUtil.h
//  BusRider
//
//  Created by John Wong on 12/20/14.
//  Copyright (c) 2014 John Wong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface JWViewUtil : NSObject

+ (UIView *)viewWithFrame:(CGRect)frame color:(UIColor *)color;
+ (UILabel *)labelWithFrame:(CGRect)frame text:(NSString *)text size:(NSInteger)size color:(UIColor *)color;
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
+ (UIImage *)resizableImageWithColor:(UIColor *)color;
+ (void)showErrorWithMessage:(NSString *)message;
+ (void)showSuccessWithMessage:(NSString *)message;
+ (void)showError:(NSError *)error;
+ (void)showInfoWithMessage:(NSString *)message;
+ (void)showProgress;
+ (void)hideProgress;

@end
