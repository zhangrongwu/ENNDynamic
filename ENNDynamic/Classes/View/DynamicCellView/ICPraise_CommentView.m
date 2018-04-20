//
//  ICPraise_CommentView.m
//  ICome
//
//  Created by zhangrongwu on 16/4/13.
//  Copyright © 2016年 iCom. All rights reserved.
//

#import "ICPraise_CommentView.h"
#import "ICCommentModel.h"
#import "UITableView+FDTemplateLayoutCell.h"
static NSString *identifier = @"ICDiscoverCellPraise_CommentCell";

@interface ICPraise_CommentView ()<UITableViewDelegate, UITableViewDataSource, MLLinkLabelDelegate> {
    UIMenuItem * _copyMenuItem;
    UIMenuItem * _deleteMenuItem;
    UIMenuItem * _replyMenuItem;
}
@property (nonatomic, strong) NSArray *commentItemsList; // 评论数据
@property (nonatomic, strong) NSMutableArray *commentLabelsList; // 评论lebel数组

@property (nonatomic, strong)UIImageView *bgImageView;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)MLLinkLabel *praiseLabel;
@property (nonatomic, strong)UIView *praiseView;
@property (nonatomic, strong)UIView *praiseLableBottomLine; // 赞下方的分割线
@property (nonatomic, assign)CGFloat selfHeight;

@property (nonatomic, strong)UIView *moreView;
@property (nonatomic, strong)UIButton *moreButton;

@property (nonatomic, strong)ICCommentModel *currentCommentModel;
@property (nonatomic, strong)NSIndexPath *longIndexPath;


@end

@implementation ICPraise_CommentView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
        self.hidden = YES;
        [self setNeedsUpdateConstraints];
    }
    return self;
}

-(void)setup {
    _endView = [[UIView alloc] init];
    
    self.praiseView = [[UIView alloc] init];
    
    self.praiseLabel = [[MLLinkLabel alloc] init];
    self.praiseLabel.font = ICFont(14);
    self.praiseLabel.textColor = ICRGB(0x9a9a9a);
    self.praiseLabel.numberOfLines = 0;
    self.praiseLabel.delegate = self;
    [self.praiseLabel sizeToFit];
    [self.praiseView addSubview:self.praiseLabel];
    
    self.praiseLableBottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DiscContentWidth, 1)];
    [self.praiseView addSubview:self.praiseLableBottomLine];
    self.praiseLableBottomLine.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.praiseLableBottomLine.hidden = YES;
    
    
    self.moreView = [[UIView alloc] init];
    
    self.moreButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, DiscContentWidth, 40)];
    [self.moreButton setTitle:@"查看更多" forState:UIControlStateNormal];
    [self.moreButton setTitleColor:ICRGB(0x5f6f95) forState:UIControlStateNormal];
    [self.moreButton addTarget:self action:@selector(moreButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.moreView addSubview:self.moreButton];
    
    [self addSubview:_endView];
    [self addSubview:self.tableView];
}

- (void)moreButtonAction {
    if (self.moreButtonClickedBlock) {
        self.moreButtonClickedBlock();
    }
}

