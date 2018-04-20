//
//  ICDiscoverTableView.m
//  ICome
//
//  Created by zhangrongwu on 16/6/17.
//  Copyright © 2016年 iCom. All rights reserved.
//

#import "ICDiscoverTableView.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "YYPhotoGroupView.h"
#import "ICDiscoverHeaderView.h"
#import "UIImage+AvatarGeneration.h"
static NSString *identifier = @"ICDiscoverTableViewVCell";
static CGFloat   yyTextFieldHeight = 40.0;

@interface ICDiscoverTableView ()<UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, ICDiscoverTableViewVCellDelegate, ICDiscoverHeaderViewDelegate, YYTextViewDelegate>
@property (nonatomic, strong)NSIndexPath *currentIndexthPath;
@property (nonatomic, assign)CGFloat totalKeybordHeight;
@property (nonatomic, assign)CGPoint currentPointt;
@property (nonatomic, strong)NSString *toId;
@property (nonatomic, strong)NSString *toName;
@property (nonatomic, strong)ICDiscoverHeaderView *headView;
@property (nonatomic, strong)ICDiscoverTableViewCellViewModel *currentCellModel;

@end

@implementation ICDiscoverTableView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initRefresh];
        [self.tableView registerClass:[ICDiscoverTableViewVCell class] forCellReuseIdentifier:identifier];
        [self initNotificationCenter];
    }
    return self;
}

- (void)initNotificationCenter {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(interfaceReloadData:) name:NotificationUpdateDVideoView object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(interfaceReloadData:) name:NotificationChangeUIView object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateDiscoverAction:) name:NotificationUpdateDiscoverNews object:nil];
}

- (void)interfaceReloadData:(NSNotification *)notification {
    [self.tableView reloadData];
}

- (void)keyboardNotification:(NSNotification *)notification {
    NSDictionary *dict = notification.userInfo;
    CGRect rect = [dict[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    CGRect textFieldRect = CGRectMake(5, rect.origin.y - HEIGHT_NAVBAR_X - yyTextFieldHeight, rect.size.width - 10, yyTextFieldHeight);
    if (rect.origin.y == [UIScreen mainScreen].bounds.size.height) {
        textFieldRect = rect;
    }
    [UIView animateWithDuration:0.25 animations:^{
        _yyTextView.frame = textFieldRect;
    }];
    CGFloat h = rect.size.height + yyTextFieldHeight;
    if (_totalKeybordHeight != h) {
        _totalKeybordHeight = h;
        [self tableViewToFitKeyboard];
    }
}

- (void)initRefresh {
    WEAKSELF;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (isDisdetailVC) {
            [weakSelf.tableView.mj_header endRefreshing];
            return;
        }
        [weakSelf fetchASCFindListData];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (isDisdetailVC) {
            [weakSelf.tableView.mj_footer endRefreshing];
            return;
        }
        [weakSelf fetchFindListData];
    }];
}

