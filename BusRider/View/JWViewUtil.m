//
//  JWViewUtil.m
//  BusRider
//
//  Created by John Wong on 12/20/14.
//  Copyright (c) 2014 John Wong. All rights reserved.
//

#import "JWViewUtil.h"

@implementation JWViewUtil

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size{
    UIGraphicsBeginImageContextWithOptions(size, 0, [UIScreen mainScreen].scale);
    [color set];
    UIRectFill(CGRectMake(0, 0, size.width, size.height));
    UIImage *pureColorImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return pureColorImage;
}

+ (UIImage *)resizableImageWithColor:(UIColor *)color {
    return [[self imageWithColor:color size:CGSizeMake(1, 1)] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
}

@end
