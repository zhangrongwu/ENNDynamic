//
//  ICCellOperationView.m
//  ICome
//
//  Created by zhangrongwu on 16/4/13.
//  Copyright © 2016年 iCom. All rights reserved.
//

#import "ICStatusOperationView.h"
#import "EnnDynamicHeader.h"

#define LIKEMENUWIDTH (145)
@interface ICStatusOperationView ()

@end
@implementation ICStatusOperationView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
        
    }
    return self;
}

- (void)setup
{
    self.clipsToBounds = YES; // 覆盖父视图
    self.layer.cornerRadius = 5;
    self.backgroundColor = IColor(69, 74, 76);
    
    _likeButton = [self creatButtonWithTitle:@"赞" image:[UIImage imageNamed:@"icon_dynamic_support"] selImage:[UIImage imageNamed:@""] target:self selector:@selector(likeButtonClicked)];
    _commentButton = [self creatButtonWithTitle:@"评论" image:[UIImage imageNamed:@"icon_dynamic_commit"] selImage:[UIImage imageNamed:@""] target:self selector:@selector(commentButtonClicked)];
    
    UIView *centerLine = [[UIView alloc] init];
    centerLine.backgroundColor = [UIColor grayColor];
    
    [self sd_addSubviews:@[_likeButton, _commentButton, centerLine]];
    
    CGFloat margin = 5;
    [self.likeButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left).offset(margin);
        make.width.mas_equalTo((LIKEMENUWIDTH - 5 * 4) / 2);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    [centerLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.likeButton.mas_top);
        make.left.equalTo(self.likeButton.mas_right).offset(margin);
        make.width.mas_equalTo(1);
        make.bottom.equalTo(self.likeButton.mas_bottom);
    }];
    
    [self.commentButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(centerLine.mas_left).offset (margin);
        make.width.mas_equalTo((LIKEMENUWIDTH - 5 * 4) / 2);
        make.bottom.equalTo(self.mas_bottom);
    }];
}

- (void)sd_addSubviews:(NSArray *)subviews {
    [subviews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        if ([view isKindOfClass:[UIView class]]) {
            [self addSubview:view];
        }
    }];
}

- (UIButton *)creatButtonWithTitle:(NSString *)title image:(UIImage *)image selImage:(UIImage *)selImage target:(id)target selector:(SEL)sel
{
    UIButton *btn = [[UIButton alloc] init];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setImage:selImage forState:UIControlStateSelected];
    [btn addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = ICFont(14);
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 3, 0, 0);
    return btn;
}

- (void)likeButtonClicked
{
    if (self.likeButtonClickedOperation) {
        self.likeButtonClickedOperation();
    }
}

- (void)commentButtonClicked
{
    if (self.commentButtonClickedOperation) {
        self.commentButtonClickedOperation();
    }
    self.show = NO;
}

- (void)setShow:(BOOL)show
{
    _show = show;
    self.alpha = 1;
    [UIView animateWithDuration:0.2 animations:^{
        if (!show) {
            self.width = 0;
            self.x = App_Frame_Width - (45);
            [UIView animateWithDuration:1 animations:^{
                self.alpha = 0;
            }];
        } else {
            self.width = LIKEMENUWIDTH;
            self.x = App_Frame_Width - (45) - LIKEMENUWIDTH;
        }
    }];
}

@end
