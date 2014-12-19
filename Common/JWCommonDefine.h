//
//  JWCommonDefine.h
//  BusRider
//
//  Created by John Wong on 12/16/14.
//  Copyright (c) 2014 John Wong. All rights reserved.
//

#ifndef BusRider_JWCommonDefine_h
#define BusRider_JWCommonDefine_h

#define kOnePixel (1 / [UIScreen mainScreen].scale)

//#define FAKE
#ifdef FAKE
#define kJWHost @"localhost:7000"
#else
#define kJWHost @"api.chelaile.net.cn:7000"
#endif

#endif
