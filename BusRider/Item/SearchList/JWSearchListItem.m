//
//  JWSearchListItem.m
//  BusRider
//
//  Created by John Wong on 1/7/15.
//  Copyright (c) 2015 John Wong. All rights reserved.
//

#import "JWSearchListItem.h"
#import "JWSearchLineItem.h"
#import "JWSearchStopItem.h"

@implementation JWSearchListItem

- (void)setFromDictionary:(NSDictionary *)dict {
    self.lineList = [JWSearchLineItem arrayFromDictionary:dict[@"linelist"]];
    self.stopList = [JWSearchStopItem arrayFromDictionary:dict[@"stoplist"]];
}

@end
