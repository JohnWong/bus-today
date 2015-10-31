//
//  JWViewUtil.m
//  BusRider
//
//  Created by John Wong on 12/20/14.
//  Copyright (c) 2014 John Wong. All rights reserved.
//

#import "JWViewUtil.h"
#import "SVProgressHUD.h"


@implementation JWViewUtil

+ (UIView *)viewWithFrame:(CGRect)frame color:(UIColor *)color
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = color;
    return view;
}

+ (UILabel *)labelWithFrame:(CGRect)frame text:(NSString *)text size:(NSInteger)size color:(UIColor *)color
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:size];
    label.textColor = color;
    label.text = text;
    return label;
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, 0, [UIScreen mainScreen].scale);
    [color set];
    UIRectFill(CGRectMake(0, 0, size.width, size.height));
    UIImage *pureColorImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return pureColorImage;
}

+ (UIImage *)resizableImageWithColor:(UIColor *)color
{
    return [[self imageWithColor:color size:CGSizeMake(1, 1)] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
}

+ (void)setHUDColor
{
    [SVProgressHUD setBackgroundColor:HEXCOLORA(0x0, 0.65)];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
}

+ (void)showErrorWithMessage:(NSString *)message
{
    [self setHUDColor];
    [SVProgressHUD showErrorWithStatus:message];
}

+ (void)showError:(NSError *)error
{
    [self setHUDColor];
    [SVProgressHUD showErrorWithStatus:error.localizedDescription ?: error.domain];
}

+ (void)showSuccessWithMessage:(NSString *)message
{
    [self setHUDColor];
    [SVProgressHUD showSuccessWithStatus:message];
}

+ (void)showInfoWithMessage:(NSString *)message
{
    [self setHUDColor];
    [SVProgressHUD showInfoWithStatus:message];
}

+ (void)showProgress
{
    [self setHUDColor];
    [SVProgressHUD show];
}

+ (void)hideProgress
{
    [SVProgressHUD dismiss];
}

@end
