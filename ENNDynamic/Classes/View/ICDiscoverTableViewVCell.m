//
//  ICDiscoverTableViewVCell.M
//  ICome
//
//  Created by zhangrongwu on 16/6/17.
//  Copyright © 2016年 iCom. All rights reserved.
//

#import "ICDiscoverTableViewVCell.h"
#import "ZacharyPlayManager.h"
#import "UIImage+AvatarGeneration.h"
#define ICCellTopMargin 15      // cell 顶部灰色留白
#define ICCellNameTopContent 10      // cell 顶部灰色留白
#define ICCellBottomMargin 15 // cell 底部灰色留白

#define ICCellPadding 9       // cell 内边距
#define ICCellNamePaddingLeft 10 // cell 名字和 avatar 之间留白
#define ICCellNamePaddingCenter 14 // cell 名字和 avatar 之间留白
@interface ICDiscoverTableViewVCell (){
    UIMenuItem * _copyMenuItem;
    UIMenuItem * _collectMenuItem;
    NSInteger  cllcount;
}
@property (nonatomic, assign)CGFloat praise_commentHeight;
@property (nonatomic,strong)UIView *bottomLineView;
@end
@implementation ICDiscoverTableViewVCell
- (instancetype)initWithStyle:(UITableViewCellStyle)cell reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:cell reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveOperationButtonClickedNotification:) name:@"CellOperationButtonClickedNotification" object:nil];
    }
    return self;
}


-(UIButton *)contentLabelAllbutton
{
    if(!_contentLabelAllbutton)
    {
        _contentLabelAllbutton = [[UIButton alloc] init];
        [_contentLabelAllbutton setTitleColor:ICRGB(0x5f6f95) forState:UIControlStateNormal];
        _contentLabelAllbutton.titleLabel.font = ICFont(15);
        //_contentLabelAllbutton.hidden = NO;
        _contentLabelAllbutton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_contentLabelAllbutton addTarget:self action:@selector(contentAllbutton) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_contentLabelAllbutton];
    }
    return _contentLabelAllbutton;
}

-(void)contentAllbutton
{
    self.contentLabelAllbutton.hidden = YES;
    self.contentLabel.numberOfLines = 0;
    if ([self.delegate respondsToSelector:@selector(didClickcontentAllButtonInCell:)]) {
        [self.delegate didClickcontentAllButtonInCell:self];
    }
    NSLog(@"contentAllbutton");
}

