//
//  JWCollectItem.m
//  BusRider
//
//  Created by John Wong on 1/11/15.
//  Copyright (c) 2015 John Wong. All rights reserved.
//

#import "JWCollectItem.h"

#define JWKeyLineId         @"lineId"
#define JWKeyLineNumber     @"lineNumber"
#define JWKeyFrom           @"from"
#define JWKeyTo             @"to"
#define JWKeyOrder          @"order"
#define JWKeyStopName       @"stopName"


@implementation JWCollectItem

- (instancetype)initWithLineId:(NSString *)lineId lineNumber:(NSString *)lineNumber from:(NSString *)from to:(NSString *)to stopName:(NSString *)stopName order:(NSInteger)order {
    if (self = [super init]) {
        self.lineId = lineId;
        self.lineNumber = lineNumber;
        self.from = from;
        self.to = to;
        self.order = order;
        self.stopName = stopName;
    }
    return self;
}

- (instancetype)init {
    return [self initWithLineId:nil lineNumber:nil from:nil to:nil stopName:nil order:0];
}

#pragma mark NSCoding
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [self init]){
        self.lineId = [aDecoder decodeObjectForKey:JWKeyLineId];
        self.lineNumber = [aDecoder decodeObjectForKey:JWKeyLineNumber];
        self.from = [aDecoder decodeObjectForKey:JWKeyFrom];
        self.to = [aDecoder decodeObjectForKey:JWKeyTo];
        self.order = [[aDecoder decodeObjectForKey:JWKeyOrder] integerValue];
        self.stopName = [aDecoder decodeObjectForKey:JWKeyStopName];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.lineId forKey:JWKeyLineId];
    [aCoder encodeObject:self.lineNumber forKey:JWKeyLineNumber];
    [aCoder encodeObject:self.from forKey:JWKeyFrom];
    [aCoder encodeObject:self.to forKey:JWKeyTo];
    [aCoder encodeObject:@(self.order) forKey:JWKeyOrder];
    [aCoder encodeObject:self.stopName forKey:JWKeyStopName];
}

@end