- (void)fetchFindListData {
    ICDiscoverTableViewCellViewModel *model = [self.viewModel.cellViewModels lastObject];
    NSString *findId = model.findId == nil ? @"0" : model.findId;
    NSDictionary *param = @{@"findId":findId,
                            @"pageSize":@"10",
                            @"cSize":@"10",
                            @"pSize":@"20"};
    WEAKSELF
    [_dataController requestFindListWithParam:param FinishHandle:^(id message) {
        [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
    } Callback:^(NSError *error) {
        [self endRefreshing];
    }];
}

- (void)fetchASCFindListData {
    NSDictionary *param = @{@"findId":@"0",
                            @"pageSize":@"10",
                            @"cSize":@"10",
                            @"pSize":@"20"};
    [_dataController requestASCFindListWithParam:param Callback:^(NSError *error) {
        [self endRefreshing];
    }];
}
- (void)endRefreshing {
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    self.viewModel = [ICDiscoverTableViewModel viewModelWithSubjects:self.dataController.subjects];
    [self reloadData];
}
- (void)reloadData {
    [self.tableView reloadData];
}
// 刷新界面
- (void)updateDiscoverAction:(NSNotification *)notification {
    [self.tableView.mj_header beginRefreshing];
}

-(void)setViewModel:(ICDiscoverTableViewModel *)viewModel {
    _viewModel = viewModel;
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.cellViewModels.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:identifier cacheByIndexPath:indexPath configuration:^(ICDiscoverTableViewVCell *cell) {
//        ICDiscoverTableViewCellViewModel * model = [self.viewModel.cellViewModels objectAtIndex:indexPath.row];
        //model.contentallCount = 0;
        [self setCell:cell rowAtIndexPath:indexPath];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ICDiscoverTableViewVCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.delegate = self;
    cell.dataController = self.dataController;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [self setCell:cell rowAtIndexPath:indexPath];
    return cell;
}

- (void)setCell:(ICDiscoverTableViewVCell *)cell rowAtIndexPath:(NSIndexPath *)indexPath {
    cell.viewModel = [self.viewModel.cellViewModels objectAtIndex:indexPath.row];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate {
}

//if cell is recovery.the video cancel
- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath {
    ICDiscoverTableViewVCell *disPlayingCell = (ICDiscoverTableViewVCell *)cell;
    [disPlayingCell stopVideo];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.userInteractionEnabled = YES;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.scrollsToTop = YES;
        if (!isDisdetailVC) {
            _tableView.tableHeaderView = self.headView;
        }
        [self addSubview:_tableView];
    }
    return _tableView;
}

- (YYTextView *)yyTextView {
    if (!_yyTextView) {
        _yyTextView = [[YYTextView alloc] initWithFrame:CGRectMake(0, APP_Frame_Height, App_Frame_Width, yyTextFieldHeight)];
        _yyTextView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
        _yyTextView.delegate = self;
        _yyTextView.backgroundColor = [UIColor whiteColor];
        _yyTextView.returnKeyType = UIReturnKeyDone;
        _yyTextView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
        _yyTextView.layer.borderWidth = 1;
        _yyTextView.layer.masksToBounds = YES;
        _yyTextView.layer.cornerRadius = 5;
        _yyTextView.placeholderText = @"回复";
        _yyTextView.font = ICFont(14);
        _yyTextView.placeholderFont = ICFont(14);
        [self addSubview:_yyTextView];
    }
    return _yyTextView;
}

-(ICDiscoverHeaderView *)headView {
    if (!_headView) {
        CGFloat height =  180 / 375.0f * App_Frame_Width;
        _headView = [[ICDiscoverHeaderView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, height)];
        _headView.bgImageView.image = [UIImage imageNamed:@"icon_discover_banner"];
        NSString *URL = MAXIMAGEURL([ICUser currentUser].photoId);
        [UIImage addAvatariamgeView:_headView.headImageView withUrlStr:URL witheId:[ICUser currentUser].eId withName:[ICUser currentUser].eName];
//        [_headView.headImageView sd_setImageWithURL:[NSURL URLWithString:MAXIMAGEURL([ICUser currentUser].photoId)]placeholderImage:[UIImage imageNamed:@"App_personal_headimg"]options:SDWebImageRetryFailed];
        _headView.delegate = self;
    }
    return _headView;
}
/// 点击了头像
- (void)didClickHeadImageInCell:(ICDiscoverTableViewVCell *)cell { // 点击用户头像
    self.currentIndexthPath = [self.tableView indexPathForCell:cell];
    self.currentCellModel = [self.viewModel.cellViewModels objectAtIndex:self.currentIndexthPath.row];
    if ([self.delegate respondsToSelector:@selector(didClickToDetailControllerWitheId:)]) {
        [self.delegate didClickToDetailControllerWitheId:self.currentCellModel.eId];
    }
}
- (void)didClicktitleLabelInCell:(ICDiscoverTableViewVCell *)cell {
    self.currentIndexthPath = [self.tableView indexPathForCell:cell];
    self.currentCellModel = [self.viewModel.cellViewModels objectAtIndex:self.currentIndexthPath.row];
    if ([self.delegate respondsToSelector:@selector(didClickToDetailControllerWitheId:)]) {
        [self.delegate didClickToDetailControllerWitheId:self.currentCellModel.eId];
    }
}

// 点击显示全部
-(void)didClickcontentAllButtonInCell:(ICDiscoverTableViewVCell *)cell
{
    self.currentIndexthPath = [self.tableView indexPathForCell:cell];
    self.currentCellModel = [self.viewModel.cellViewModels objectAtIndex:self.currentIndexthPath.row];
    if(self.currentCellModel.contentallCount == 7){
        self.currentCellModel.contentallCount = 0;
    }else{
        self.currentCellModel.contentallCount = 7;
    }
    [self.tableView reloadRowsAtIndexPaths:@[self.currentIndexthPath]  withRowAnimation:UITableViewRowAnimationNone];
}

/// 点击了点赞
- (void)didClickLikeButtonInCell:(ICDiscoverTableViewVCell *)cell {
    self.currentIndexthPath = [self.tableView indexPathForCell:cell];
    self.currentCellModel = [self.viewModel.cellViewModels objectAtIndex:self.currentIndexthPath.row];
    [self.dataController requestPraiseWithFindId:self.currentCellModel.findId indexPatch:self.currentIndexthPath Callback:^(NSError *error) {
        if (!error) {
            self.viewModel = [ICDiscoverTableViewModel viewModelWithSubjects:self.dataController.subjects];
            [self.tableView reloadRowsAtIndexPaths:@[self.currentIndexthPath]  withRowAnimation:UITableViewRowAnimationNone];
        }
    }];
    [self.yyTextView resignFirstResponder];
}

/// 点击了评论
- (void)didClickCommentButtonInCell:(ICDiscoverTableViewVCell *)cell {
    [self.yyTextView becomeFirstResponder];
    self.currentIndexthPath = [self.tableView indexPathForCell:cell];
    self.currentCellModel = [self.viewModel.cellViewModels objectAtIndex:self.currentIndexthPath.row];
    self.currentPointt = self.tableView.contentOffset;
    [self tableViewToFitKeyboard];
}

- (void)didClickwebPageViewInCell:(ICDiscoverTableViewVCell *)cell link:(NSString *)link {
    if ([self.delegate respondsToSelector:@selector(didClickToWebViewControllerWithPath:)]) {
        [self.delegate didClickToWebViewControllerWithPath:link];
    }
}

// 键盘 tableview 位置 设置偏移
- (void)tableViewToFitKeyboard {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:_currentIndexthPath];
    CGRect rect = [cell.superview convertRect:cell.frame toView:window];
    CGFloat delta = CGRectGetMaxY(rect) - (window.bounds.size.height - _totalKeybordHeight);
    CGPoint offset = self.tableView.contentOffset;
    offset.y += delta;
    if (offset.y < 0) {
        offset.y = 0;
    }
    [self.tableView setContentOffset:offset animated:YES];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([@"\n" isEqualToString:text] == YES) {
        // 构造数据 进行评论
        [self.yyTextView resignFirstResponder];
        NSString *toId = self.toId == nil ? @"" : self.toId;
        NSString *toName = self.toName == nil ? @"" : self.toName;
        if (textView.text.length>0) {
            [self.dataController requestaddCommentWithFindId:self.currentCellModel.findId Comment:textView.text toId:toId toName:toName indexPatch:self.currentIndexthPath Callback:^(NSError *error) {
                if (!error) {
                    ICDiscoverModel *model = [self.dataController.subjects objectAtIndex:self.currentIndexthPath.row];
                    if (model.commentList.count > 10 && !isDisdetailVC) { // 坑爹业务逻辑、移除第一条数据
                        [model.commentList removeFirstObject];
                    }
                    self.viewModel = [ICDiscoverTableViewModel viewModelWithSubjects:self.dataController.subjects];
                    [self.tableView reloadRowsAtIndexPaths:@[self.currentIndexthPath]  withRowAnimation:UITableViewRowAnimationNone];
                }
            }];
            [self initTextFieldConfig];
        }
        return NO;
    }
    return YES;
}

- (void)deleteUserCommentFindId:(NSString *)findId findCommentId:(NSString *)findCommentId {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle: nil
                                                                   message: nil
                                                            preferredStyle: UIAlertControllerStyleActionSheet];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:NSLocalizedString(@"delete", nil)
                                                   style:UIAlertActionStyleDefault
                                                 handler:^(UIAlertAction *action) {
                                                     [self.dataController deleteDiscoverCommentFindId:findId CommentId:findCommentId indexPatch:self.currentIndexthPath Callback:^(NSError *error) {
                                                         if (!error) {
                                                             self.viewModel = [ICDiscoverTableViewModel viewModelWithSubjects:self.dataController.subjects];
                                                             [self.tableView reloadRowsAtIndexPaths:@[self.currentIndexthPath]  withRowAnimation:UITableViewRowAnimationNone];
                                                         }
                                                     }];
                                                 }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"cancel", nil)
                                                     style:UIAlertActionStyleCancel
                                                   handler:nil];
    [alert addAction:sure];
    [alert addAction:cancel];
    [App_RootCtr presentViewController:alert animated:YES completion:nil];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.yyTextView resignFirstResponder];
    [self initTextFieldConfig];
}

