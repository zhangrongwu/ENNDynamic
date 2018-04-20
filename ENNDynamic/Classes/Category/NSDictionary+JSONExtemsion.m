//
//  NSDictionary+JSONExtemsion.m
//  ICome
//
//  Created by zhangrongwu on 16/3/23.
//  Copyright © 2016年 iCom. All rights reserved.
//

#import "NSDictionary+JSONExtemsion.h"

@implementation NSDictionary (JSONExtemsion)

- (NSString*)jsonString
{
    NSData* infoJsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil];
    NSString* json = [[NSString alloc] initWithData:infoJsonData encoding:NSUTF8StringEncoding];
    return json;
}

+ (NSDictionary*)initWithJsonString:(NSString*)json
{
    if ([ICTools stringEmpty:json]) {
        return nil;
    }
    NSData* infoData = [json dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary* info = [NSJSONSerialization JSONObjectWithData:infoData options:0 error:nil];
    return info;
}

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonStr
{
    if (jsonStr == nil) {
        return nil;
    }
    NSData* jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                               options:NSJSONReadingMutableContainers
                                                                 error:&err];
    if (err) {
        NSLog(@"json serialize failue");
        return nil;
    }
    return dic;
}

@end
