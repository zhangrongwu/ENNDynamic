//
//  ICProductionDynamicViewController.h
//  ICome
//
//  Created by zhangrongwu on 16/4/18.
//  Copyright © 2016年 iCom. All rights reserved.
//  添加一条动态

#import "ICDynamicBaseViewController.h"
#import "DynamicConfig.h"


@class ICProductionNewsViewController;

@interface ICProductionNewsViewController : ICDynamicBaseViewController

@property (nonatomic, assign)NewsSourceType newsType; //sourceTypeCamera = 1, sourceTypePhotoLibrary = 2,

@property (nonatomic, strong)NSString *videoPath;

@end