- (void)initTextFieldConfig {
    self.yyTextView.text = @"";
    self.toId = @"";
    self.toName = @"";
    self.yyTextView.placeholderText = @"回复";
}

/// 点击了删除
- (void)didClickDeleteButtonInCell:(ICDiscoverTableViewVCell *)cell {
    self.currentIndexthPath = [self.tableView indexPathForCell:cell];
    self.currentCellModel = [self.viewModel.cellViewModels objectAtIndex:self.currentIndexthPath.row];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle: @"确定删除吗?"
                                                                   message: nil
                                                            preferredStyle: UIAlertControllerStyleAlert];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定"
                                                   style:UIAlertActionStyleDefault
                                                 handler:^(UIAlertAction *action) {
                                                     [self.dataController deleteDiscoverFindId:self.currentCellModel.findId indexPatch:self.currentIndexthPath Callback:^(NSError *error) {
                                                         if (!error) {
                                                             // 需删除两层数据，上层：subjects 二层：cellViewModels，缺一不可
                                                             [self.viewModel.cellViewModels removeObjectAtIndex:self.currentIndexthPath.row];
                                                             [self.dataController.subjects removeObjectAtIndex:self.currentIndexthPath.row];
                                                             [self.tableView deleteRowAtIndexPath:self.currentIndexthPath withRowAnimation:UITableViewRowAnimationFade];
                                                             
                                                             if ([self.delegate respondsToSelector:@selector(didClickDeleteActionInCell:)]) {
                                                                 [self.delegate didClickDeleteActionInCell:cell];
                                                             }
                                                         }
                                                     }];
                                                     
                                                 }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"cancel", nil)
                                                     style:UIAlertActionStyleCancel
                                                   handler:nil];
    [alert addAction:sure];
    [alert addAction:cancel];
    [App_RootCtr presentViewController:alert animated:YES completion:nil];
}
/// 点击了图片
- (void)didClickContainerImageInCell:(ICDiscoverTableViewVCell *)cell ImageAtIndex:(NSUInteger)index {
    self.currentIndexthPath = [self.tableView indexPathForCell:cell];
    self.currentCellModel = [self.viewModel.cellViewModels objectAtIndex:self.currentIndexthPath.row];
    NSMutableArray *items = [[NSMutableArray alloc] init];
    UIView *fromView = nil;
    ICDiscoverTableViewCellViewModel *model = [self.viewModel.cellViewModels objectAtIndex:self.currentIndexthPath.row];
    for (NSUInteger i = 0; i < model.mediaKeys.count; i++) {
        UIView *imgView = cell.picContainerView.picViews[i];
        YYPhotoGroupItem *item = [YYPhotoGroupItem new];
        item.thumbView = imgView;
        NSString *URL = FILEOGLIMAGE([model.pic.picInfoList objectAtIndex:i][@"k"]);
        item.largeImageURL = [NSURL URLWithString:URL];
        [items addObject:item];
        if (i == index) {
            fromView = imgView;
        }
    }
    YYPhotoGroupView *v = [[YYPhotoGroupView alloc] initWithGroupItems:items];
    [v presentFromImageView:fromView toContainer:App_RootCtr.view fromViewC:self.currentController animated:YES completion:nil];
}

