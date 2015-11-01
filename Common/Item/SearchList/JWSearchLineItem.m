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

- (instancetype)initWithLineId:(NSString *)lineId lineNumber:(NSString *)lineNumber
{
    if (self = [super init]) {
        self.lineId = lineId;
        self.lineNumber = lineNumber;
    }
    return self;
}

- (void)setFromDictionary:(NSDictionary *)dict
{
    self.lineId = dict[@"lineId"];
    self.lineNumber = [JWFormatter formatedLineNumber:dict[@"name"]];
    self.from = dict[@"startSn"];
    self.to = dict[@"endSn"];
}

@end
