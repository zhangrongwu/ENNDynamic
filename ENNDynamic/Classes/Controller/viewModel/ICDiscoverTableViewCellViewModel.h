//
//  ICDiscoverTableViewCellViewModel.h
//  ICome
//
//  Created by zhangrongwu on 16/6/17.
//  Copyright © 2016年 iCom. All rights reserved.
//  装配 view的样式

#import <Foundation/Foundation.h>
#import "ICDiscoverModel.h"
#import "ICPicModel.h"
#import "ICCommentModel.h"
#import "ICVideoModel.h"
#import "ICWebPageModel.h"

@interface ICDiscoverTableViewCellViewModel : NSObject

@property (nonatomic, strong, nonnull)NSString *eName;
@property (nonatomic, strong, nonnull)NSString *findId;
@property (nonatomic, strong, nonnull)NSString *eId;
@property (nonatomic, strong, nonnull)NSString *content; // 正文
@property (nonatomic, strong, nonnull)NSAttributedString *contentAttributedString;
@property (nonatomic, strong, nonnull)NSString *createDate; //long time
@property (nonatomic, assign) NSInteger mediaType; // 类型
@property (nonatomic, strong, nonnull)NSArray *mediaKeys; // 多媒体数组
@property (nonatomic, strong, nonnull)NSMutableArray *praiseList; // 点赞
@property (nonatomic, strong, nonnull)NSMutableArray *commentList; // 评论数组

@property (nonatomic, strong, nonnull)NSString *photoId;// 头像
@property (nonatomic, assign)NSInteger praiseCount;// 点赞数
@property (nonatomic, assign)NSInteger commentCount; // 评论数
@property (nonatomic, assign)NSInteger contentallCount; //正文行数

@property (nonatomic, strong, nonnull)NSAttributedString *likeAttributedString;

@property (nonatomic, assign) CGFloat picHeight; //图片高度，0为没图片
@property (nonatomic, assign) CGSize picSize; //每张图片的尺寸
@property (assign, nonatomic) CGFloat picContainerHeight; //总高度
@property (nonatomic, strong, nonnull)ICPicModel *pic;
@property (nonatomic, strong, nonnull)ICCommentModel *comment;
@property (nonatomic, strong, nonnull)ICVideoModel *video;
@property (nonatomic, strong, nonnull)ICWebPageModel *webPage;
@property (nonatomic, strong, nonnull)NSString *locVideoPath; // 本地视频路径
@property (assign, nonatomic) CGFloat videoContainerHeight; //视频高度

-(nonnull NSAttributedString *)commentsAttributedStringWithIndex:(NSInteger)index;
-(nonnull NSString *)isLike;
-(BOOL)hasComments; // 是否有评论
-(BOOL)hasPraise;  // 是否有赞
- (CGFloat)praiseViewHeight;
+ (nonnull ICDiscoverTableViewCellViewModel *)viewModelWithSubject:(nonnull ICDiscoverModel *)subject;

@end
