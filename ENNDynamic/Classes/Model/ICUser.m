//
//  ICUser.m
//  ICome
//
//  Created by ENN on 16/3/29.
//  Copyright © 2016年 iCom. All rights reserved.
//

#import "ICUser.h"
#import "EnnDynamicHeader.h"
static ICUser *user;
@implementation ICUser

// 当前用户
+ (ICUser *)currentUser {
    if (user) {
        return user;
    }
    NSDictionary *employee = [[NSUserDefaults standardUserDefaults] valueForKey:@"currentUser"];
    user = [ICUser mj_objectWithKeyValues:employee];
    return user;
}

+ (void)releaseUser {
    user = nil;
}

+ (void)updateUserInfo {
    NSDictionary *employee = [user mj_keyValues];
    [ICUser saveCurrentUserInfor:employee];
//    [[NSUserDefaults standardUserDefaults] setObject:employee forKey:@"currentUser"];
    [ICUser releaseUser];
}


+ (void)saveCurrentUserInfor:(NSDictionary *)info {
    [ICUser releaseUser];
   
    NSMutableDictionary *employee = [[NSMutableDictionary alloc] init];
//    NSArray *keys;
//    NSInteger i, count;
//    id key, value;
//    
//    keys = [info allKeys];
//    count = [keys count];
//    for (i = 0; i < count; i++) {
//        key = [keys objectAtIndex:i];
//        value = [info objectForKey:key];
//        if ([ICTools stringEmpty:value]) {
//            value = @"";
//        }
//        [employee setValue:value forKey:key];
//    }
    

    
    id  value;
    for (NSString *key in info) {
        value = info[key];
        if ([ICTools stringEmpty:value]) {
            value = @"";
        }
        [employee setValue:value forKey:key];
    }
    
    [[NSUserDefaults standardUserDefaults] setValue:employee forKey:@"currentUser"];
}





@end
