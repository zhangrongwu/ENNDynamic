//
//  NSMutableAttributedString+Extension.h
//  ICome
//
//  Created by zhangrongwu on 16/5/20.
//  Copyright © 2016年 iCom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableAttributedString (Extension)
-(instancetype)initWithString:(NSString *)str Color:(UIColor *)color subStrIndex:(NSRange)range subStrColor:(UIColor *)subColor;

+(NSMutableAttributedString *)setString:(NSString *)string
                              LineSpace:(NSInteger)lineSpace
                       characterSpacing:(NSInteger)characterSpacing
                          textAlignment:(NSTextAlignment)alignment;

+(NSMutableAttributedString *)searchTtitle:(NSString *)title
                                       key:(NSString *)key
                                  keyColor:(UIColor *)keyColor;

+ (NSMutableAttributedString *)attributedString:(NSArray *)strings
                                         colors:(NSArray *)colors
                                          fonts:(NSArray *)fonts;

//行间距
- (void)setLineSpacing:(CGFloat)height;
//设置对其方式
- (void)setAlignment:(NSTextAlignment)alignment;

@end
