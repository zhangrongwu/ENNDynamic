//
//  ICDiscoverHeaderView.m
//  ICome
//
//  Created by zhangrongwu on 16/7/5.
//  Copyright © 2016年 iCom. All rights reserved.
//

#import "ICDiscoverHeaderView.h"
#define imageHeight 70
@implementation ICDiscoverHeaderView
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, frame.size.height - 20)];
        [self addSubview:self.bgImageView];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.text = [ICUser currentUser].eName;
        self.titleLabel.textAlignment = NSTextAlignmentRight;
        self.titleLabel.font = ICFont(17);
        [self addSubview:self.titleLabel];
        
        
        self.headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imageHeight, imageHeight)];
        [self addSubview:self.headImageView];
        self.headImageView.userInteractionEnabled = YES;
        CAShapeLayer *layer = [CAShapeLayer layer];
        UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:self.headImageView.bounds];
        layer.path = path.CGPath;
        self.headImageView.layer.mask = layer;
       
        [self.headImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.bgImageView.mas_bottom).offset(5);
            make.right.equalTo(self.bgImageView.mas_right).offset(-18);
            make.height.width.mas_equalTo(imageHeight);
        }];
        
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.headImageView.mas_centerY);
            make.right.equalTo(self.headImageView.mas_left).offset(-12);
            make.width.mas_equalTo(120);
        }];
        
        WEAKSELF;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
            if ([weakSelf.delegate respondsToSelector:@selector(didClickCurrentUserHeadImage)]) {
                [weakSelf.delegate didClickCurrentUserHeadImage];
            }
        }];
        [self.headImageView addGestureRecognizer:tap];
    }
    return self;
}


@end
