//
//  NSDictionary+JSONExtemsion.h
//  ICome
//
//  Created by zhangrongwu on 16/3/23.
//  Copyright © 2016年 iCom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (JSONExtemsion)
/** 对象转字符串*/
- (NSString*)jsonString;
/** 字符串json转对象*/
+ (NSDictionary*)initWithJsonString:(NSString*)json;
// 字符串转字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonStr;
@end
