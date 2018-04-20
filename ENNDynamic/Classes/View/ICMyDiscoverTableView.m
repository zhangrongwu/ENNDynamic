//
//  ICMyDiscoverTableView.m
//  ICome
//
//  Created by zhangrongwu on 16/6/24.
//  Copyright © 2016年 iCom. All rights reserved.
//

#import "ICMyDiscoverTableView.h"
#import "ICMyDiscoverTableViewCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "ICMyDiscoverTableViewCell.h"
#import "ICMyDiscoverTableViewCellViewModel.h"
#import "ICAVPlayer.h"

static NSString *identifier = @"ICMyDiscoverTableViewCell";
@interface ICMyDiscoverTableView ()<UITableViewDelegate, UITableViewDataSource, ICMyDiscoverTableViewCellDelegate>
@property (nonatomic, strong)NSIndexPath *currentIndexthPath;

@end

@implementation ICMyDiscoverTableView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initRefresh];
        [self.tableView registerClass:[ICMyDiscoverTableViewCell class] forCellReuseIdentifier:identifier];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateDiscoverAction:) name:NotificationUpdateDiscoverNews object:nil];
    }
    return self;
}

- (void)initRefresh {
    WEAKSELF;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"hCreatDate"]; // 全局记录历史日期问题
        [[NSUserDefaults standardUserDefaults] synchronize];
        [weakSelf fetchASCFindListData];
    }];
    
//    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(fetchMoreData)];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf fetchFindListData];
    }];
}

- (void)fetchMoreData
{
    [self fetchFindListData];
}

- (void)fetchFindListData {
    ICMyDiscoverTableViewCellViewModel *model = [self.viewModel.cellViewModels lastObject];
    NSString *findId = model.findId == nil ? @"0" : model.findId;
    NSDictionary *param = @{@"findId":findId,
                            @"pageSize":@"10",
                            @"eId":self.user.eId,
                            @"cSize":@"10",
                            @"pSize":@"10"};
    [_dataController requestFindListWithParam:param Callback:^(NSError *error) {
        [self endRefreshing];
    }];
}

- (void)fetchASCFindListData {
    NSDictionary *param = @{@"findId":@"0",
                            @"pageSize":@"10",
                            @"eId":self.user.eId,
                            @"cSize":@"10",
                            @"pSize":@"10"};
    [_dataController requestMyFindListASCWithParam:param Callback:^(NSError *error) {
        [self endRefreshing];
    }];
}
- (void)endRefreshing {
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    self.viewModel = [ICMyDiscoverTableViewModel viewModelWithSubjects:self.dataController.subjects];
    [self reloadData];
}
- (void)reloadData {
    [self.tableView reloadData];
}

- (void)updateDiscoverAction:(NSNotification *)notification {
    [self.tableView.mj_header beginRefreshing];
}

-(void)setViewModel:(ICMyDiscoverTableViewModel *)viewModel {
    _viewModel = viewModel;
}
- (void)didClickVideoPlayButtonInCell:(ICMyDiscoverTableViewCell *)cell {
    self.currentIndexthPath = [self.tableView indexPathForCell:cell];
    ICMyDiscoverTableViewCellViewModel *currentCellModel = [self.viewModel.cellViewModels objectAtIndex:self.currentIndexthPath.row];
    ICMyDiscoverTableViewCellViewModel *vm = [self.viewModel.cellViewModels objectAtIndex:self.currentIndexthPath.row];
    [self.dataController downloadVideo:vm.video.fileKey indexPatch:self.currentIndexthPath progress:^(NSProgress *pro) {
    } Callback:^(NSError *error) {
        if (!error) {
            NSMutableArray *items = [[NSMutableArray alloc] init];
            ICAVPlayerGroupItem *item = [ICAVPlayerGroupItem new];
            item.thumbView = cell.headImageView;
            item.videoPath = currentCellModel.video.locVideoPath;
            [items addObject:item];
            
            ICAVPlayer *player = [[ICAVPlayer alloc] initWithGroupItems:items];
            [player presentFromVideoView:cell.headImageView toContainer:App_RootCtr.view animated:YES completion:nil];
        }
    }];
}
- (void)didClickwebPageViewInCell:(ICMyDiscoverTableViewCell *)cell link:(NSString *)link {
    if ([self.delegate respondsToSelector:@selector(didClickwebPageViewInCell:Path:)]) {
        [self.delegate didClickwebPageViewInCell:cell Path:link];
    }
}

- (void)didClickMLLinkLabelInCell:(ICMyDiscoverTableViewCell *)cell linkLabel:(MLLinkLabel *)linkLabel link:(MLLink *)link linkText:(NSString *)linkText {
    
    
    self.currentIndexthPath = [self.tableView indexPathForCell:cell];
    if (link.linkType == MLLinkTypeURL) {
        if ([self.delegate respondsToSelector:@selector(didClickwebPageViewInCell:Path:)]) {
            [self.delegate didClickwebPageViewInCell:cell Path:link.linkValue];
        }
    } else if (link.linkType == MLLinkTypePhoneNumber) {
        [ICTools tel:link.linkValue];
    } else if (![ICTools stringEmpty:link.linkValue]) { // 自定义 可能是链接
        if ([ICTools regularExpressionWithURLString:link.linkValue]) {
            if ([self.delegate respondsToSelector:@selector(didClickwebPageViewInCell:Path:)]) {
                [self.delegate didClickwebPageViewInCell:cell Path:link.linkValue];
            }
        } else {
            // 自定义问题
        }
    } else {
        return;
    }
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.cellViewModels.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:identifier cacheByIndexPath:indexPath configuration:^(ICMyDiscoverTableViewCell *cell) {
        [self setCell:cell rowAtIndexPath:indexPath];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ICMyDiscoverTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.delegate = self;
    [self setCell:cell rowAtIndexPath:indexPath];
    return cell;
}

- (void)setCell:(ICMyDiscoverTableViewCell *)cell rowAtIndexPath:(NSIndexPath *)indexPath {
    cell.viewModel = [self.viewModel.cellViewModels objectAtIndex:indexPath.row];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ICMyDiscoverTableViewCellViewModel *viewModel = [self.viewModel.cellViewModels objectAtIndex:indexPath.row];
    if ([self.delegate respondsToSelector:@selector(didClickSelectRowAtIndexPath:FindId:)]) {
        [self.delegate didClickSelectRowAtIndexPath:indexPath FindId:viewModel.findId];
    }
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, APP_Frame_Height - 64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.userInteractionEnabled = YES;
        _tableView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_tableView];
    }
    return _tableView;
}


-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
