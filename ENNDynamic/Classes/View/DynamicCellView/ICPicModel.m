//
//  ICPicModel.m
//  ICome
//
//  Created by zhangrongwu on 16/5/10.
//  Copyright © 2016年 iCom. All rights reserved.
//

#import "ICPicModel.h"
#import "EnnDynamicHeader.h"
@implementation ICPicModel
-(instancetype)initWithMedialKeys:(NSArray *)keys {
    self = [super init];
    if (self) {
        if ([ICTools isObjEmpty:[keys firstObject]]) {
            return self;
        } else {
            for (NSDictionary *dict in keys) {
                
                [self.picInfoList addObject:dict];
            }
            self.imageKey = [keys firstObject][@"k"];
            self.width  = [[keys firstObject][@"w"] intValue];
            self.height = [[keys firstObject][@"h"] intValue];
        }
    }
    return self;
}

- (NSMutableArray *)picInfoList {
    if (!_picInfoList) {
        _picInfoList = [[NSMutableArray alloc] init];
    }
    return _picInfoList;
}

@end
