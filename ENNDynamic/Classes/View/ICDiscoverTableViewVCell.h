//
//  ICDiscoverTableViewVCell.h
//  ICome
//
//  Created by zhangrongwu on 16/6/17.
//  Copyright © 2016年 iCom. All rights reserved.
//  动态 cell

#import <UIKit/UIKit.h>
#import "ICDiscoverTableViewCellViewModel.h"
#import "ICStatusDateView.h"
#import "ICPraise_CommentView.h"
#import "ICStatusOperationView.h"
#import "ICPicContainerView.h"
#import "ICVideoContainerView.h"
#import "MLLinkLabel.h"
#import "ICWebPageView.h"
#import "ICDiscoverDataController.h"
@class ICDiscoverTableViewVCell;
@protocol ICDiscoverTableViewVCellDelegate <NSObject>
@optional
- (void)didClickHeadImageInCell:(ICDiscoverTableViewVCell *)cell;

- (void)didClicktitleLabelInCell:(ICDiscoverTableViewVCell *)cell;


- (void)didClickcontentAllButtonInCell:(ICDiscoverTableViewVCell *)cell;

- (void)didClickLikeButtonInCell:(ICDiscoverTableViewVCell *)cell;

- (void)didClickCommentButtonInCell:(ICDiscoverTableViewVCell *)cell;

- (void)didClickDeleteButtonInCell:(ICDiscoverTableViewVCell *)cell;

- (void)didClickVideoImageInCell:(ICDiscoverTableViewVCell *)cell;

- (void)didClickVideoPlayButtonInCell:(ICDiscoverTableViewVCell *)cell;

- (void)didClickMoreButtonInCell:(ICDiscoverTableViewVCell *)cell;

- (void)didClickContainerImageInCell:(ICDiscoverTableViewVCell *)cell ImageAtIndex:(NSUInteger)index;

- (void)didClickMLLinkLabelInCell:(ICDiscoverTableViewVCell *)cell linkLabel:(MLLinkLabel *)linkLabel link:(MLLink *)link linkText:(NSString *)linkText;
- (void)didClickCommentCellInCell:(ICDiscoverTableViewVCell *)cell commentCell:(ICDiscoverCellPraise_CommentCell *)CCell indexPath:(NSIndexPath *)indexPath commentModel:(ICCommentModel *)model;

- (void)deleteComment:(ICCommentModel *)model InCell:(ICDiscoverTableViewVCell *)cell;

- (void)replyComment:(ICCommentModel *)model InCell:(ICDiscoverTableViewVCell *)cell;

- (void)didClickwebPageViewInCell:(ICDiscoverTableViewVCell *)cell link:(NSString *)link;

@end

@interface ICDiscoverTableViewVCell : UITableViewCell

@property (nonatomic, strong) UIImageView *headImageView; // 用户头像
@property (nonatomic, strong) UILabel *nameLabel; // 用户名

@property (nonatomic, strong) UIButton * contentLabelAllbutton;

@property (nonatomic, strong) ICDiscoverDataController *dataController;
@property (nonatomic, strong) MLLinkLabel *contentLabel; // 文本
@property (nonatomic, strong) ICStatusDateView *dateView; // 日期等//timestampLabel
@property (nonatomic, strong) ICPraise_CommentView *commentView; // 评论等
@property (nonatomic, strong) ICStatusOperationView *operationView; // 评论 赞
@property (nonatomic, strong) ICPicContainerView *picContainerView;
@property (nonatomic, strong) ICVideoContainerView *videoContainerView;
@property (nonatomic, strong) ICWebPageView *webPageView;

@property (nonatomic, strong) ICDiscoverTableViewCellViewModel *viewModel;

@property (nonatomic, weak)id <ICDiscoverTableViewVCellDelegate>delegate;


-(void)startVideo;
-(void)reloadStart;
-(void)stopVideo;

@end














