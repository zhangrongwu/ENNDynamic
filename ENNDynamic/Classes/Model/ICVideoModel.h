//
//  ICVideoModel.h
//  ICome
//
//  Created by zhangrongwu on 16/6/28.
//  Copyright © 2016年 iCom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ICVideoModel : NSObject

@property (nonatomic, strong)NSString *imageKey;
@property (nonatomic, assign) int width; // pic width
@property (nonatomic, assign) int height; //< pic height

@property (nonatomic, strong)NSString *time; // 视频时长
@property (nonatomic, strong)NSString *fileKey; // 视频key
@property (nonatomic, strong)NSString *locVideoPath; // 本地视频路径

-(instancetype)initWithMedialKeys:(NSArray *)keys;
@end
