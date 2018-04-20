//
//  ICVideoModel.m
//  ICome
//
//  Created by zhangrongwu on 16/6/28.
//  Copyright © 2016年 iCom. All rights reserved.
//

#import "ICVideoModel.h"
#import "ICVideoManager.h"
@implementation ICVideoModel
-(instancetype)initWithMedialKeys:(NSArray *)keys {
    self = [super init];
    if (self) {
        if (![ICTools isObjEmpty:[keys firstObject]]) {
            self.imageKey = [keys firstObject][@"id"];
            self.time   = [NSString stringWithFormat:@"%.2f", [[keys firstObject][@"t"] floatValue] / 1000];
            self.width  = [[keys firstObject][@"w"] intValue];
            self.height = [[keys firstObject][@"h"] intValue];
            self.fileKey= [keys firstObject][@"k"];
        }
        NSString *path = [[ICVideoManager shareManager] videoPathWithFileName:self.fileKey fileDir:kDiscvoerVideoPath];
//        NSString *path1 = [[ICVideoManager shareManager] receiveVideoPathWithFileKey:self.fileKey];
        self.locVideoPath = path;
    }
    return self;
}
@end
