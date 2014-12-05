//
//  JWStopInfoItem.m
//  BusRider
//
//  Created by John Wong on 12/5/14.
//  Copyright (c) 2014 John Wong. All rights reserved.
//

#import "JWStopInfoItem.h"

@implementation JWStopInfoItem

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        [self setFromDict:dict];
    }
    return self;
}

- (void)setFromDict:(NSDictionary *)dict {
    self.title = dict[@"stopName"];
    self.order = [dict[@"order"] integerValue];
}

- (NSInteger)stopRemains {
    return self.order - self.lastOrder;
}

@end
