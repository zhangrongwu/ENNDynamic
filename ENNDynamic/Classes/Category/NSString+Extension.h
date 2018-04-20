//
//  NSString+Extension.h
//  ICome
//
//  Created by ENN on 16/3/12.
//  Copyright © 2016年 iCom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)

- (CGSize)sizeWithMaxWidth:(CGFloat)width
                   andFont:(UIFont *)font;

- (NSString *)jsonStringToNSStringWith:(NSString *)requests;

+ (NSString *)currentName;

+ (NSString *)currentDateYYYYMMdd;

- (BOOL)isTrimmingSpace;

- (NSString *)emoji;

// 以separeted为分隔符的最后一个元素
- (NSString *)lastStringSeparatedByString:(NSString *)separeted;
- (NSString *)firstStringSeparatedByString:(NSString *)separeted;

// 匹配出eId
- (NSMutableArray *)regularExpressionStr;

// 取得原文件名   filekey_orgName
- (NSString *)originName;

+(NSString*)encodeString:(NSString*)unencodedString;
+(NSString *)decodeString:(NSString*)encodedString;

+ (BOOL)stringContainsEmoji:(NSString *)string;

- (NSString *)getDateWithTimestamp:(NSString *)timestamp;


/**
 *  计算字符串宽度(指当该字符串放在view时的自适应宽度)
 *
 *  @param size 填入预留的大小
 *  @param font 字体大小
 *
 *  @return 返回CGRect
 */
- (CGRect)stringWidthRectWithSize:(CGSize)size fontOfSize:(CGFloat)font;

@end
