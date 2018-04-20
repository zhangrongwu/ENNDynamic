//
//  ICMyDiscoverViewController.m
//  ICome
//
//  Created by zhangrongwu on 16/6/23.
//  Copyright © 2016年 iCom. All rights reserved.
//

#import "ICMyDiscoverViewController.h"
#import "ICMyDiscvoerDataController.h"
#import "ICMyDiscoverTableView.h"
#import "ICDiscoverDetailViewController.h"
#import "ICActionSheetView.h"
#import "ICShortVideoController.h"
#import "ICProductionNewsViewController.h"
#import "DynamicConfig.h"

@interface ICMyDiscoverViewController ()<ICMyDiscoverTableViewDelegate, ICActionSheetViewDelegate>

@property (nonatomic, strong)ICMyDiscvoerDataController *dataController;

@property (nonatomic, strong)ICMyDiscoverTableView *tableView;
@property (nonatomic, strong)ICActionSheetView *actionSheet;


@end

@implementation ICMyDiscoverViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"hCreatDate"]; // 全局记录历史日期问题
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _dataController = [[ICMyDiscvoerDataController alloc] init];
    [self setupContentView];
    [self fetchSubjectData];
}

- (void)setupContentView {
    [self setNav];
    [self setUI];
}

- (void)setNav {
    self.title = [NSString stringWithFormat:@"%@的动态", self.user.eName];
    if ([self.user.eId isEqualToString:[ICUser currentUser].eId]) {
        
       // [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"icon_discover_right_menu"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonAction:)]];

        self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithImageName:@"icon_discover_right_menu" itemType:UIBarButtonItemTypeRight target:self action:@selector(rightButtonAction:)];
    }
}

- (void)setUI {
    self.tableView = [[ICMyDiscoverTableView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, APP_Frame_Height)];
    self.tableView.dataController = self.dataController;
    self.tableView.delegate = self;
    self.tableView.user = self.user;
    [self.view addSubview:self.tableView];
}

- (void)fetchSubjectData {
    NSDictionary *param = @{@"eId":self.user.eId,
                            @"findId":@"0",
                            @"pageSize":@"10",
                            @"cSize":@"10",
                            @"pSize":@"10"};
    [_dataController requestFindListWithParam:param Callback:^(NSError *error) {
        if (!error) {
            [self renderSubjectView];
            if (self.dataController.subjects.count > 0) {
//                self.tableView.emptyView.hidden = YES;
            } else {
//                self.tableView.emptyView.hidden = NO;
            }
        }
    }];
}

- (void)renderSubjectView {
    ICMyDiscoverTableViewModel *viewModel = [ICMyDiscoverTableViewModel viewModelWithSubjects:self.dataController.subjects];
    self.tableView.viewModel = viewModel;
    [self.tableView.tableView reloadData];
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

- (void)dyncWithSourceType:(NewsSourceType)type
                 videoPath:(NSString *)path {
    ICProductionNewsViewController *vc = [[ICProductionNewsViewController alloc] init];
    vc.newsType = type;
    if (type == NSourceTypeVideo) {
        vc.videoPath = path;
    }
    [self.navigationController pushViewController:vc animated:NO];
}

#pragma mark - event response
- (void)rightButtonAction:(UIButton *)sender {
    if (!_actionSheet) {
        _actionSheet = [[ICActionSheetView alloc] initWithTitles:@[NSLocalizedString(@"text", nil),NSLocalizedString(@"videoClips", nil),NSLocalizedString(@"photograph", nil),NSLocalizedString(@"chooseFromAlbum", nil)] delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", nil)];
    }
    [self.actionSheet showInView:[ICTools lastWindow].rootViewController.view];
}

- (void)didClickSelectRowAtIndexPath:(NSIndexPath *)indexPath FindId:(NSString *)findId {
    WEAKSELF;
    ICDiscoverDetailViewController *vc = [[ICDiscoverDetailViewController alloc] init];
    vc.tableViewReloadData = ^(ICDiscoverModel *model, NSString *type){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [weakSelf.dataController.subjects enumerateObjectsUsingBlock:^(ICDiscoverModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj.findId isEqualToString:findId]) {
                    if ([type isEqualToString:@"0"]) {
                        if (!obj.hiddenCreatDate) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationUpdateDiscoverNews object:nil];
                            });
                        } else {
                            [weakSelf.dataController.subjects removeObject:obj];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [weakSelf renderSubjectView];
                            });
                        }
                    }
                }
            }];
        });
    };
    vc.findId = findId;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didClickwebPageViewInCell:(ICMyDiscoverTableViewCell *)cell Path:(NSString *)path {
//    [self pushCustomViewControllerURL:path fromViewController:self animated:YES];
}

@end




