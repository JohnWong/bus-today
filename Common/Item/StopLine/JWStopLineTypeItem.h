//
//  JWStopLineTypeItem.h
//  BusRider
//
//  Created by John Wong on 1/13/15.
//  Copyright (c) 2015 John Wong. All rights reserved.
//

#import "JWItem.h"


@interface JWStopLineTypeItem : NSObject

@property (nonatomic, strong) NSString *nextStop;
/**
 *  array of JWStopLineItem
 */
@property (nonatomic, strong) NSMutableArray *lineList;

- (instancetype)initWithNextStop:(NSString *)nextStop NS_DESIGNATED_INITIALIZER;

+ (NSArray *)arrayFromDictionary:(NSDictionary *)dict;

@end