/// 点击了视频 进入播放界面
- (void)didClickVideoImageInCell:(ICDiscoverTableViewVCell *)cell {
    self.currentIndexthPath = [self.tableView indexPathForCell:cell];
    self.currentCellModel = [self.viewModel.cellViewModels objectAtIndex:self.currentIndexthPath.row];
    cell.videoContainerView.playButton.hidden = YES;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:cell.videoContainerView.imageView animated:YES];
    hud.bezelView.alpha = 0.1f;
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    
    ICDiscoverTableViewCellViewModel *vm = [self.viewModel.cellViewModels objectAtIndex:self.currentIndexthPath.row];
    WEAKSELF
    [self.dataController downloadVideo:vm.video.fileKey indexPatch:self.currentIndexthPath progress:^(NSProgress *pro) {
        CGFloat progress = pro.fractionCompleted;
        hud.progress = progress;
    } Callback:^(NSError *error) {
        if (!error) {
        } else {
            cell.videoContainerView.playButton.hidden = NO;
        }
        [hud hideAnimated:YES];
        if ([weakSelf.delegate respondsToSelector:@selector(didClickToPlayerViewWithPath:fromView:)]) {
            [weakSelf.delegate didClickToPlayerViewWithPath:weakSelf.currentCellModel.video.locVideoPath fromView:cell.videoContainerView.imageView];
        }
        [cell reloadStart];
    }];
}

