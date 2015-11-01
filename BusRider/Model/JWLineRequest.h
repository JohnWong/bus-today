//
//  JWLineRequest.h
//  BusRider
//
//  Created by John Wong on 12/30/14.
//  Copyright (c) 2014 John Wong. All rights reserved.
//

#import "JWRequest.h"


@interface JWLineRequest : JWRequest

@property (nonatomic, strong) NSString *lineId;
@property (nonatomic, assign) NSInteger targetOrder;

@end
