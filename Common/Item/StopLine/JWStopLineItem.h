//
//  JWStopLineItem.h
//  BusRider
//
//  Created by John Wong on 1/13/15.
//  Copyright (c) 2015 John Wong. All rights reserved.
//

#import "JWItem.h"


@interface JWStopLineItem : JWItem

@property (nonatomic, strong) NSString *lineId;
@property (nonatomic, strong) NSString *lineNumer;
@property (nonatomic, strong) NSString *nextStop;
@property (nonatomic, strong) NSString *from;
@property (nonatomic, strong) NSString *to;
@property (nonatomic, strong) NSString *desc;

@end