- (void)didClickVideoPlayButtonInCell:(ICDiscoverTableViewVCell *)cell {
    self.currentIndexthPath = [self.tableView indexPathForCell:cell];
    self.currentCellModel = [self.viewModel.cellViewModels objectAtIndex:self.currentIndexthPath.row];
    ICDiscoverTableViewCellViewModel *vm = [self.viewModel.cellViewModels objectAtIndex:self.currentIndexthPath.row];
    cell.videoContainerView.playButton.hidden = YES;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:cell.videoContainerView.imageView animated:YES];
    hud.bezelView.alpha = 0.1f;
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    
    [self.dataController downloadVideo:vm.video.fileKey indexPatch:self.currentIndexthPath progress:^(NSProgress *pro) {
        CGFloat progress = pro.fractionCompleted;
        hud.progress = progress;
    } Callback:^(NSError *error) {
        if (!error) {
        } else {
            cell.videoContainerView.playButton.hidden = NO;
        }
        [cell reloadStart];
        [hud hideAnimated:YES];
    }];
}

/// 点击了 mllink label
- (void)didClickMLLinkLabelInCell:(ICDiscoverTableViewVCell *)cell linkLabel:(MLLinkLabel *)linkLabel link:(MLLink *)link linkText:(NSString *)linkText {
    self.currentIndexthPath = [self.tableView indexPathForCell:cell];
    self.currentCellModel = [self.viewModel.cellViewModels objectAtIndex:self.currentIndexthPath.row];
    if (link.linkType == MLLinkTypeURL) {
        if ([self.delegate respondsToSelector:@selector(didClickToWebViewControllerWithPath:)]) {
            [self.delegate didClickToWebViewControllerWithPath:linkText];
        }
    } else if (link.linkType == MLLinkTypePhoneNumber) {
        [ICTools tel:link.linkValue];
    } else if (link.linkType == MLLinkTypeEmail) {
        
    } else if (![ICTools stringEmpty:link.linkValue]) { // 自定义 可能是链接
        if ([ICTools regularExpressionWithURLString:link.linkValue]) {
            if ([self.delegate respondsToSelector:@selector(didClickToWebViewControllerWithPath:)]) {
                [self.delegate didClickToWebViewControllerWithPath:link.linkValue];
            }
        } else {
            if ([self.delegate respondsToSelector:@selector(didClickToDetailControllerWitheId:)]) {
                [self.delegate didClickToDetailControllerWitheId:link.linkValue];
            }
            
        }
    } else {
        return;
    }
}
/// 点击了详细
- (void)didClickMoreButtonInCell:(ICDiscoverTableViewVCell *)cell {
    self.currentIndexthPath = [self.tableView indexPathForCell:cell];
    self.currentCellModel = [self.viewModel.cellViewModels objectAtIndex:self.currentIndexthPath.row];
    if ([self.delegate respondsToSelector:@selector(didClickToDiscDetailControllerWithFindId:)]) {
        [self.delegate didClickToDiscDetailControllerWithFindId:self.currentCellModel.findId];
    }
}
- (void)didClickCommentCellInCell:(ICDiscoverTableViewVCell *)cell commentCell:(ICDiscoverCellPraise_CommentCell *)CCell indexPath:(NSIndexPath *)indexPath commentModel:(ICCommentModel *)model {
    self.currentIndexthPath = [self.tableView indexPathForCell:cell];
    self.currentCellModel = [self.viewModel.cellViewModels objectAtIndex:self.currentIndexthPath.row];
    if ([[ICUser currentUser].eId isEqualToString:model.eId]) {
        // 自己 删除
        [self deleteUserCommentFindId:self.currentCellModel.findId findCommentId:model.findCommentId];
    } else {
        // 对第三方进行评论
        self.toId = model.eId;
        self.toName = model.eName;
        self.yyTextView.placeholderText = [NSString stringWithFormat:@"回复%@", model.eName];
        ICDiscoverTableViewVCell *cell = [self.tableView cellForRowAtIndexPath:self.currentIndexthPath];
        [self didClickCommentButtonInCell:cell];
    }
}

- (void)deleteComment:(ICCommentModel *)model InCell:(ICDiscoverTableViewVCell *)cell {
    self.currentIndexthPath = [self.tableView indexPathForCell:cell];
    self.currentCellModel = [self.viewModel.cellViewModels objectAtIndex:self.currentIndexthPath.row];
    [self deleteUserCommentFindId:self.currentCellModel.findId findCommentId:model.findCommentId];
}

- (void)replyComment:(ICCommentModel *)model InCell:(ICDiscoverTableViewVCell *)cell {
    self.currentIndexthPath = [self.tableView indexPathForCell:cell];
    self.currentCellModel = [self.viewModel.cellViewModels objectAtIndex:self.currentIndexthPath.row];
    self.toId = model.eId;
    self.toName = model.eName;
    self.yyTextView.placeholderText = [NSString stringWithFormat:@"回复%@", model.eName];
    [self didClickCommentButtonInCell:cell];
}

-(void)didClickCurrentUserHeadImage {
    if ([self.delegate respondsToSelector:@selector(didClickToUserDiscControllerWithUser:)]) {
        [self.delegate didClickToUserDiscControllerWithUser:[ICUser currentUser]];
    }
}
-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
