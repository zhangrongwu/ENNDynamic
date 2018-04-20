//
//  ICStatusDateView.h
//  ICome
//
//  Created by zhangrongwu on 16/4/13.
//  Copyright © 2016年 iCom. All rights reserved.
//

#import <UIKit/UIKit.h>
// 中间 日期等细小控件
@interface ICStatusDateView : UIView
@property (nonatomic, strong) UILabel *dateLabel; // 日期等
@property (nonatomic, strong) UIButton *deleteButton; // 删除按钮
@property (nonatomic, strong) UIButton *operationButton; // 打开评论...

@property (nonatomic, copy) void (^deleteButtonClickedBlock)();
@property (nonatomic, copy) void (^operationButtonClickedBlock)();

@end
