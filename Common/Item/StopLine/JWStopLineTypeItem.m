//
//  JWStopLineTypeItem.m
//  BusRider
//
//  Created by John Wong on 1/13/15.
//  Copyright (c) 2015 John Wong. All rights reserved.
//

#import "JWStopLineTypeItem.h"
#import "JWStopLineItem.h"


@implementation JWStopLineTypeItem

- (instancetype)initWithNextStop:(NSString *)nextStop
{
    if (self = [super init]) {
        self.nextStop = nextStop;
        self.lineList = [[NSMutableArray alloc] init];
    }
    return self;
}

- (instancetype)init
{
    return [self initWithNextStop:nil];
}

+ (NSArray *)arrayFromDictionary:(NSDictionary *)dict
{
    NSArray *lineList = [JWStopLineItem arrayFromDictionaryArray:dict[@"lines"]];
    NSMutableDictionary *mutableTypeDict = [[NSMutableDictionary alloc] init];
    for (JWStopLineItem *lineItem in lineList) {
        if (!mutableTypeDict[lineItem.nextStop]) {
            mutableTypeDict[lineItem.nextStop] = [[JWStopLineTypeItem alloc] initWithNextStop:lineItem.nextStop];
        }
        JWStopLineTypeItem *typeItem = mutableTypeDict[lineItem.nextStop];
        [typeItem.lineList addObject:lineItem];
    }
    for (JWStopLineTypeItem *typeItem in mutableTypeDict.allValues) {
        [typeItem.lineList sortedArrayUsingSelector:@selector(compare:)];
    }
    NSArray *keyList = mutableTypeDict.allKeys;
    keyList = [keyList sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    return [mutableTypeDict objectsForKeys:keyList notFoundMarker:[[JWStopLineTypeItem alloc] init]];
}

@end
