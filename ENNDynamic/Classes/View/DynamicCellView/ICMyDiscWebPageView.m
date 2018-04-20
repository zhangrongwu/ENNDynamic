//
//  ICMyDiscWebPageView.m
//  ICome
//
//  Created by zhangrongwu on 16/8/31.
//  Copyright © 2016年 iCom. All rights reserved.
//

#import "ICMyDiscWebPageView.h"
#import "EnnDynamicHeader.h"
@implementation ICMyDiscWebPageView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //        self.layer.cornerRadius = 2;
        //        self.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
        //        self.layer.borderWidth = 1;
        //        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, frame.size.width, frame.size.height - 10)];
        bgView.backgroundColor = IColor(246,246,246);
        [self addSubview:bgView];
        
        [bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.top.equalTo(self.mas_top).offset(8);
            make.bottom.equalTo(self.mas_bottom).offset(-8);
        }];
        
        [self addSubview:self.headImageView];
        self.headImageView.userInteractionEnabled = YES;
        [self.headImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.left.equalTo(self.mas_left).offset(5);
            make.height.width.mas_equalTo(57);
        }];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.font = ICFont(14);
        [self addSubview:self.titleLabel];
        
        
        self.headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [self addSubview:self.headImageView];
        self.headImageView.userInteractionEnabled = YES;
        [self.headImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(bgView.mas_centerY);
            make.left.equalTo(self.mas_left).offset(5);
            make.height.width.mas_equalTo(30);
        }];
        
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.headImageView.mas_centerY);
            make.left.equalTo(self.headImageView.mas_right).offset(5);
            make.right.equalTo(self.mas_right).offset(-15);
        }];
        
        
        WEAKSELF;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
            if (weakSelf.webPageAction) {
                weakSelf.webPageAction(weakSelf.url);
            }
        }];
        [self addGestureRecognizer:tap];
    }
    return self;
}
@end
