//
//  ICPraise_CommentView.h
//  ICome
//
//  Created by zhangrongwu on 16/4/13.
//  Copyright © 2016年 iCom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICDiscoverTableViewCellViewModel.h"
#import "ICCommentModel.h"
@interface ICDiscoverCellPraise_CommentCell : UITableViewCell

@property (nonatomic,strong)MLLinkLabel *titleLabel;

@property (nonatomic, strong)ICCommentModel *model;

@property (nonatomic, copy) void (^ClickInCellMLLabelBlock)(MLLink *link, NSString *linkText, MLLinkLabel *label);

@property (nonatomic, copy) void (^LongPressBlock)(UILongPressGestureRecognizer *longPressrec);


@end
// 下方评论 点赞 模块
@interface ICPraise_CommentView : UIView
@property (nonatomic, strong) UIView *endView; // 末尾view

@property (nonatomic, strong) ICDiscoverTableViewCellViewModel *model;

@property (nonatomic, copy) void (^MLTapClickInLabelBlock)(MLLink *link, NSString *linkText, MLLinkLabel *label);

@property (nonatomic, copy) void (^moreButtonClickedBlock)();

@property (nonatomic, copy) void (^CommentCellClickBlock)(NSIndexPath *indexPath, ICCommentModel *model, ICDiscoverCellPraise_CommentCell *cell);

@property (nonatomic, copy) void (^DeleteCommentBlock)(ICCommentModel *model);

@property (nonatomic, copy) void (^ReplyCommentBlock)(ICCommentModel *model);

- (CGFloat)Praise_CommentViewHeight;
@end