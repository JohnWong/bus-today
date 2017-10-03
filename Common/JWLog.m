//
//  JWLog.m
//  BusRider
//
//  Created by John Wong on 11/1/15.
//  Copyright © 2015 John Wong. All rights reserved.
//

#import <Foundation/Foundation.h>

// NSLog
#ifdef DEBUG
static NSString *convertUnicodeCharEscapes(NSString *source)
{
    const NSInteger MAX_UNICHAR_LEN = 100;
    NSInteger lenSource = source.length;
    unichar unicharBuf[MAX_UNICHAR_LEN]; // 一次最多转100个
    NSMutableString *dest = [[NSMutableString alloc] initWithCapacity:lenSource];
    NSInteger i = 0, copyStart = 0, slashPos = -2, escapeIndex = -1, escapePow = 0, escapeCharIndex = 0, escapeCharValue = 0;

    while (i < lenSource) {
        unichar c = [source characterAtIndex:i];
        if (escapeIndex >= 0) {
            if (escapeIndex == 3) {
                escapeCharValue = 0;
                escapePow = 16 * 16 * 16;
            }

            // 16进制转换
            if (c >= '0' && c <= '9')
                escapeCharValue += escapePow * (c - '0');
            else if (c >= 'a' && c <= 'f')
                escapeCharValue += escapePow * (c - 'a' + 10);
            else {
                // someting wrong
                if (escapeCharIndex > 0)
                    [dest appendString:[[NSString alloc] initWithCharactersNoCopy:unicharBuf length:escapeCharIndex freeWhenDone:NO]];
                copyStart = i - (5 - escapeIndex);
                escapeIndex = -1;
                i++;
                continue;
            }

            if (escapeIndex == 0) {
                unicharBuf[escapeCharIndex] = (unichar)escapeCharValue;
                copyStart = i + 1;
                // 判断接下来还是不是\U
                if (escapeCharIndex < MAX_UNICHAR_LEN - 1 && i < lenSource - 2 && [source characterAtIndex:i + 1] == '\\' && [source characterAtIndex:i + 2] == 'U') {
                    escapeCharIndex++;
                    escapeIndex = 3;
                    i += 2;
                } else {
                    escapeIndex = -1;
                    [dest appendString:[[NSString alloc] initWithCharactersNoCopy:unicharBuf length:escapeCharIndex + 1 freeWhenDone:NO]];
                }
            } else {
                escapeIndex--;
                escapePow /= 16;
            }
        } else if (c == '\\') {
            slashPos = i;
        } else if (c == 'U') {
            if (slashPos == i - 1) {
                escapeIndex = 3;
                escapeCharIndex = 0;
                if (i - 2 - copyStart + 1 > 0) {
                    [dest appendString:[source substringWithRange:NSMakeRange(copyStart, i - 2 - copyStart + 1)]];
                    copyStart = i - 1;
                }
            }
        }
        i++;
    }

    if (copyStart == 0)
        return source;
    else if (lenSource - copyStart > 0)
        [dest appendString:[source substringWithRange:NSMakeRange(copyStart, lenSource - copyStart)]];
    return dest;
}

static void _NSLog(id NIL, ...)
{
    va_list args;
    va_start(args, NIL);
    NSLogv(@"%@", args);
    va_end(args);
}

void NSLog(NSString *format, ...)
{
    va_list args;
    va_start(args, format);
    NSString *logString = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    logString = convertUnicodeCharEscapes(logString);
    _NSLog(nil, logString);
}
#endif