- (void)setup {
    WEAKSELF
    _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 6, ContactHeadImageHeight, ContactHeadImageHeight)];
    _headImageView.userInteractionEnabled = YES;
    
    // 内切圆
    CAShapeLayer *layer = [CAShapeLayer layer];
    UIBezierPath *apath = [UIBezierPath bezierPathWithOvalInRect:_headImageView.bounds];
    layer.path = apath.CGPath;
    _headImageView.layer.mask = layer;
    
    
    UITapGestureRecognizer *headimageTap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        if ([weakSelf.delegate respondsToSelector:@selector(didClickHeadImageInCell:)]) {
            [weakSelf.delegate didClickHeadImageInCell:weakSelf];
        }
    }];
    [_headImageView addGestureRecognizer:headimageTap];
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.font = ICFont(15);
    _nameLabel.textColor = ICRGB(0x5f6f95);
    _nameLabel.lineBreakMode = NSLineBreakByClipping;
    _nameLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *nameTap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        if ([weakSelf.delegate respondsToSelector:@selector(didClicktitleLabelInCell:)]) {
            [weakSelf.delegate didClicktitleLabelInCell:weakSelf];
        }
    }];
    [_nameLabel addGestureRecognizer:nameTap];
    
    _contentLabel = [[MLLinkLabel alloc] init];
    _contentLabel.numberOfLines = 7;
    _contentLabel.font = ICFont(15);
    _contentLabel.textColor = ICRGB(0x212121);
    _contentLabel.preferredMaxLayoutWidth = DiscContentWidth;
    _contentLabel.dataDetectorTypes = MLDataDetectorTypeURL|MLDataDetectorTypePhoneNumber;
    
    _contentLabel.didClickLinkBlock = ^(MLLink *link,NSString *linkText,MLLinkLabel *label) {
        if ([weakSelf.delegate respondsToSelector:@selector(didClickMLLinkLabelInCell:linkLabel:link:linkText:)]) {
            [weakSelf.delegate didClickMLLinkLabelInCell:weakSelf linkLabel:label link:link linkText:linkText];
        }
    };
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
    [self.contentLabel addGestureRecognizer:longPress];
    
    _dateView = [[ICStatusDateView alloc] initWithFrame:CGRectZero];
    
    _commentView = [[ICPraise_CommentView alloc] initWithFrame:CGRectZero];
    // mllabel 点击评论的名字
    _commentView.MLTapClickInLabelBlock = ^(MLLink *link, NSString *linkText, MLLinkLabel *label) {
        if ([weakSelf.delegate respondsToSelector:@selector(didClickMLLinkLabelInCell:linkLabel:link:linkText:)]) {
            [weakSelf.delegate didClickMLLinkLabelInCell:weakSelf linkLabel:label link:link linkText:linkText];
        }
    };
    
    [_commentView setMoreButtonClickedBlock:^{
        if ([weakSelf.delegate respondsToSelector:@selector(didClickMoreButtonInCell:)]) {
            [weakSelf.delegate didClickMoreButtonInCell:weakSelf];
        }
    }];
    // 点击评论cell
    _commentView.CommentCellClickBlock = ^(NSIndexPath *indexPath, ICCommentModel *model, ICDiscoverCellPraise_CommentCell *cell) {
        if ([weakSelf.delegate respondsToSelector:@selector(didClickCommentCellInCell:commentCell:indexPath:commentModel:)]) {
            [weakSelf.delegate didClickCommentCellInCell:weakSelf commentCell:cell indexPath:indexPath commentModel:model];
        }
    };
    // 删除评论
    _commentView.DeleteCommentBlock = ^(ICCommentModel *model) {
        if ([weakSelf.delegate respondsToSelector:@selector(deleteComment:InCell:)]) {
            [weakSelf.delegate deleteComment:model InCell:weakSelf];
        }
    };
    // 回复评论
    _commentView.ReplyCommentBlock = ^(ICCommentModel *model) {
        if ([weakSelf.delegate respondsToSelector:@selector(replyComment:InCell:)]) {
            [weakSelf.delegate replyComment:model InCell:weakSelf];
        }
    };
    // 删除
    [_dateView setDeleteButtonClickedBlock:^{
        if ([weakSelf.delegate respondsToSelector:@selector(didClickDeleteButtonInCell:)]) {
            [weakSelf.delegate didClickDeleteButtonInCell:weakSelf];
        }
    }];
    // 打开菜单
    [_dateView setOperationButtonClickedBlock:^{
        [weakSelf operationMenu];
    }];
    
    // 赞
    _operationView = [[ICStatusOperationView alloc] init];
    _operationView.alpha = 0;
    [_operationView setLikeButtonClickedOperation:^{
        if ([weakSelf.delegate respondsToSelector:@selector(didClickLikeButtonInCell:)]) {
            [weakSelf.delegate didClickLikeButtonInCell:weakSelf];
        }
    }];
    // 评论
    [_operationView setCommentButtonClickedOperation:^{
        if ([weakSelf.delegate respondsToSelector:@selector(didClickCommentButtonInCell:)]) {
            [weakSelf.delegate didClickCommentButtonInCell:weakSelf];
        }
    }];
    // 图片展示
    _picContainerView = [[ICPicContainerView alloc] init];
    _picContainerView.hidden = YES;
    _picContainerView.cellImageTapAction = ^(NSInteger index){
        if ([weakSelf.delegate respondsToSelector:@selector(didClickContainerImageInCell:ImageAtIndex:)]) {
            [weakSelf.delegate didClickContainerImageInCell:weakSelf ImageAtIndex:index];
        }
    };
    // 点击视频区域
    _videoContainerView = [[ICVideoContainerView alloc] initWithFrame:CGRectZero];
    _videoContainerView.hidden = YES;
    [_videoContainerView setCellVideoAction:^{
        if ([weakSelf.delegate respondsToSelector:@selector(didClickVideoImageInCell:)]) {
            [weakSelf.delegate didClickVideoImageInCell:weakSelf];
        }
    }];
    // 视频播放按钮
    [_videoContainerView.playButton addTarget:self action:@selector(playAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _webPageView = [[ICWebPageView alloc] init];
    _webPageView.hidden = YES;
    _webPageView.webPageAction = ^(NSString *url) {
        if ([weakSelf.delegate respondsToSelector:@selector(didClickwebPageViewInCell:link:)]) {
            [weakSelf.delegate didClickwebPageViewInCell:weakSelf link:url];
        }
    };
    
    [self sd_addSubviews:@[_headImageView, _nameLabel, _contentLabel, _picContainerView, _videoContainerView,_webPageView, _dateView, _operationView,_commentView, self.bottomLineView]];
}

- (void)playAction:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(didClickVideoPlayButtonInCell:)]) {
        [self.delegate didClickVideoPlayButtonInCell:self];
    }
}

