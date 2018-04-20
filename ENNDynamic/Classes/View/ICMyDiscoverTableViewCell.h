//
//  ICMyDiscoverTableviewCell.h
//  ICome
//
//  Created by zhangrongwu on 16/6/24.
//  Copyright © 2016年 iCom. All rights reserved.
//

#import "ICMyDiscoverTableViewCellViewModel.h"
#import "EnnDynamicHeader.h"
@class ICMyDiscoverTableViewCell;
@protocol ICMyDiscoverTableViewCellDelegate <NSObject>
@optional
- (void)didClickVideoPlayButtonInCell:(ICMyDiscoverTableViewCell *)cell;
- (void)didClickwebPageViewInCell:(ICMyDiscoverTableViewCell *)cell link:(NSString *)link;
- (void)didClickMLLinkLabelInCell:(ICMyDiscoverTableViewCell *)cell linkLabel:(MLLinkLabel *)linkLabel link:(MLLink *)link linkText:(NSString *)linkText;
@end
@interface ICMyDiscoverTableViewCell : UITableViewCell
@property (nonatomic, strong)UILabel * yearTime;
@property (nonatomic, strong)UIImageView *headImageView;
@property (nonatomic, strong)UIButton *playButton;
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)MLLinkLabel *discLabel;
@property (nonatomic, strong)UILabel *numbLabel;
@property (nonatomic, strong)UIView *sectionView;
@property (nonatomic, strong)UIView *bottomView;
@property (nonatomic, strong)ICMyDiscoverTableViewCellViewModel *viewModel;
@property (nonatomic, weak)id <ICMyDiscoverTableViewCellDelegate> delegate;

@end
