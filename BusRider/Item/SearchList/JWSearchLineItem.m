//
//  JWSearchLineItem.m
//  BusRider
//
//  Created by John Wong on 1/7/15.
//  Copyright (c) 2015 John Wong. All rights reserved.
//

#import "JWSearchLineItem.h"
#import "JWFormatter.h"

@implementation JWSearchLineItem

- (void)setFromDictionary:(NSDictionary *)dict {
    self.lineId = dict[@"lineId"];
    self.lineNumber = [JWFormatter formatedLineNumber:dict[@"lineName"]];
}

@end