- (void)layoutSubview {
    WEAKSELF
    [self.headImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView.mas_top).offset(ICCellTopMargin);
        make.left.equalTo(weakSelf.contentView.mas_left).offset(ICCellPadding);
        make.width.mas_equalTo(ContactHeadImageHeight);
        make.height.mas_equalTo(ContactHeadImageHeight);
    }];
    
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView.mas_top).offset(ICCellTopMargin);
        make.left.equalTo(weakSelf.headImageView.mas_right).offset(ICCellNamePaddingLeft);
    }];
    
    [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.nameLabel.mas_bottom).offset(ICCellNameTopContent);
        make.left.equalTo(weakSelf.nameLabel.mas_left);
        make.width.mas_equalTo(DiscContentWidth);
    }];
    
    [self.contentLabelAllbutton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentLabel.mas_bottom).offset(0);
        make.left.equalTo(weakSelf.contentLabel.mas_left);
        make.width.mas_equalTo(80);
        if(!isDisdetailVC){
            if(self.viewModel.contentallCount != 7){
                make.height.mas_equalTo(25);
                self.contentLabelAllbutton.hidden = NO;
                [weakSelf.contentLabelAllbutton setTitle:@"收起" forState:UIControlStateNormal];
            }else if(cllcount > 7){
                make.height.mas_equalTo(25);
                self.contentLabelAllbutton.hidden = NO;
                [weakSelf.contentLabelAllbutton setTitle:@"显示全部" forState:UIControlStateNormal];
            }else{
                make.height.mas_equalTo(0);
                self.contentLabelAllbutton.hidden = YES;
            }
        }else{
            make.height.mas_equalTo(0);
            self.contentLabelAllbutton.hidden = YES;
            
        }
    }];
    [self.videoContainerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentLabelAllbutton.mas_bottom);
        make.left.equalTo(weakSelf.nameLabel.mas_left);
        make.width.mas_equalTo(DiscContentWidth);
        make.height.mas_equalTo(weakSelf.viewModel.videoContainerHeight);
    }];
    
    [self.webPageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.videoContainerView.mas_bottom);
        make.left.equalTo(weakSelf.nameLabel.mas_left);
        make.width.mas_equalTo(DiscContentWidth);
        if (self.viewModel.mediaType == [TypeDyPicURL integerValue]) {
            make.bottom.equalTo(self.webPageView.fromLabel.mas_bottom);
        } else {
            make.bottom.equalTo(weakSelf.videoContainerView.mas_bottom);
        }
    }];
    
    [self.picContainerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.webPageView.mas_bottom);
        make.left.equalTo(weakSelf.nameLabel.mas_left).offset(-15);
        make.width.mas_equalTo(DiscContentWidth);
        make.height.mas_equalTo(weakSelf.viewModel.picContainerHeight);
    }];
    
    [self.dateView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.picContainerView.mas_bottom);
        make.left.equalTo(weakSelf.nameLabel.mas_left);
        make.height.mas_equalTo(35);
        make.width.mas_equalTo(DiscContentWidth);
    }];
    
    [self.operationView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.dateView.operationButton.mas_left).offset(-2);
        make.width.mas_equalTo(0);
        make.height.mas_equalTo(35);
        make.bottom.equalTo(self.dateView.mas_bottom);
    }];
    
    [self.commentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.nameLabel.mas_left);
        make.width.mas_equalTo(DiscContentWidth);
        make.height.mas_equalTo(_praise_commentHeight).priorityLow();
        if (!weakSelf.commentView.hidden) {
            make.top.equalTo(weakSelf.dateView.mas_bottom).offset(ICCellNameTopContent);
        } else {
            make.top.equalTo(weakSelf.dateView.mas_bottom);
        }
    }];
    
    [self.bottomLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.and.left.mas_equalTo(weakSelf.contentView);
        make.height.mas_equalTo(1);
        if (!weakSelf.commentView.hidden) {
            make.top.equalTo(weakSelf.commentView.endView.mas_bottom).offset(10);
        }else {
            make.top.equalTo(weakSelf.operationView.mas_bottom);
        }
        make.bottom.mas_equalTo(weakSelf.contentView.mas_bottom);
    }];
    if (isDisdetailVC) {
        _bottomLineView.backgroundColor = [UIColor whiteColor];
    } else {
        _bottomLineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
}

