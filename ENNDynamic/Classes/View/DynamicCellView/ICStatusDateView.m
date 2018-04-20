//
//  ICStatusDateView.m
//  ICome
//
//  Created by zhangrongwu on 16/4/13.
//  Copyright © 2016年 iCom. All rights reserved.
//

#import "ICStatusDateView.h"
#import "EnnDynamicHeader.h"
@implementation ICStatusDateView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    [self.dateLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    [self.deleteButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dateLabel.mas_right).offset(10);
        make.centerY.equalTo(self.dateLabel.mas_centerY);
    }];
    
    [self.operationButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right);
        make.centerY.equalTo(self.dateLabel.mas_centerY);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(45);
    }];
}


-(void)layoutSubviews {
    [super layoutSubviews];
    _dateLabel.font = ICTEXTFONT_T3;
    _deleteButton.titleLabel.font = ICTEXTFONT_T3;
}

- (void)deleteButtonClicked {
    if (self.deleteButtonClickedBlock) {
        self.deleteButtonClickedBlock();
    }
}

- (void)operationButtonClicked {
    if (self.operationButtonClickedBlock) {
        self.operationButtonClickedBlock();
    }
}

- (UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.textColor = ICTEXTCOLOR_T3;
        [self addSubview:_dateLabel];
    }
    return _dateLabel;
}

-(UIButton *)deleteButton {
    if (!_deleteButton) {
        _deleteButton = [[UIButton alloc] init];
        [_deleteButton setTitleColor:ICRGB(0x606F95) forState:UIControlStateNormal];
        [_deleteButton setTitle:NSLocalizedString(@"delete", nil) forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(deleteButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_deleteButton];
        _deleteButton.hidden = YES;
    }
    return _deleteButton;
}
-(UIButton *)operationButton {
    if (!_operationButton) {
        _operationButton = [[UIButton alloc] init];
        [_operationButton setImageEdgeInsets:UIEdgeInsetsMake(0,30-18.5,0, 0)];
        [_operationButton setImage:[UIImage imageNamed:@"icon_dynamic_operation"]forState:UIControlStateNormal];
        [self addSubview:_operationButton];
        [_operationButton addTarget:self action:@selector(operationButtonClicked) forControlEvents:UIControlEventTouchUpInside];

    }
    return _operationButton;
}

@end
