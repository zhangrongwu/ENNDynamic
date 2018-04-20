//
//  ICCellOperationView.h
//  ICome
//
//  Created by zhangrongwu on 16/4/13.
//  Copyright © 2016年 iCom. All rights reserved.
//

#import <UIKit/UIKit.h>
// 操作view
@interface ICStatusOperationView : UIView
@property (nonatomic, assign, getter = isShowing) BOOL show;
@property (nonatomic, strong)UIButton *likeButton; // 赞 按钮
@property (nonatomic, strong)UIButton *commentButton; // 评论 按钮

@property (nonatomic, copy) void (^likeButtonClickedOperation)();
@property (nonatomic, copy) void (^commentButtonClickedOperation)();
@end
