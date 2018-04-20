//
//  ICDiscoverDetailViewController.h
//  ICome
//
//  Created by zhangrongwu on 16/5/12.
//  Copyright © 2016年 iCom. All rights reserved.
//  动态详细

#import "ICDynamicBaseViewController.h"
#import "ICDiscoverModel.h"
#import "EnnDynamicHeader.h"
@interface ICDiscoverDetailViewController : ICDynamicBaseViewController

@property (nonatomic, copy)void (^tableViewReloadData)(ICDiscoverModel *model, NSString *type);

@property (nonatomic, strong)NSString *findId;

@end
