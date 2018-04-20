//
//  ICMyDiscoverTableViewCellViewModel.h
//  ICome
//
//  Created by zhangrongwu on 16/6/24.
//  Copyright © 2016年 iCom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ICDiscoverModel.h"
#import "ICVideoModel.h"
#import "ICPicModel.h"
#import "ICWebPageModel.h"
@interface ICMyDiscoverTableViewCellViewModel : NSObject
@property (nonatomic, strong, nonnull)NSString *eName;
@property (nonatomic, strong, nonnull)NSString *findId;
@property (nonatomic, strong, nonnull)NSString *photoId;
@property (nonatomic, strong, nonnull)NSString *eId;
@property (nonatomic, strong, nonnull)NSString *content; // 正文
@property (nonatomic, strong, nonnull)NSAttributedString *contentAttributedString;
@property (nonatomic, strong, nonnull)NSString *createDate; //long time
@property (nonatomic, assign) NSInteger mediaType; // 类型
@property (nonatomic, strong, nonnull)NSArray *mediaKeys; // 多媒体数组
@property (nonatomic, strong, nonnull)NSMutableArray *praiseList; // 点赞
@property (nonatomic, strong, nonnull)NSMutableArray *commentList; // 评论数组
@property (nonatomic, strong, nonnull)ICVideoModel *video;
@property (nonatomic, strong, nonnull)ICPicModel *pic;
@property (nonatomic, strong, nonnull)ICWebPageModel *webPage;
@property (nonatomic, assign)CGFloat contentHeight;
@property (nonatomic, assign)BOOL hiddenCreatDate;
@property (nonatomic, strong, nonnull)NSAttributedString *likeAttributedString;
@property (nonatomic, assign) CGFloat picHeight; //图片高度，0为没图片
@property (nonatomic, assign) CGSize picSize; //每张图片的尺寸
@property (assign, nonatomic) CGFloat picContainerHeight; //总高度
@property (nonatomic,strong,nonnull) NSString * yearTime;

+(nonnull ICMyDiscoverTableViewCellViewModel *)viewModelWithSubject:(nonnull ICDiscoverModel *)subject;

@end
