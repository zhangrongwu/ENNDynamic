//
//  NSMutableAttributedString+Extension.m
//  ICome
//
//  Created by zhangrongwu on 16/5/20.
//  Copyright © 2016年 iCom. All rights reserved.
//

#import "NSMutableAttributedString+Extension.h"
#import "EnnDynamicHeader.h"
@implementation NSMutableAttributedString (Extension)
/**
 *  set AttributedString color
 *
 *  @param str      输入字符串
 *  @param color    默认颜色
 *  @param range    需更改颜色位置
 *  @param subColor 更改的颜色
 *
 *  @return return value description
 */
-(instancetype)initWithString:(NSString *)str Color:(UIColor *)color subStrIndex:(NSRange)range subStrColor:(UIColor *)subColor {
    if (self = [super init]) {
        self = [[NSMutableAttributedString alloc] initWithString:str];
        [self addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, range.location)];
        [self addAttribute:NSForegroundColorAttributeName value:subColor range:range];
    }
    return self;
}

+(NSMutableAttributedString *)setString:(NSString *)string
                              LineSpace:(NSInteger)lineSpace
                       characterSpacing:(NSInteger)characterSpacing
                          textAlignment:(NSTextAlignment)alignment {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    if (lineSpace) {
        paragraphStyle.lineSpacing = lineSpace;
    }
    if (alignment) {
        paragraphStyle.alignment = alignment;
    }
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    if (characterSpacing) {
        [attributedString setAttributes:@{NSKernAttributeName: @(characterSpacing)}];
    }
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle
                             range:NSMakeRange(0, [string length])];
    
    return attributedString;
}

+(NSMutableAttributedString *)searchTtitle:(NSString *)title
                                       key:(NSString *)key
                                  keyColor:(UIColor *)keyColor {
    if (title == nil) {
        return [[NSMutableAttributedString alloc] init];
    }
    NSMutableAttributedString *titleStr = [[NSMutableAttributedString alloc] initWithString:title];
    NSString *copyStr = title;
    NSMutableString *xxstr = [[NSMutableString alloc] init];
    for (int index = 0; index < key.length; index ++) {
        [xxstr appendString:@"*"];
    }
    
    while ([copyStr rangeOfString:key options:NSCaseInsensitiveSearch].location != NSNotFound) {
      
        NSRange range = [copyStr rangeOfString:key options:NSCaseInsensitiveSearch];
        
        [titleStr addAttribute:NSForegroundColorAttributeName value:keyColor range:range];
        copyStr = [copyStr stringByReplacingCharactersInRange:NSMakeRange(range.location, range.length) withString:xxstr];
    }
    return titleStr;
}

+ (NSMutableAttributedString *)attributedString:(NSArray *)strings
                                         colors:(NSArray *)colors
                                          fonts:(NSArray *)fonts {
    NSString *text = [NSString string];
    for (int i = 0; i < strings.count; i++) {
        NSString *s = strings[i];
        if (nil == s || s.length == 0) {
            s = @"";
        }
        text = [text stringByAppendingString:s];
    }
    NSMutableAttributedString *atext = [[NSMutableAttributedString alloc] initWithString:text];
    CGFloat x = 0;
    for (int i = 0; i < strings.count; i++) {
        NSString *s = strings[i];
        if (nil == s || s.length == 0) {
            s = @"";
        }
        [atext addAttributes:@{NSForegroundColorAttributeName:colors[i], NSFontAttributeName:fonts[i]} range:NSMakeRange(x, s.length)];
        x += s.length;
    }

    return atext;
}

- (void)setLineSpacing:(CGFloat)height
{
    NSMutableParagraphStyle * ps = [[NSMutableParagraphStyle alloc] init];
    ps.lineSpacing = height;
    [self addAttribute:NSParagraphStyleAttributeName value:ps range:NSMakeRange(0, self.length)];
}

- (void)setAlignment:(NSTextAlignment)alignment
{
    NSMutableParagraphStyle * ps = [[NSMutableParagraphStyle alloc] init];
    ps.alignment = alignment;
    [self addAttribute:NSParagraphStyleAttributeName value:ps range:NSMakeRange(0, self.length)];
}

@end
