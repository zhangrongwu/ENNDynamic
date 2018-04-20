//
//  ICWebPageView.m
//  ICome
//
//  Created by zhangrongwu on 16/8/29.
//  Copyright © 2016年 iCom. All rights reserved.
//

#import "ICWebPageView.h"
#import "ICWebPageModel.h"

@interface ICWebPageView() {
    UIMenuItem * _collectMenuItem;
}
@property (nonatomic, strong)ICWebPageModel *model;

@end
@implementation ICWebPageView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self bgView];
        [self layoutSubview];
        WEAKSELF;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
            if (weakSelf.webPageAction) {
                weakSelf.webPageAction(weakSelf.url);
            }
        }];
        [self addGestureRecognizer:tap];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
        [self addGestureRecognizer:longPress];
        
    }
    return self;
}
/******************************************* UIMenuItem 标配 *******************************************************/
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (action == @selector(collectContent:)) {
        return YES;
    }
    return  [super canPerformAction:action withSender:sender];
}
- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)longPress:(UILongPressGestureRecognizer *)longRecognizer {
    if (longRecognizer.state == UIGestureRecognizerStateBegan) {
        [self showMenuViewController:self.bgView];
    }
}

- (void)showMenuViewController:(UIView *)showInView {
    [self becomeFirstResponder];
    [[UIMenuController sharedMenuController] update];
    if (!_collectMenuItem) {
        _collectMenuItem   = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"favorites", nil) action:@selector(collectContent:)];
    }
    [[UIMenuController sharedMenuController] setMenuItems:@[_collectMenuItem]];
    [[UIMenuController sharedMenuController] setTargetRect:showInView.frame inView:showInView.superview];
    [[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];
}

- (void)collectContent:(UIMenuItem *)collectContent {
    NSDictionary *dic = @{@"filekey":self.model.photoId,
                          @"summary":self.model.title,
                          @"source":self.model.from};
   
    NSString *key = [dic jsonString];
    NSString * photoId = ![ICTools stringEmpty:self.viewModel.photoId] ? self.viewModel.photoId:[NSString stringWithFormat:@"eId:%@",self.viewModel.eId];

    // 收藏该文章
    [self.dataController addFavoriteWithType:TypePicText
                                         eId:[ICUser currentUser].eId
                                         gId:self.viewModel.findId
                                     photoId:photoId
                                       title:self.viewModel.eName
                                         txt:self.model.title
                                         key:key
                                         lnk:self.model.url
                                       msgId:self.model.url
                                    Callback:^(NSError *error) {
                                        if (!error) {
                                            [MBProgressHUD showSuccess:@"收藏成功"];
                                        } else {
                                            [MBProgressHUD showError:error.domain];
                                        }
                                    }];
}

-(void)setViewModel:(ICDiscoverTableViewCellViewModel *)viewModel {
    _viewModel = viewModel;
    self.model = viewModel.webPage;
}


-(void)setModel:(ICWebPageModel *)model {
    _model = model;
    
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:FILEMAXIMAGE(model.photoId)] placeholderImage:[UIImage imageNamed:@"icon_web_page"]];
    self.titleLabel.text = model.title;
    self.descLabel.text = model.desc;
    self.fromLabel.text = model.fromDesc;
    self.url = model.url;
    
    [self layoutSubview];
}

-(void)layoutSubview {
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(8);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.mas_equalTo(50);
    }];
    
    [self.headImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bgView.mas_centerY);
        make.left.equalTo(self.mas_left).offset(5);
        make.height.width.mas_equalTo(40);
    }];
    
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.headImageView.mas_centerY);
        make.left.equalTo(self.headImageView.mas_right).offset(10);
        make.right.equalTo(self.mas_right).offset(-15);
    }];
    
    [self.fromLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView.mas_bottom).offset(8);
        make.left.equalTo(self.mas_left);
    }];
}


-(UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.numberOfLines = 2;
        _titleLabel.font = ICFont(14);
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

-(UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = IColor(246,246,246);
        [self addSubview:_bgView];
    }
    return _bgView;
}

-(UIImageView *)headImageView {
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] init];
        _headImageView.userInteractionEnabled = YES;
        [self addSubview:_headImageView];
    }
    return _headImageView;
}

-(UILabel *)fromLabel {
    if (!_fromLabel) {
        _fromLabel = [[UILabel alloc] init];
        _fromLabel.font = ICFont(11);
        _fromLabel.textColor = ICRGB(0x606f95);
        [self addSubview:_fromLabel];
    }
    return _fromLabel;
}

@end
