//
//  ICMyDiscWebPageView.h
//  ICome
//
//  Created by zhangrongwu on 16/8/31.
//  Copyright © 2016年 iCom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EnnDynamicHeader.h"
@interface ICMyDiscWebPageView : UIView
@property (nonatomic, strong)UIImageView *headImageView;
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UILabel *descLabel;
@property (nonatomic, strong)NSString *url;
@property (nonatomic, strong)UILabel *fromLabel;
@property (nonatomic, copy)void (^webPageAction)(NSString *url);
@end
