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
#define JWKeyOrder @"order"
#define JWKeyStopName @"stopName"
#define JWKeyStopId @"stopId"
#define JWKeyItemType @"itemType"


@implementation JWCollectItem

- (instancetype)initWithLineId:(NSString *)lineId lineNumber:(NSString *)lineNumber from:(NSString *)from to:(NSString *)to stopName:(NSString *)stopName order:(NSInteger)order
{
    if (self = [super init]) {
        self.itemType = JWCollectItemTypeLine;
        self.lineId = lineId;
        self.lineNumber = lineNumber;
        self.from = from;
        self.to = to;
        self.order = order;
        self.stopName = stopName;
    }
    return self;
}

- (instancetype)initWithStopId:(NSString *)stopId stopName:(NSString *)stopName
{
    if (self = [super init]) {
        self.itemType = JWCollectItemTypeStop;
        self.stopId = stopId;
        self.stopName = stopName;
    }
    return self;
}

- (instancetype)init
{
    return [self initWithLineId:nil lineNumber:nil from:nil to:nil stopName:nil order:0];
}

#pragma mark NSCoding
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [self init]) {
        self.lineId = [aDecoder decodeObjectForKey:JWKeyLineId];
        self.lineNumber = [aDecoder decodeObjectForKey:JWKeyLineNumber];
        self.from = [aDecoder decodeObjectForKey:JWKeyFrom];
        self.to = [aDecoder decodeObjectForKey:JWKeyTo];
        self.order = [[aDecoder decodeObjectForKey:JWKeyOrder] integerValue];
        self.stopName = [aDecoder decodeObjectForKey:JWKeyStopName];
        self.stopId = [aDecoder decodeObjectForKey:JWKeyStopId];
        self.itemType = [aDecoder decodeIntegerForKey:JWKeyItemType];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.lineId forKey:JWKeyLineId];
    [aCoder encodeObject:self.lineNumber forKey:JWKeyLineNumber];
    [aCoder encodeObject:self.from forKey:JWKeyFrom];
    [aCoder encodeObject:self.to forKey:JWKeyTo];
    [aCoder encodeObject:@(self.order) forKey:JWKeyOrder];
    [aCoder encodeObject:self.stopName forKey:JWKeyStopName];
    [aCoder encodeObject:self.stopId forKey:JWKeyStopId];
    [aCoder encodeInteger:self.itemType forKey:JWKeyItemType];
}

- (void)setFromDictionary:(NSDictionary *)dict
{
    self.lineId = dict[@"lineId"];
    self.lineId = dict[@"lineId"];
    self.lineNumber = dict[@"lineNumber"];
    self.from = dict[@"from"];
    self.to = dict[@"to"];
    self.order = [dict[@"order"] integerValue];
    self.stopName = dict[@"stopName"];
    self.stopId = dict[@"stopId"];
    self.itemType = [dict[@"itemType"] integerValue];
}

- (NSDictionary *)toDictionary
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"lineId"] = self.lineId;
    dict[@"lineNumber"] = self.lineNumber;
    dict[@"from"] = self.from;
    dict[@"to"] = self.to;
    dict[@"order"] = @(self.order);
    dict[@"stopName"] = self.stopName;
    dict[@"stopId"] = self.stopId;
    dict[@"itemType"] = @(self.itemType);
    return [dict copy];
}

- (BOOL)isEqual:(id)object
{
    if ([object isKindOfClass:self.class]) {
        typeof(self) item = object;
        return [self.lineId isEqualToString:item.lineId] &&
            [self.lineNumber isEqualToString:item.lineNumber] &&
            [self.from isEqualToString:item.from] &&
            [self.to isEqualToString:item.to] &&
            self.order == item.order &&
            [self.stopName isEqualToString:item.stopName];
    }
    return NO;
}

@end