-(void)setViewModel:(ICDiscoverTableViewCellViewModel *)viewModel {
    _viewModel = viewModel;
    _nameLabel.text = viewModel.eName;
    
    _contentLabel.attributedText = viewModel.contentAttributedString;
    //        _contentLabel.text = viewModel.content;
    
    _contentLabel.linkTextAttributes = @{NSForegroundColorAttributeName:MESSAGEURLDEFAULTCOLOR,NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)};
    
    
    _dateView.dateLabel.text = viewModel.createDate;
    
    
    _picContainerView.dataController = self.dataController;
    _videoContainerView.dataController = self.dataController;
    _webPageView.dataController = self.dataController;
    
    [_operationView.likeButton setTitle:[viewModel isLike] forState:UIControlStateNormal];
    
    NSString *URL = MINIMAGEURL(viewModel.photoId);
    [UIImage addAvatariamgeView:self.headImageView withUrlStr:URL witheId:viewModel.eId withName:viewModel.eName];
    if ([viewModel.eId isEqualToString:[ICUser currentUser].eId]) {
        _dateView.deleteButton.hidden = NO;
    } else {
        _dateView.deleteButton.hidden = YES;
    }
    
    if (viewModel.mediaType == [TypeDyPic integerValue] || viewModel.mediaType == [TypeDyMPic integerValue]) {
        
        _picContainerView.model = viewModel;
        _picContainerView.hidden = NO;
        _videoContainerView.hidden = YES;
        _webPageView.hidden = YES;
        
    } else if (viewModel.mediaType == [TypeDyVideo integerValue]) {
        
        _videoContainerView.model = viewModel;
        _picContainerView.hidden = YES;
        _videoContainerView.hidden = NO;
        _webPageView.hidden = YES;
        
    } else if (viewModel.mediaType == [TypeDyPicURL integerValue]) { // 图文链接
        _webPageView.viewModel = viewModel;
        _picContainerView.hidden = YES;
        _videoContainerView.hidden = YES;
        _webPageView.hidden = NO;
        
    } else {
        _picContainerView.hidden = YES;
        _videoContainerView.hidden = YES;
        _webPageView.hidden = YES;
    }
    
    _commentView.model = viewModel;
    cllcount = [self UILabelcount:viewModel.content];
    
    _contentLabel.numberOfLines = viewModel.contentallCount;
    if(isDisdetailVC){
        _contentLabel.numberOfLines = 0;
    }
    
    
    _praise_commentHeight = _commentView.Praise_CommentViewHeight;
    [self layoutSubview];
}

-(NSInteger)UILabelcount:(NSString *)text
{
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, DiscContentWidth, 30)];
    label.font = ICFont(15);
    label.numberOfLines = 0;
    label.text = text;
    CGFloat labelHeight = [label sizeThatFits:CGSizeMake(DiscContentWidth, MAXFLOAT)].height;
    NSNumber *count = @((labelHeight) / label.font.lineHeight);
    return [count integerValue];
}


- (void)sd_addSubviews:(NSArray *)subviews {
    [subviews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        if ([view isKindOfClass:[UIView class]]) {
            [self.contentView addSubview:view];
        }
    }];
}
/**
 * 长按点击
 */
