//
//  ICUploadPhotoCollectionViewCell.m
//  ICome
//
//  Created by zhangrongwu on 16/4/18.
//  Copyright © 2016年 iCom. All rights reserved.
//

#import "ICUploadPhotoCollectionViewCell.h"
#import "EnnDynamicHeader.h"
@implementation ICUploadPhotoCollectionViewCell
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self layoutSubview];
    }
    return self;
}

-(void)layoutSubview {
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
        make.width.equalTo(self.mas_width);
        make.height.equalTo(self.mas_height);
    }];
    
    self.progressLayer.center = CGPointMake(self.width / 2, self.height / 2);
    
    [self.canclelBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
    }];
}


-(UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.layer.masksToBounds = YES;
        _imageView.image = [UIImage imageNamed:@"icon_discover_add"];
        [self.contentView addSubview:_imageView];
    }
    return _imageView;
}
-(CAShapeLayer *)progressLayer {
    if (!_progressLayer) {
        _progressLayer = [CAShapeLayer layer];
        _progressLayer.size = CGSizeMake(40, 40);
        _progressLayer.cornerRadius = 20;
        _progressLayer.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.500].CGColor;
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(_progressLayer.bounds, 7, 7) cornerRadius:(40 / 2 - 7)];
        _progressLayer.path = path.CGPath;
        _progressLayer.fillColor = [UIColor clearColor].CGColor;
        _progressLayer.strokeColor = [UIColor whiteColor].CGColor;
        _progressLayer.lineWidth = 4;
        _progressLayer.lineCap = kCALineCapRound;
        _progressLayer.strokeStart = 0;
        _progressLayer.strokeEnd = 0;
        _progressLayer.hidden = YES;
        [self.layer addSublayer:_progressLayer];
    }
    return _progressLayer;
}

- (UIButton *)canclelBtn {
    if (!_canclelBtn) {
        _canclelBtn = [[UIButton alloc] init];
        [_canclelBtn setImage:[UIImage imageNamed:@"icon_discover_cancel"] forState:UIControlStateNormal];
        [_canclelBtn addTarget:self action:@selector(cancleBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_canclelBtn];
    }
    return _canclelBtn;
}

- (void)cancleBtnAction {
    WEAKSELF;
    if ([self.delegate respondsToSelector:@selector(didClickCanclelButtonInCell:)]) {
        [self.delegate didClickCanclelButtonInCell:weakSelf];
    }
}
- (void)layoutSubviews{
    [super layoutSubviews];
}

@end
