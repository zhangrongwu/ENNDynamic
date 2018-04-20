//
//  ICNetworkCache.m
//  ICome
//
//  Created by zhangrongwu on 16/9/14.
//  Copyright © 2016年 iCom. All rights reserved.
//

#import "ICNetworkCache.h"
#import "EnnDynamicHeader.h"

@implementation ICNetworkCache
static NSString *const NetworkResponseCache = @"NetworkResponseCache";
static YYCache *_dataCache;


+ (void)initialize
{
    _dataCache = [YYCache cacheWithName:NetworkResponseCache];
}

+ (void)saveHttpCache:(id)httpCache forKey:(NSString *)key
{
    [_dataCache setObject:httpCache forKey:key withBlock:nil];
}

+ (id)getHttpCacheForKey:(NSString *)key
{
    return [_dataCache objectForKey:key];
}

+ (NSInteger)getAllHttpCacheSize
{
    return [_dataCache.diskCache totalCost];
}

+ (void)removeAllHttpCache
{
    [_dataCache.diskCache removeObjectForKey:NetworkResponseCache];
}

@end
