//
//  ICWebPageModel.m
//  ICome
//
//  Created by zhangrongwu on 16/8/30.
//  Copyright © 2016年 iCom. All rights reserved.
//

#import "ICWebPageModel.h"

@implementation ICWebPageModel
-(instancetype)initWithMedialKeys:(NSArray *)keys {
    self = [super init];
    if (self) {
        NSDictionary *media = [keys firstObject];
        if (![ICTools isObjEmpty:media]) {
            self.photoId = media[@"k"];
            self.from  = media[@"f"];
            self.title = media[@"title"];
            self.url = media[@"u"];
            
            if (![ICTools stringEmpty:self.from]) {
//                self.fromDesc = [NSString stringWithFormat:@"来自: %@", self.from];
                self.fromDesc = self.from;
            }
        }
    }
    return self;
}

@end
