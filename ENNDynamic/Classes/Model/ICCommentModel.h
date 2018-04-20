//
//  ICCommentModel.h
//  ICome
//
//  Created by zhangrongwu on 16/5/6.
//  Copyright © 2016年 iCom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EnnDynamicHeader.h"
@interface ICCommentModel : NSObject

@property (nonatomic, strong)NSString *eId;
@property (nonatomic, strong)NSString *eName;
@property (nonatomic, strong)NSString *findCommentId;
@property (nonatomic, strong)NSString *tId;
@property (nonatomic, strong)NSString *tName; // o评论者姓名（员工姓名)
@property (nonatomic, strong)NSString *comment; // 动态评论内容
@property (nonatomic, assign)CGFloat commentCellHeight;
@property (nonatomic, assign)NSInteger createDate; // 创建时间
-(NSAttributedString *)commentsAttributedString;
- (CGFloat)calculateCellHeight;
@end
