//
//  ICVideoView.h
//  ICome
//
//  Created by zhangrongwu on 16/5/10.
//  Copyright © 2016年 iCom. All rights reserved.
//  视频容器

#import <UIKit/UIKit.h>
#import "ICDiscoverTableViewCellViewModel.h"
#import "ICDiscoverDataController.h"

@interface ICVideoContainerView : UIView
@property (nonatomic, strong) ICDiscoverDataController *dataController;

@property (nonatomic, strong)UIImageView *imageView;
@property (nonatomic, strong)UIButton *playButton;
@property (nonatomic, strong)UILabel *timeLabel;
@property (nonatomic, copy) void (^cellVideoAction)();

@property (nonatomic, strong) ICDiscoverTableViewCellViewModel *model;

@end
