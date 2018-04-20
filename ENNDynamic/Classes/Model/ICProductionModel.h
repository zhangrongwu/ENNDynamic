//
//  ICProductionModel.h
//  ICome
//
//  Created by zhangrongwu on 16/7/12.
//  Copyright © 2016年 iCom. All rights reserved.
//  发送动态

#import <Foundation/Foundation.h>

@interface ICProductionModel : NSObject
@property (nonatomic, strong)NSString *videoKey;
@property (nonatomic, strong)NSString *videoName;

@property (nonatomic, strong)NSString *picKey;
@property (nonatomic, strong)NSString *picName;
@property (nonatomic, strong)UIImage *image;
@property (nonatomic, assign)BOOL hide;
@property (nonatomic, assign)BOOL Plus;

@end
