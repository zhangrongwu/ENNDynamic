//
//  ICWebPageView.h
//  ICome
//
//  Created by zhangrongwu on 16/8/29.
//  Copyright © 2016年 iCom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICDiscoverDataController.h"
#import "ICDiscoverTableViewCellViewModel.h"
@interface ICWebPageView : UIView
@property (nonatomic, strong) ICDiscoverDataController *dataController;

@property (nonatomic, strong)UIImageView *headImageView;
@property (nonatomic, strong)UIView *bgView;
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UILabel *descLabel;
@property (nonatomic, strong)NSString *url;
@property (nonatomic, strong)UILabel *fromLabel;
@property (nonatomic, strong)ICDiscoverTableViewCellViewModel *viewModel; // 用于收藏


@property (nonatomic, copy)void (^webPageAction)(NSString *url);

@end
