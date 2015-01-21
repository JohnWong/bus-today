//
//  JWCollectItem.m
//  BusRider
//
//  Created by John Wong on 1/11/15.
//  Copyright (c) 2015 John Wong. All rights reserved.
//

#import "JWCollectItem.h"

#define JWKeyLineId @"lineId"
#define JWKeyLineNumber @"lineNumber"
#define JWKeyFrom @"from"
#define JWKeyTo @"to"
#define JWKeyStopId @"stopId"
#define JWKeyStopName @"stopName"


@implementation JWCollectItem

- (instancetype)initWithLineId:(NSString *)lineId lineNumber:(NSString *)lineNumber from:(NSString *)from to:(NSString *)to stopId:(NSString *)stopId stopName:(NSString *)stopName {
    if (self = [super init]) {
        self.lineId = lineId;
        self.lineNumber = lineNumber;
        self.from = from;
        self.to = to;
        self.stopId = stopId;
        self.stopName = stopName;
    }
    return self;
}

#pragma mark NSCoding
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [self init]){
        self.lineId = [aDecoder decodeObjectForKey:JWKeyLineId];
        self.lineNumber = [aDecoder decodeObjectForKey:JWKeyLineNumber];
        self.from = [aDecoder decodeObjectForKey:JWKeyFrom];
        self.to = [aDecoder decodeObjectForKey:JWKeyTo];
        self.stopId = [aDecoder decodeObjectForKey:JWKeyStopId];
        self.stopName = [aDecoder decodeObjectForKey:JWKeyStopName];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.lineId forKey:JWKeyLineId];
    [aCoder encodeObject:self.lineNumber forKey:JWKeyLineNumber];
    [aCoder encodeObject:self.from forKey:JWKeyFrom];
    [aCoder encodeObject:self.to forKey:JWKeyTo];
    [aCoder encodeObject:self.stopId forKey:JWKeyStopId];
    [aCoder encodeObject:self.stopName forKey:JWKeyStopName];
}

@end
