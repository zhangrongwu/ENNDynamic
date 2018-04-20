//
//  ICDiscoverTableView.h
//  ICome
//
//  Created by zhangrongwu on 16/6/17.
//  Copyright © 2016年 iCom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICDiscoverDataController.h"
#import "ICDiscoverTableViewModel.h"
#import "ICDiscoverTableViewVCell.h"
@class ICDiscoverTableView;
@protocol ICDiscoverTableViewDelegate <NSObject>
@optional
// tableView 的代理
- (void)didClickToDetailControllerWitheId:(NSString *)eId;
- (void)didClickToDiscDetailControllerWithFindId:(NSString *)findId;

- (void)didClickToPlayerViewWithPath:(NSString *)path fromView:(UIView *)fromView;

- (void)didClickToWebViewControllerWithPath:(NSString *)path;
- (void)didClickToUserDiscControllerWithUser:(ICUser *)user;
// 详情页面删除数据后需返回上一层
- (void)didClickDeleteActionInCell:(ICDiscoverTableViewVCell *)cell;
@end

@interface ICDiscoverTableView : UIView
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)YYTextView *yyTextView;
@property (nonatomic, strong)UIViewController *currentController;
@property (nonatomic, strong)ICDiscoverDataController *dataController;

@property (nonatomic, weak)id <ICDiscoverTableViewDelegate>delegate;

@property (nonatomic, strong)ICDiscoverTableViewModel *viewModel;

- (void)reloadData;

@end
