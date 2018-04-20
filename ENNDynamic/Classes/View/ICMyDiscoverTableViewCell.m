//
//  ICMyDiscoverTableViewCell.m
//  ICome
//
//  Created by zhangrongwu on 16/6/24.
//  Copyright © 2016年 iCom. All rights reserved.
//

#import "ICMyDiscoverTableViewCell.h"
#import "ICMyDiscWebPageView.h"
#import "EnnDynamicHeader.h"
#define headImageWidth (65)
@interface ICMyDiscoverTableViewCell()
@property (nonatomic, assign)CGFloat headImageHeight;
@property (nonatomic, strong)ICMyDiscWebPageView *webPageView;
@end

@implementation ICMyDiscoverTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)cell reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:cell reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)layoutSubview {
    [self.sectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top);
        make.left.equalTo(self.contentView.mas_left);
        make.width.mas_equalTo(App_Frame_Width);
        if(![_viewModel.yearTime isEqualToString:@"0"])
        {
            make.height.mas_equalTo(95);
        }else{
        if (!_viewModel.hiddenCreatDate) {
            make.height.mas_equalTo(15);
        } else {
            make.height.mas_equalTo(0);
        }
        }
        
    }];
    
    [self.yearTime mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sectionView.mas_top).offset(40);
        make.left.equalTo(self.contentView.mas_left).offset(20);
        make.width.mas_equalTo(150);
        if (![_viewModel.yearTime isEqualToString:@"0"]){
        make.height.mas_equalTo(40);
        }else{
            make.height.mas_equalTo(0);
        }
    }];
   
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        if(![_viewModel.yearTime isEqualToString:@"0"])
        {
            make.centerY.equalTo(self.contentView.mas_centerY).offset(47.5);
        }else{
            if (!_viewModel.hiddenCreatDate) {
                make.centerY.equalTo(self.contentView.mas_centerY).offset(7.5);
            } else {
                make.centerY.equalTo(self.contentView.mas_centerY).offset(0);
            }
        }
        make.left.equalTo(self.contentView.mas_left).offset(20);
        make.width.mas_equalTo(85);
    }];
    
    [self.headImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sectionView.mas_bottom).offset(12);
        make.left.equalTo(self.contentView.mas_left).offset(120);
        if(self.viewModel.mediaType == [TypeDyPic integerValue] ||
           self.viewModel.mediaType == [TypeDyMPic integerValue] ||
           self.viewModel.mediaType == [TypeDyVideo integerValue]){
            make.width.mas_equalTo(headImageWidth);
        } else {
            make.width.mas_equalTo(0);
        }
        //        make.height.mas_equalTo(self.headImageHeight); // 暂时去除按比例适配高度
        make.height.mas_equalTo(headImageWidth);
    }];
    
    [self.playButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.headImageView.mas_centerX);
        make.centerY.equalTo(self.headImageView.mas_centerY);
        make.width.height.mas_equalTo(30);
    }];
    
    [self.discLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sectionView.mas_bottom).offset(13);
        make.left.equalTo(self.headImageView.mas_right).offset(8);
        make.right.equalTo(self.contentView.mas_right).offset(-20);
    }];
    
    [self.numbLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.headImageView.mas_bottom).offset(-5);
        make.left.equalTo(self.discLabel.mas_left);
        make.right.equalTo(self.contentView.mas_right).offset(-20);
    }];
    
    if (self.viewModel.mediaType == [TypeDyPicURL integerValue]) {
        [self.webPageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.sectionView.mas_bottom);
            make.left.equalTo(self.headImageView.mas_right);
            make.right.equalTo(self.contentView.mas_right).offset(-15);
            make.height.mas_equalTo(55);
        }];
    }
    
    [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (self.viewModel.mediaType == [TypeDyText integerValue]) {
            make.top.equalTo(self.discLabel.mas_bottom).offset(10);
        } else if(self.viewModel.mediaType == [TypeDyPic integerValue] ||
                  self.viewModel.mediaType == [TypeDyMPic integerValue]){
            make.top.equalTo(self.headImageView.mas_bottom).offset(10);
        } else if (self.viewModel.mediaType == [TypeDyVideo integerValue]) {
            make.top.equalTo(self.headImageView.mas_bottom).offset(10);
        } else if (self.viewModel.mediaType == [TypeDyPicURL integerValue]) {
            make.top.equalTo(self.webPageView.mas_bottom);
        }
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
}