-(void)setModel:(ICDiscoverTableViewCellViewModel *)model {
    _model = model;
    if (model.hasPraise) {
        CGFloat praiseH = 55;
        if ([model praiseViewHeight] <= 20) { // 点赞区高度问题
            praiseH = 40;
        }
        self.praiseView.frame = CGRectMake(0, 0, DiscContentWidth, praiseH);
        _tableView.tableHeaderView = self.praiseView;
        self.praiseLabel.frame = CGRectMake(5, 10, DiscContentWidth - 10, praiseH - 15);
        self.praiseLabel.attributedText = [model likeAttributedString];
        if ([model hasComments]) {
            self.praiseLableBottomLine.hidden = NO;
            self.praiseLableBottomLine.frame  = CGRectMake(5, praiseH - 3, DiscContentWidth - 10, 1);
        } else {
            self.praiseLableBottomLine.hidden = YES;
        }
        if (model.commentCount > 10 && !isDisdetailVC) {
            self.moreView.frame = CGRectMake(0, 0, DiscContentWidth, 40);
            self.moreButton.hidden = NO;
        } else {
            // 单个消息 个人详情
            self.moreView.frame = CGRectMake(0, 0, 0, 0);
            self.moreButton.hidden = YES;
        }
        _tableView.tableFooterView = self.moreView;
        
    } else {
        if ([model hasComments]) {
            self.praiseView.frame = CGRectMake(0, 0, DiscContentWidth, 10.0f);
        } else {
            self.praiseView.frame = CGRectMake(0, 0, 0, 0);
        }
        _tableView.tableHeaderView = self.praiseView;
        //        [self.praiseLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        //            make.left.equalTo(self.praiseView.mas_left);
        //            make.top.equalTo(self.praiseView.mas_top);
        //            make.right.equalTo(self.praiseView.mas_right);
        //            make.bottom.equalTo(self.praiseView.mas_bottom);
        //        }];
        self.praiseLabel.frame = CGRectZero;
        
        self.praiseLabel.attributedText = nil;
        self.praiseLableBottomLine.hidden = YES;
        
        // 评论处理
        if (model.commentCount > 10 && !isDisdetailVC) {
            self.moreView.frame = CGRectMake(0, 0, DiscContentWidth, 40);
            self.moreButton.hidden = NO;
        } else {
            self.moreView.frame = CGRectMake(0, 0, 0, 0);
            self.moreButton.hidden = YES;
        }
        _tableView.tableFooterView = self.moreView;
    }
    
    if (model.hasPraise || model.hasComments) {
        self.tableView.hidden = NO;
        self.hidden = NO;
    } else {
        self.tableView.hidden = YES;
        self.hidden = YES;
    }
    [self.tableView reloadData];
    _selfHeight = self.tableView.contentSize.height;
    NSLog(@"%f", _selfHeight);
}

-(void)layoutSubviews {
    [super layoutSubviews];
}

-(void)updateConstraints {
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
    }];
    [self.endView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView.mas_bottom);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    [super updateConstraints];
}
- (CGFloat)Praise_CommentViewHeight {
    return _selfHeight;
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (isDisdetailVC) {
        return self.model.commentList.count;
    } else {
        if (self.model.commentList.count > 10) {
            return 10;
        } else {
            return self.model.commentList.count;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ICDiscoverCellPraise_CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    [self setCell:cell rowAtIndexPath:indexPath];
    WEAKSELF;
    cell.ClickInCellMLLabelBlock = ^(MLLink *link, NSString *linkText, MLLinkLabel *label){
        if (self.MLTapClickInLabelBlock) {
            weakSelf.MLTapClickInLabelBlock(link,linkText,label);
        }
    };
    
    cell.LongPressBlock = ^(UILongPressGestureRecognizer *recognizer){
        [weakSelf longPress:recognizer];
    };
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ICCommentModel *model = self.model.commentList[indexPath.row];
    return [model calculateCellHeight];
}

- (void)setCell:(ICDiscoverCellPraise_CommentCell *)cell rowAtIndexPath:(NSIndexPath *)indexPath {
    cell.model = self.model.commentList[indexPath.row];
}
// 点击评论区
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ICDiscoverCellPraise_CommentCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (self.CommentCellClickBlock) {
        self.CommentCellClickBlock(indexPath, self.model.commentList[indexPath.row], cell);
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)longPress:(UILongPressGestureRecognizer *)longRecognizer
{
    if (longRecognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint location       = [longRecognizer locationInView:self.tableView];
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
        _longIndexPath         = indexPath;
        ICDiscoverCellPraise_CommentCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        self.currentCommentModel = self.model.commentList[indexPath.row];
        [self showMenuViewController:cell.titleLabel andIndexPath:indexPath message:self.currentCommentModel];
    }
}
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if ((action == @selector(deleteComment:)) || (action == @selector(copyComment:)) || (action == @selector(replyComment:))) {
        return YES;
    }
    return  [super canPerformAction:action withSender:sender];
}
- (BOOL)canBecomeFirstResponder {
    return YES;
}
- (void)showMenuViewController:(UIView *)showInView andIndexPath:(NSIndexPath *)indexPath message:(ICCommentModel *)model {
    [self becomeFirstResponder];
    [[UIMenuController sharedMenuController] update];
    if (!_deleteMenuItem) {
        _deleteMenuItem = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"delete", nil) action:@selector(deleteComment:)];
    }
    if (!_copyMenuItem) {
        _copyMenuItem   = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copyComment:)];
    }
    if (!_replyMenuItem) {
        _replyMenuItem  = [[UIMenuItem alloc] initWithTitle:@"回复" action:@selector(replyComment:)];
    }
    
    if ([model.eId isEqualToString:[ICUser currentUser].eId]) {
        [[UIMenuController sharedMenuController] setMenuItems:@[_copyMenuItem, _deleteMenuItem]];
    } else {
        [[UIMenuController sharedMenuController] setMenuItems:@[_copyMenuItem, _replyMenuItem]];
    }
    [[UIMenuController sharedMenuController] setTargetRect:showInView.frame inView:showInView.superview];
    [[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];
}

