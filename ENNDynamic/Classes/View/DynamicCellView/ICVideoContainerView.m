//
//  ICVideoView.m
//  ICome
//
//  Created by zhangrongwu on 16/5/10.
//  Copyright © 2016年 iCom. All rights reserved.
//

#import "ICVideoContainerView.h"
#import "ICMediaManager.h"
#import "ICVideoManager.h"
@interface ICVideoContainerView() {
    UIMenuItem *_collectMenuItem;
}
@property (nonatomic, strong)CAShapeLayer *progressLayer;

@end
@implementation ICVideoContainerView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatSubViews];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        [self.imageView addGestureRecognizer:longPress];
    }
    return self;
}
-(void)setModel:(ICDiscoverTableViewCellViewModel *)model {
    _model = model;
    CGFloat spacing = 10;
    if (model.mediaType == [TypeDyVideo integerValue]) {
        model.locVideoPath  = [[ICVideoManager shareManager] receiveVideoPathWithFileKey:model.video.fileKey];
        NSString *URL = [NSString stringWithFormat:@"%@", model.video.imageKey];
        [_imageView sd_setImageWithURL:[NSURL URLWithString:FILEMAXIMAGE(URL)] placeholderImage:[UIImage imageWithColor:[UIColor grayColor]]];
        
        CGFloat height = videoImageView_Width * model.video.height / model.video.width + spacing;
        _imageView.frame = CGRectMake(0, spacing, videoImageView_Width, height);
        _imageView.hidden = NO;
        _playButton.hidden = NO;
        self.model.videoContainerHeight  = height + 25;
    } else {
        self.model.videoContainerHeight = 0;
        _imageView.hidden = YES;
    }
    self.timeLabel.text = model.video.time;
}

-(void)creatSubViews {
    _imageView = [[UIImageView alloc] init];
    _imageView.userInteractionEnabled = YES;
    _imageView.image = [UIImage imageNamed:@"icon_discover_default"];
    _imageView.hidden = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        if (self.cellVideoAction) {
            self.cellVideoAction();
        }
    }];
    [_imageView addGestureRecognizer:tap];
    [self addSubview:_imageView];
    
    [self.playButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.imageView.mas_centerX);
        make.centerY.equalTo(self.imageView.mas_centerY);
    }];
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.font = ICTEXTFONT_T3;
    _timeLabel.textColor = ICTEXTCOLOR_T3;
    _timeLabel.textAlignment = NSTextAlignmentRight;
    [self.imageView addSubview:_timeLabel];
}


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
        [self showMenuViewController:self.imageView];
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
//    self.model.video.width
//    self.model.video.height
//    self.model.video.time
    NSString *t = [NSString stringWithFormat:@"%d", [self.model.video.time intValue] * 1000];
    NSDictionary *dic = @{@"w":@(self.model.video.width),
                          @"h":@(self.model.video.height),
                          @"t":t,
                          @"id":self.model.video.imageKey};
    
    NSString *lnk = [dic jsonString];
    NSString * photoId = ![ICTools stringEmpty:self.model.photoId] ? self.model.photoId:[NSString stringWithFormat:@"eId:%@",self.model.eId];

    // 收藏该视频
    [self.dataController addFavoriteWithType:TypeVideo
                                         eId:[ICUser currentUser].eId
                                         gId:self.model.findId
                                     photoId:photoId
                                       title:self.model.eName
                                         txt:@"[视频]"
                                         key:self.model.video.fileKey
                                         lnk:lnk
                                       msgId:self.model.video.fileKey
                                    Callback:^(NSError *error) {
                                        if (!error) {
                                            [MBProgressHUD showSuccess:@"收藏成功"];
                                        } else {
                                            [MBProgressHUD showError:error.domain];
                                        }
                                    }];
}


-(void)layoutSubviews {
    [super layoutSubviews];
}

-(UIButton *)playButton {
    if (!_playButton) {
        _playButton = [[UIButton alloc] init];
        [_playButton setImage:[UIImage imageNamed:@"App_video_play"] forState:UIControlStateNormal];
        [self.imageView addSubview:_playButton];
    }
    return _playButton;
}


@end




