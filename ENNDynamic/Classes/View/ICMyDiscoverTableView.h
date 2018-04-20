//
//  ICMyDiscoverTableView.h
//  ICome
//
//  Created by zhangrongwu on 16/6/24.
//  Copyright © 2016年 iCom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICMyDiscvoerDataController.h"
#import "ICMyDiscoverTableViewModel.h"
#import "ICMyDiscoverTableViewCell.h"
#import "EnnDynamicHeader.h"
@class ICMyDiscoverTableView;
@protocol ICMyDiscoverTableViewDelegate <NSObject>
@optional
- (void)didClickSelectRowAtIndexPath:(NSIndexPath *)indexPath FindId:(NSString *)findId;

- (void)didClickwebPageViewInCell:(ICMyDiscoverTableViewCell *)cell Path:(NSString *)path;
@end
@interface ICMyDiscoverTableView : UIView

@property (nonatomic, strong)ICMyDiscvoerDataController *dataController;

@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong)ICMyDiscoverTableViewModel *viewModel;

@property (nonatomic, weak)id <ICMyDiscoverTableViewDelegate> delegate;

@property (nonatomic, strong)ICUser *user;


@end
