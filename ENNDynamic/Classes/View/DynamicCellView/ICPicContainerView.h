//
//  ICPicContainerView.h
//  ICome
//
//  Created by zhangrongwu on 16/4/13.
//  Copyright © 2016年 iCom. All rights reserved.
//  图片容器

#import <UIKit/UIKit.h>
#import "ICDiscoverTableViewCellViewModel.h"
#import "ICDiscoverDataController.h"

@interface ICPicContainerView : UIView
@property (nonatomic, strong) ICDiscoverDataController *dataController;

@property (nonatomic, strong) NSArray *picViews;

@property (nonatomic, copy) void (^cellImageTapAction)(NSInteger index);

@property (nonatomic, strong) ICDiscoverTableViewCellViewModel *model;

@end