- (void)longPress:(UILongPressGestureRecognizer *)longRecognizer {
    if (longRecognizer.state == UIGestureRecognizerStateBegan) {
        [self showMenuViewController:self.contentLabel];
    }
}
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (action == @selector(copyContent:) || action == @selector(collectContent:)) {
        return YES;
    }
    return  [super canPerformAction:action withSender:sender];
}
- (BOOL)canBecomeFirstResponder {
    return YES;
}
- (void)showMenuViewController:(UIView *)showInView {
    [self becomeFirstResponder];
    [[UIMenuController sharedMenuController] update];
    if (!_copyMenuItem) {
        _copyMenuItem   = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copyContent:)];
        _collectMenuItem   = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"favorites", nil) action:@selector(collectContent:)];
    }
    [[UIMenuController sharedMenuController] setMenuItems:@[_copyMenuItem, _collectMenuItem]];
    [[UIMenuController sharedMenuController] setTargetRect:showInView.frame inView:showInView.superview];
    [[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];
}

- (void)copyContent:(UIMenuController *)menu {
    UIPasteboard *pasteboard  = [UIPasteboard generalPasteboard];
    pasteboard.string = self.contentLabel.text;
}

- (void)collectContent:(UIMenuItem *)collectContent {
    // 收藏文字
    NSString * photoId1 = ![ICTools stringEmpty:self.viewModel.photoId] ? self.viewModel.photoId:[NSString stringWithFormat:@"eId:%@",self.viewModel.eId];
    [self.dataController addFavoriteWithType:@"1"
                                         eId:[ICUser currentUser].eId
                                         gId:self.viewModel.findId
                                     photoId:photoId1
                                       title:self.viewModel.eName
                                         txt:self.viewModel.content
                                         key:@""
                                         lnk:@""
                                       msgId:self.viewModel.findId
                                    Callback:^(NSError *error) {
                                        if (!error) {
                                            [MBProgressHUD showSuccess:@"收藏成功"];
                                        } else {
                                            [MBProgressHUD showError:error.domain];
                                        }
                                    }];
}

/**
 *  视频播放
 */
-(void)startVideo {
    self.videoContainerView.playButton.hidden = YES;
    __weak typeof(self) weakSelf=self;
    [[ZacharyPlayManager sharedInstance] startWithLocalPath:self.viewModel.video.locVideoPath WithVideoBlock:^(UIImage *imageData, NSString *filePath,CGImageRef tpImage) {
        if ([filePath isEqualToString:weakSelf.viewModel.video.locVideoPath]) {
            //           weakSelf.videoContainerView.imageView.layer.contents=(__bridge id _Nullable)(tpImage);
            weakSelf.videoContainerView.imageView.image = imageData;
        }
    }];
}

//Repeat play
-(void)reloadStart {
    self.videoContainerView.playButton.hidden = YES;
    __weak typeof(self) weakSelf=self;
    [[ZacharyPlayManager sharedInstance] startWithLocalPath:self.viewModel.video.locVideoPath WithVideoBlock:^(UIImage *imageData, NSString *filePath,CGImageRef tpImage) {
        if ([filePath isEqualToString:weakSelf.viewModel.video.locVideoPath]) {
            //            weakSelf.videoContainerView.imageView.layer.contents=(__bridge id _Nullable)(tpImage);
            weakSelf.videoContainerView.imageView.image = imageData;
        }
    }];
    
    [[ZacharyPlayManager sharedInstance]  reloadVideo:^(NSString *filePath) {
        MAIN(^{
            if ([filePath isEqualToString:weakSelf.viewModel.video.locVideoPath]) {
                [weakSelf reloadStart];
            }
        });
    } withFile:self.viewModel.video.locVideoPath];
}
-(void)stopVideo {
    self.videoContainerView.playButton.hidden = NO;
    [[ZacharyPlayManager sharedInstance] cancelVideo:self.viewModel.video.locVideoPath];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[ZacharyPlayManager sharedInstance] cancelAllVideo];
}

- (void)operationMenu {
    [self postOperationButtonClickedNotification];
    _operationView.show = !_operationView.isShowing;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self postOperationButtonClickedNotification];
    if (_operationView.isShowing) {
        _operationView.show = NO;
    }
}

- (void)postOperationButtonClickedNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CellOperationButtonClickedNotification" object:self.dateView.operationButton];
}

- (void)receiveOperationButtonClickedNotification:(NSNotification *)notification {
    UIButton *btn = [notification object];
    if (btn != self.dateView.operationButton && _operationView.isShowing) {
        _operationView.show = NO;
    }
}

- (UIView *)bottomLineView {
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return _bottomLineView;
}

@end

