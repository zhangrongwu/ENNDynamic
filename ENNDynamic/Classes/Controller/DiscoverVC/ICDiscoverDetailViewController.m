//
//  ICDiscoverDetailViewController.m
//  ICome
//
//  Created by zhangrongwu on 16/6/16.
//  Copyright © 2016年 iCom. All rights reserved.
//  每条消息详情

#import "ICDiscoverDetailViewController.h"
#import "ICDiscoverDataController.h"
#import "ICShortVideoController.h"
#import "ICDiscoverTableView.h"
#import "ICDiscoverTableViewModel.h"
#import <MediaPlayer/MediaPlayer.h>
#import "ICActionSheetView.h"
#import "ICMyDiscoverViewController.h"
#import "ICDiscoverDetailViewController.h"
#import "ICAVPlayer.h"
@interface ICDiscoverDetailViewController()<ICDiscoverTableViewDelegate, ICActionSheetViewDelegate>
@property (nonatomic, strong)ICDiscoverDataController *dataController;
@property (nonatomic, strong)ICDiscoverTableView *tableView;
@end
@implementation ICDiscoverDetailViewController
-(instancetype)init {
    if (self = [super init]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isDisdetailVC"];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _dataController = [[ICDiscoverDataController alloc] init];
    [self setupContentView];
    [self fetchSubjectData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.tableView.yyTextView resignFirstResponder];
}

- (void)setupContentView {
    [self setNav];
    [self setUI];
}

- (void)setNav {
    self.title = NSLocalizedString(@"details", nil);
   // [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"App_back_blue"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backClick)]];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithImageName:@"App_back_blue" itemType:UIBarButtonItemTypeLeft target:self action:@selector(backClick)];
}

- (void)setUI {
    self.tableView = [[ICDiscoverTableView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, APP_Frame_Height)];
    self.tableView.dataController = self.dataController;
    self.tableView.currentController = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
}

- (void)fetchSubjectData {
    NSString *findId = [NSString stringWithFormat:@"%ld", ([self.findId integerValue]+1)];
    NSDictionary *param = @{@"findId":findId,
                            @"pageSize":@"1",
                            @"cSize":@"100",
                            @"pSize":@"200"};
    [_dataController requestFindListWithParam:param FinishHandle:^(id message) {
        
    } Callback:^(NSError *error) {
        if (!error) {
            [self renderSubjectView];
        }
    }];
}

- (void)renderSubjectView {
    ICDiscoverTableViewModel *viewModel = [ICDiscoverTableViewModel viewModelWithSubjects:self.dataController.subjects];
    self.tableView.viewModel = viewModel;
    [self.tableView reloadData];
}

#pragma mark - event response
- (void)didClickToDetailControllerWitheId:(NSString *)eId {
    
    NSDictionary *param = @{@"eId":eId};
    if ([eId rangeOfString:@"bot"].location == NSNotFound) {
//        UIViewController * vc = [[IComMediator sharedInstance] IComMediator_ContactsDetailViewController:param];
//        [self.navigationController pushViewController:vc animated:YES];
    }else
    {
//        UIViewController *vc = [[IComMediator sharedInstance] IComMediator_RobotDetailViewController:param];
//        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)backClick {
    if (self.tableViewReloadData) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isDisdetailVC"];
        NSString *type = self.dataController.subjects.count == 0? @"0":@"1"; // 类型：0:删除  1:刷新 2:不处理
        self.tableViewReloadData([self.dataController.subjects firstObject], type);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didClickDeleteActionInCell:(ICDiscoverTableViewVCell *)cell {
    [self backClick];
}

- (void)didClickToPlayerViewWithPath:(NSString *)path fromView:(UIView *)fromView {
    NSMutableArray *items = [[NSMutableArray alloc] init];
    ICAVPlayerGroupItem *item = [ICAVPlayerGroupItem new];
    item.thumbView = fromView;
    item.videoPath = path;
    [items addObject:item];
    
    ICAVPlayer *player = [[ICAVPlayer alloc] initWithGroupItems:items];
    [player presentFromVideoView:fromView toContainer:App_RootCtr.view animated:YES completion:nil];
}

- (void)didClickToWebViewControllerWithPath:(NSString *)path {
//    [self pushCustomViewControllerURL:path fromViewController:self animated:YES];
}

@end





