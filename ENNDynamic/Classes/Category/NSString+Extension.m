//
//  NSString+Extension.m
//  ICome
//
//  Created by ENN on 16/3/12.
//  Copyright © 2016年 iCom. All rights reserved.
//

#import "NSString+Extension.h"

#define EmojiCodeToSymbol(c) ((((0x808080F0 | (c & 0x3F000) >> 4) | (c & 0xFC0) << 10) | (c & 0x1C0000) << 18) | (c & 0x3F) << 24)

@implementation NSString (Extension)

- (CGSize)sizeWithMaxWidth:(CGFloat)width andFont:(UIFont *)font
{
    CGSize maxSize = CGSizeMake(width, MAXFLOAT);
    NSDictionary *dict = @{NSFontAttributeName : font};
    NSStringDrawingOptions opts = NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading;
    if ([[ICTools getSystemVersion] floatValue] >= 9.0) {
        return [self boundingRectWithSize:maxSize
                                  options:opts
                               attributes:dict
                                  context:nil].size;
    } else { // 该方法用于8.0以下版本 - 由于8.0 boundingRectWithSize 计算空格存在偏差 所以9.0以下使用sizeWithFont
        return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    }
}

- (NSString *)jsonStringToNSStringWith:(NSString *)requests {
    NSMutableString *responseString = [NSMutableString stringWithString:requests];
    NSString *character = nil;
    for (int i = 0; i < responseString.length; i ++) {
        character = [responseString substringWithRange:NSMakeRange(i, 1)];
        if ([character isEqualToString:@"\\"]) {
            [responseString deleteCharactersInRange:NSMakeRange(i, 1)];
        } else if ([character isEqualToString:@"\""]) {
            [responseString deleteCharactersInRange:NSMakeRange(i, 1)];
        }
    }
    return responseString;
}

+ (NSString *)currentName
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYYMMddHHMMss"];
    NSString *currentDate = [dateFormatter stringFromDate:[NSDate date]];
    return currentDate;
}

+ (NSString *)currentDateYYYYMMdd
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYYMMdd"];
    NSString *currentDate = [dateFormatter stringFromDate:[NSDate date]];
    return currentDate;
}
- (BOOL)isTrimmingSpace
{
    if ([[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet] ] length] == 0) {
        return YES;
    }else{
        return NO;
    }
}

- (NSString *)emoji
{
    return [NSString emojiWithStringCode:self];
}

+ (NSString *)emojiWithStringCode:(NSString *)stringCode
{
    char *charCode = (char *)stringCode.UTF8String;
    long intCode = strtol(charCode, NULL, 16);
    return [self emojiWithIntCode:(int)intCode];
}

+ (NSString *)emojiWithIntCode:(int)intCode {
    int symbol = EmojiCodeToSymbol(intCode);
    NSString *string = [[NSString alloc] initWithBytes:&symbol length:sizeof(symbol) encoding:NSUTF8StringEncoding];
    if (string == nil) { // 新版Emoji
        string = [NSString stringWithFormat:@"%C", (unichar)intCode];
    }
    return string;
}

- (NSString *)lastStringSeparatedByString:(NSString *)separeted
{
    NSArray *list = [self componentsSeparatedByString:separeted];
    return [list lastObject];
}

- (NSString *)firstStringSeparatedByString:(NSString *)separeted
{
    NSArray *list = [self componentsSeparatedByString:separeted];
    return [list firstObject];
}

- (NSMutableArray *)regularExpressionStr
{
    NSString *pattern = @"(?<=d=)\\d+";
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSArray<NSTextCheckingResult *> *result = [regex matchesInString:self options:0 range:NSMakeRange(0, self.length)];
    __block NSMutableArray * reguleStrArray = [NSMutableArray array];
    [result enumerateObjectsUsingBlock:^(NSTextCheckingResult * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [reguleStrArray addObject:[self substringWithRange:obj.range]];
    }];
    return reguleStrArray ;
}

// 取得原文件名   filekey_orgName
- (NSString *)originName
{
    NSArray *list = [self componentsSeparatedByString:@"_"];
    NSMutableString *orgName = [NSMutableString string];
    NSUInteger count = list.count;
    if (list.count > 1) {
        for (int i = 1; i < count; i ++) {
            [orgName appendString:list[i]];
            if (i < count-1) {
                [orgName appendString:@"_"];
            }
        }
    } else {  // 防越狱的情况下，本地改名字
        orgName = list[0];
    }
    return orgName;
}

//URLEncode
+(NSString*)encodeString:(NSString*)unencodedString {
    // CharactersToBeEscaped = @":/?&=;+!@#$()~',*";
    // CharactersToLeaveUnescaped = @"[].";
    
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)unencodedString,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    
    return encodedString;
}

//URLDEcode
+(NSString *)decodeString:(NSString*)encodedString {
    NSString *decodedString  = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                                                                     (__bridge CFStringRef)encodedString,
                                                                                                                     CFSTR(""),
                                                                                                                     CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    return decodedString;
}


+ (BOOL)stringContainsEmoji:(NSString *)string
{
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar hs = [substring characterAtIndex:0];
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    if (substring.length > 1) {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
                                            returnValue = YES;
                                        }
                                    }
                                } else if (substring.length > 1) {
                                    const unichar ls = [substring characterAtIndex:1];
                                    if (ls == 0x20e3) {
                                        returnValue = YES;
                                    }
                                } else {
                                    if (0x2100 <= hs && hs <= 0x27ff) {
                                        returnValue = YES;
                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                        returnValue = YES;
                                    } else if (0x2934 <= hs && hs <= 0x2935) {
                                        returnValue = YES;
                                    } else if (0x3297 <= hs && hs <= 0x3299) {
                                        returnValue = YES;
                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                        returnValue = YES;
                                    }
                                }
                            }];
    
    return returnValue;
}

//时间戳转时间
- (NSString *)getDateWithTimestamp:(NSString *)timestamp {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    
    NSDate *originDate = [NSDate dateWithTimeIntervalSince1970:[timestamp doubleValue]/1000];
    //    NSTimeInterval originTime = [originDate timeIntervalSince1970];
    
    //    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    //    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    //    NSInteger interval = [zone secondsFromGMTForDate:date];
    //    NSDate *currentDate = [date dateByAddingTimeInterval:interval];
    //    NSTimeInterval currentTime = [currentDate timeIntervalSince1970];
    
    //    NSTimeInterval diffTime = (currentTime - originTime);
    
    //    int temp = 0;
    NSString *result;
    //    if((temp = diffTime/60/60) <= 24 ){ //24小时内
    //        result = @"今天";
    //    }
    //    else if((temp = diffTime/60/60/24) <= 1){ //隔天
    //        result = @"昨天";
    //    }
    //    else{ //更长时间
    NSString *string = [formatter stringFromDate:originDate];
    result = [NSString stringWithFormat:@"%@", string];
    //    }
    return result;
}


- (CGRect)stringWidthRectWithSize:(CGSize)size fontOfSize:(CGFloat)font{
    NSDictionary * attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:font]};
    
    return [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
}


@end
