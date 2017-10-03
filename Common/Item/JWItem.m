//
//  JWItem.m
//  BusRider
//
//  Created by John Wong on 12/17/14.
//  Copyright (c) 2014 John Wong. All rights reserved.
//

#import "JWItem.h"
#import <objc/runtime.h>


@implementation JWItem

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setFromDictionary:dict];
    }
    return self;
}

- (instancetype)init
{
    return [super init];
}

- (void)setFromDictionary:(NSDictionary *)dict {}
+ (NSArray *)arrayFromDictionaryArray:(NSArray *)array
{
    NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithCapacity:array.count];
    for (NSDictionary *dict in array) {
        id item = [[self alloc] initWithDictionary:dict];
        [mutableArray addObject:item];
    }
    return [NSArray arrayWithArray:mutableArray];
}

- (NSString *)debugDescription
{
    NSMutableString *mutableString = [NSMutableString stringWithString:super.description];
    Class c = self.class;
    unsigned int level = 0;
    while (c) {
        unsigned int count = 0;
        objc_property_t *properties = class_copyPropertyList(c, &count);

        for (unsigned int i = 0; i < count; i++) {
            objc_property_t property = properties[i];
            NSString *name = @(property_getName(property));
            // 过滤掉系统自动添加的元素
            if ([name isEqualToString:@"hash"] || [name isEqualToString:@"superclass"] || [name isEqualToString:@"description"] || [name isEqualToString:@"debugDescription"] || [name rangeOfString:@"accessibility"].location != NSNotFound || [name rangeOfString:@"isAccessibilityElement"].location != NSNotFound || [name rangeOfString:@"shouldGroupAccessibilityChildren"].location != NSNotFound || [name rangeOfString:@"classForKeyedArchiver"].location != NSNotFound) {
                continue;
            }

            id value = nil;
            @try {
                value = [self valueForKey:name];
            }
            @catch (NSException *e) {
            }
            if (!value) {
                continue;
            }
            [mutableString appendFormat:@"\n"];
            for (int i = 0; i < level; i++) {
                [mutableString appendString:@"  |"];
            }
            [mutableString appendFormat:@"%@: %@", name, value];
        }
        free(properties);
        c = class_getSuperclass(c);
        level++;
    }
    return [mutableString copy];
}

@end
