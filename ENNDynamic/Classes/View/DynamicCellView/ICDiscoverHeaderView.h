//
//  ICDiscoverHeaderView.h
//  ICome
//
//  Created by zhangrongwu on 16/7/5.
//  Copyright © 2016年 iCom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EnnDynamicHeader.h"

@class ICDiscoverHeaderView;
@protocol ICDiscoverHeaderViewDelegate <NSObject>
@optional
-(void)didClickCurrentUserHeadImage;



@end
@interface ICDiscoverHeaderView : UIView

@property (nonatomic, strong)UIImageView *bgImageView;
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UIImageView *headImageView;

@property (nonatomic, weak) id <ICDiscoverHeaderViewDelegate>delegate;
@end
