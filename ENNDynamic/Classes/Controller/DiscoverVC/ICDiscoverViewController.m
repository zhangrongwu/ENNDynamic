//
//  ICDiscoverViewController.m
//  ICome
//
//  Created by zhangrongwu on 16/6/16.
//  Copyright © 2016年 iCom. All rights reserved.
//  动态动态

#import "ICDiscoverViewController.h"
#import "ICDiscoverDataController.h"
#import "ICShortVideoController.h"
#import "ICDiscoverTableView.h"
#import "ICDiscoverTableViewModel.h"
#import "ICProductionNewsViewController.h"
#import "ICActionSheetView.h"
#import "ICMyDiscoverViewController.h"
#import "ICDiscoverDetailViewController.h"
#import "ICAVPlayer.h"
#import "DynamicConfig.h"

@interface ICDiscoverViewController()<ICDiscoverTableViewDelegate, ICActionSheetViewDelegate>
@property (nonatomic, strong)ICDiscoverDataController *dataController;
@property (nonatomic, strong)ICDiscoverTableView *tableView;
@property (nonatomic, strong)ICActionSheetView *actionSheet;
@end
@implementation ICDiscoverViewController
- (instancetype)init {
    if (self = [super init]) {
        // 动态界面与详细界面共用所有请求、view，所以需区分
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isDisdetailVC"];
        [self removeAVPlayerFlag];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.dataController = [[ICDiscoverDataController alloc] init];
    [self setupContentView];
    [self fetchSubjectData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"showLastNews"];
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
    self.title = NSLocalizedString(@"dynamic", nil);
    //[self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"icon_discover_right_menu"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonAction:)]];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithImageName:@"icon_discover_right_menu" itemType:UIBarButtonItemTypeRight target:self action:@selector(rightButtonAction:)];
}

- (void)setUI {
    self.tableView = [[ICDiscoverTableView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, APP_Frame_Height - 64)];
    self.tableView.dataController = self.dataController;
    self.tableView.currentController = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
}

- (void)fetchSubjectData {
    NSDictionary *param = @{@"findId":@"0",
                            @"pageSize":@"10",
                            @"cSize":@"10",
                            @"pSize":@"20"};
    //[MBProgressHUD showLoadingActivityView:self.view];
    
    __weak typeof(self)weak_self = self;
    [_dataController requestASCFindListWithParam:param Callback:^(NSError *error) {
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [weak_self renderSubjectView];
            });
        }
        //[MBProgressHUD hideLoadingActivityView:self.view];
    }];
}

- (void)renderSubjectView {
    ICDiscoverTableViewModel *viewModel = [ICDiscoverTableViewModel viewModelWithSubjects:self.dataController.subjects];
    self.tableView.viewModel = viewModel;
    [self.tableView reloadData];
}
- (void)ActionSheetView:(ICActionSheetView *)actionSheetView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    WEAKSELF
    if (buttonIndex == 0) {
        [self dyncWithSourceType:NSourceTypeText videoPath:nil];
    } else if (buttonIndex == 1) {
        
        [ICSystemTool checkAudioAuthorizationStatus:^{
           
            ICShortVideoController *vc = [[ICShortVideoController alloc] init];
            vc.finishOperratonBlock = ^(NSString *path) {
                [weakSelf dyncWithSourceType:NSourceTypeVideo videoPath:path];
            };
            UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:vc];
            [weakSelf presentViewController:navi animated:YES completion:nil];
        }];
        
    } else if (buttonIndex == 2) {
        
        [ICSystemTool checkCameraAuthorizationStatus:^{
            
            [weakSelf dyncWithSourceType:NSourceTypeCamera videoPath:nil];
            
        }];

        
    } else if (buttonIndex == 3) {
        
        [ICSystemTool checkPhotoAuthorizationStatus:^{
        
            [weakSelf dyncWithSourceType:NSourceTypePhotoLibrary videoPath:nil];
        }];
    }
}
#pragma mark - event response
- (void)rightButtonAction:(UIButton *)sender {
    [self.tableView.yyTextView resignFirstResponder];
    if (!_actionSheet) {
        _actionSheet = [[ICActionSheetView alloc] initWithTitles:@[NSLocalizedString(@"text", nil),NSLocalizedString(@"videoClips", nil),NSLocalizedString(@"photograph", nil),NSLocalizedString(@"chooseFromAlbum", nil)] delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", nil)];
    }
    [self.actionSheet showInView:[ICTools lastWindow].rootViewController.view];
}

/**
 *  动态添加 页面
 *
 *  @param type Camera = 1, Library = 2, other = 0
 *  @param path video path
 */
- (void)dyncWithSourceType:(NewsSourceType)type
                 videoPath:(NSString *)path {
    ICProductionNewsViewController *vc = [[ICProductionNewsViewController alloc] init];
    vc.newsType = type;
    if (type == NSourceTypeVideo) {
        vc.videoPath = path;
    }
    [self.navigationController pushViewController:vc animated:NO];
}

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

- (void)didClickToDiscDetailControllerWithFindId:(NSString *)findId {
    ICDiscoverDetailViewController *vc = [[ICDiscoverDetailViewController alloc] init];
    WEAKSELF
    vc.tableViewReloadData = ^(ICDiscoverModel *model, NSString *type){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [weakSelf.dataController.subjects enumerateObjectsUsingBlock:^(ICDiscoverModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj.findId isEqualToString:findId]) {
                    if ([type isEqualToString:@"0"]) {
                        [weakSelf.dataController.subjects removeObject:obj];
                    } else {
                        if (model.commentList.count > 10) {
                            [model.commentList removeObjectsInRange:NSMakeRange(0, model.commentList.count - 10)];
                        }
                        
                        [weakSelf.dataController.subjects replaceObjectAtIndex:idx withObject:model];
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf renderSubjectView];
                    });
                }
            }];
        });
    };
    vc.findId = findId;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didClickToUserDiscControllerWithUser:(ICUser *)user {
    ICMyDiscoverViewController *vc = [[ICMyDiscoverViewController alloc] init];
    vc.user = user;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didClickToPlayerViewWithPath:(NSString *)path fromView:(UIView *)fromView {
    if ([self getAVPlayerFlag]) {
        return;
    }
    
    NSMutableArray *items = [[NSMutableArray alloc] init];
    ICAVPlayerGroupItem *item = [ICAVPlayerGroupItem new];
    item.thumbView = fromView;
    item.videoPath = path;
    [items addObject:item];
    
    [self saveAVPlayerFlag:YES];
    ICAVPlayer *player = [[ICAVPlayer alloc] initWithGroupItems:items];
    [player presentFromVideoView:fromView toContainer:App_RootCtr.view animated:YES completion:nil];
}

- (void)didClickToWebViewControllerWithPath:(NSString *)path {
//    [self pushCustomViewControllerURL:path fromViewController:self animated:YES];
}

- (void)saveAVPlayerFlag:(bool)flag {
    [[NSUserDefaults standardUserDefaults] setBool:flag forKey:@"avPlayerFlag"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (bool)getAVPlayerFlag {
    bool flag = [[NSUserDefaults standardUserDefaults] boolForKey:@"avPlayerFlag"];
    return flag;
}

- (void)removeAVPlayerFlag {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"avPlayerFlag"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
