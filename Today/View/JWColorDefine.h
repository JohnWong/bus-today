//
//  JWColorDefine.h
//  BusRider
//
//  Created by John Wong on 12/10/14.
//  Copyright (c) 2014 John Wong. All rights reserved.
//

#ifndef BusRider_JWColorDefine_h
#define BusRider_JWColorDefine_h

// color macro
#define HEXCOLORA(rgbValue, a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0 blue:((float)(rgbValue & 0xFF)) / 255.0 alpha:a]
#define HEXCOLOR(rgbValue) HEXCOLORA(rgbValue, 1.0)

// predefined color
#define kJWMajorColor [UIColor whiteColor]
#define kJWMinorColor HEXCOLOR(0xA3A6AE)
#define kJWBorderColor HEXCOLOR(0xcccccc)

#define kJWTintColor HEXCOLOR(0x007aff)

#endif