- (void)copyComment:(UIMenuController *)menu {
    UIPasteboard *pasteboard  = [UIPasteboard generalPasteboard];
    ICCommentModel * model = self.model.commentList[_longIndexPath.row];
    pasteboard.string = model.comment;
}
// 删除
- (void)deleteComment:(UIMenuController *)menu {
    if (self.DeleteCommentBlock) {
        self.DeleteCommentBlock(self.currentCommentModel);
    }
}
// 回复
- (void)replyComment:(UIMenuController *)menu {
    if (self.ReplyCommentBlock) {
        self.ReplyCommentBlock(self.currentCommentModel);
    }
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundView = self.bgImageView;
        [_tableView registerClass:[ICDiscoverCellPraise_CommentCell class] forCellReuseIdentifier:identifier];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.scrollEnabled = NO;
        _tableView.sectionHeaderHeight = 0.f;
        _tableView.sectionFooterHeight = 0.f;
        _tableView.hidden = YES;
        _tableView.scrollsToTop = NO;
        _tableView.tableHeaderView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
    }
    return _tableView;
}

-(UIImageView *)bgImageView {
    if (!_bgImageView) {
        UIImage *img = [[UIImage imageNamed:@"icon_discover_common_bg"] stretchableImageWithLeftCapWidth:40 topCapHeight:32];
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.image = img;
    }
    return _bgImageView;
}

- (void)didClickLink:(MLLink*)link linkText:(NSString*)linkText linkLabel:(MLLinkLabel*)linkLabel {
    WEAKSELF
    if (self.MLTapClickInLabelBlock) {
        weakSelf.MLTapClickInLabelBlock(link,linkText,linkLabel);
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end















@interface ICDiscoverCellPraise_CommentCell()<MLLinkLabelDelegate>

@end
@implementation ICDiscoverCellPraise_CommentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.titleLabel];
        self.backgroundColor = [UIColor colorWithRed:1. green:1. blue:1. alpha:0.1];
        [self setNeedsUpdateConstraints];
        UILongPressGestureRecognizer * longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(cellLongPress:)];
        [self addGestureRecognizer:longPressGesture];
    }
    return self;
}
- (void)cellLongPress:(UILongPressGestureRecognizer *)recognizer {
    if (self.LongPressBlock) {
        self.LongPressBlock(recognizer);
    }
}

- (void)updateConstraints {
    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 5, 0, 10));
    }];
    [super updateConstraints];
}

-(void)setModel:(ICCommentModel *)model {
    _model = model;
    self.titleLabel.attributedText = [model commentsAttributedString];
}

- (MLLinkLabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[MLLinkLabel alloc] init];
        _titleLabel.font = ICFont(14);
        _titleLabel.textColor = ICRGB(0x9a9a9a);
        _titleLabel.numberOfLines = 0;
        _titleLabel.delegate = self;
        _titleLabel.userInteractionEnabled = YES;
        [_titleLabel sizeToFit];
    }
    return _titleLabel;
}


- (void)didClickLink:(MLLink*)link linkText:(NSString*)linkText linkLabel:(MLLinkLabel*)linkLabel {
    if (self.ClickInCellMLLabelBlock) {
        self.ClickInCellMLLabelBlock(link,linkText,linkLabel);
    }
}


@end