-(void)setViewModel:(ICMyDiscoverTableViewCellViewModel *)viewModel {
    _viewModel = viewModel;
    //    self.discLabel.text = viewModel.content;
    self.discLabel.attributedText = viewModel.contentAttributedString;
    self.titleLabel.text = viewModel.createDate;
    self.numbLabel.text = @"";
    if (viewModel.mediaType == [TypeDyPic integerValue] || viewModel.mediaType == [TypeDyMPic integerValue]) {
        self.headImageView.hidden = NO;
        self.playButton.hidden = YES;
        self.webPageView.hidden = YES;
        
        NSString *URL = FILEMAXIMAGE(viewModel.pic.imageKey);
        [self.headImageView sd_setImageWithURL:[NSURL URLWithString:URL] placeholderImage:[UIImage imageWithColor:[UIColor grayColor]]];
        
        [self.headImageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
        self.headImageView.contentMode =  UIViewContentModeScaleAspectFill;
        self.headImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        self.headImageView.clipsToBounds  = YES;
        if (viewModel.mediaKeys.count > 1) {
            self.numbLabel.text = [NSString stringWithFormat:@"共%lu张", (unsigned long)viewModel.mediaKeys.count];
        } else {
            self.numbLabel.text = @"";
        }
    } else if (viewModel.mediaType == [TypeDyVideo integerValue]) {
        self.headImageView.hidden = NO;
        self.playButton.hidden = NO;
        self.webPageView.hidden = YES;
        
        NSString *URL = FILEMAXIMAGE(viewModel.video.imageKey);
        [self.headImageView sd_setImageWithURL:[NSURL URLWithString:URL] placeholderImage:[UIImage imageWithColor:[UIColor grayColor]]];
        self.headImageHeight = headImageWidth *viewModel.video.height / viewModel.video.width;
    } else if (viewModel.mediaType == [TypeDyPicURL integerValue]) {
        
        self.headImageView.hidden = YES;
        self.playButton.hidden = YES;
        self.webPageView.hidden = NO;
        
        // 图文链接
        [self.webPageView.headImageView sd_setImageWithURL:[NSURL URLWithString:MINIMAGEURL(viewModel.webPage.photoId)] placeholderImage:[UIImage imageWithColor:[UIColor lightGrayColor]]];
        self.webPageView.titleLabel.text = viewModel.webPage.title;
        self.webPageView.descLabel.text = viewModel.webPage.desc;
        self.webPageView.url = viewModel.webPage.url;
    } else if(viewModel.mediaType == [TypeDyText integerValue]) {
        _discLabel.numberOfLines = 3;
        self.headImageView.hidden = YES;
        self.playButton.hidden = YES;
        self.webPageView.hidden = YES;
    }
    
    if (viewModel.hiddenCreatDate) {
        self.titleLabel.hidden = YES;
    } else {
        self.titleLabel.hidden = NO;
    }
    
    self.yearTime.text = viewModel.yearTime;
    
    
    [self layoutSubview];
}

-(void)playButtonAction {
    WEAKSELF;
    if ([self.delegate respondsToSelector:@selector(didClickVideoPlayButtonInCell:)]) {
        [self.delegate didClickVideoPlayButtonInCell:weakSelf];
    }
}

-(UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel sizeToFit];
        _titleLabel.numberOfLines = 2;
        _titleLabel.textColor = ICRGB(0x212121);
        _titleLabel.font = ICFont(19);
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

-(UIImageView *)headImageView {
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] init];
        _headImageView.userInteractionEnabled = YES;
        [self.contentView addSubview:_headImageView];
    }
    return _headImageView;
}

-(MLLinkLabel *)discLabel {
    if (!_discLabel) {
        WEAKSELF
        //UILineBreakModeWordWrap
        _discLabel = [[MLLinkLabel alloc] init];
        _discLabel.numberOfLines = 2;
        _discLabel.font = ICFont(14);
        _discLabel.textColor = ICRGB(0x212121);
        _discLabel.dataDetectorTypes = MLDataDetectorTypeURL|MLDataDetectorTypePhoneNumber;
        _discLabel.didClickLinkBlock = ^(MLLink *link,NSString *linkText,MLLinkLabel *label) {
            if ([weakSelf.delegate respondsToSelector:@selector(didClickMLLinkLabelInCell:linkLabel:link:linkText:)]) {
                [weakSelf.delegate didClickMLLinkLabelInCell:weakSelf linkLabel:label link:link linkText:linkText];
            }
        };
        [self.contentView addSubview:_discLabel];
    }
    return _discLabel;
}
-(UILabel *)numbLabel {
    if (!_numbLabel) {
        _numbLabel = [[UILabel alloc] init];
        [_numbLabel sizeToFit];
        _numbLabel.numberOfLines = 2;
        _numbLabel.textColor = ICRGB(0x9a9a9a);
        _numbLabel.font = ICFont(11);
        [self.contentView addSubview:_numbLabel];
    }
    return _numbLabel;
}

-(UIView *)sectionView {
    if (!_sectionView) {
        _sectionView = [[UIView alloc] init];
        _sectionView.backgroundColor = BACKGROUNDCOLOR;
        [self.contentView addSubview:_sectionView];
    }
    return _sectionView;
}
-(UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        [self.contentView addSubview:_bottomView];
    }
    return _bottomView;
}
-(UIButton *)playButton {
    if (!_playButton) {
        _playButton = [[UIButton alloc] init];
        [_playButton setImage:[UIImage imageNamed:@"App_video_play"] forState:UIControlStateNormal];
        _playButton.hidden = YES;
        [_playButton addTarget:self action:@selector(playButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [self.headImageView addSubview:_playButton];
    }
    return _playButton;
}
//年
-(UILabel *)yearTime
{
    if(!_yearTime)
    {
        _yearTime = [[UILabel alloc] init];
        _yearTime.backgroundColor = BACKGROUNDCOLOR;
        _yearTime.textAlignment = NSTextAlignmentLeft;
        _yearTime.textColor = ICRGB(0x000000);
        _yearTime.font = ICFont(25);
        [self.sectionView addSubview:_yearTime];
    }
    return _yearTime;
}

-(ICMyDiscWebPageView *)webPageView {
    if (!_webPageView) {
        _webPageView = [[ICMyDiscWebPageView alloc] init];
        _webPageView.hidden = YES;
        WEAKSELF;
        _webPageView.webPageAction = ^(NSString *url) {
            if ([weakSelf.delegate respondsToSelector:@selector(didClickwebPageViewInCell:link:)]) {
                [weakSelf.delegate didClickwebPageViewInCell:weakSelf link:url];
            }
        };
        [self.contentView addSubview:_webPageView];
    }
    return _webPageView;
}

@end
