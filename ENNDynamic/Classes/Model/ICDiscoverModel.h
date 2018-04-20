//
//  ICDiscoverModel.h
//  ICome
//
//  Created by zhangrongwu on 16/6/17.
//  Copyright © 2016年 iCom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ICDiscoverModel : NSObject

@property (nonatomic, strong)NSString *findId;
@property (nonatomic, strong)NSString *eId;
@property (nonatomic, strong)NSString *eName;
@property (nonatomic, strong)NSString *content; // 正文
@property (nonatomic, assign)NSInteger contentallCount; //正文行数
@property (nonatomic, assign)NSInteger createDate; //long time
@property (nonatomic, assign)NSInteger mediaType; // 类型
@property (nonatomic, strong)NSArray *mediaKeys; // 多媒体数组
@property (nonatomic, strong)NSMutableArray *praiseList; // 点赞
@property (nonatomic, strong)NSMutableArray *commentList; // 评论数组
@property (nonatomic, strong)NSString *photoId;// 头像
@property (nonatomic, assign)NSInteger praiseCount;// 点赞数
@property (nonatomic, assign)NSInteger commentCount; // 评论数

@property (nonatomic, strong) NSString *locVideoPath; // 本地视频路径

@property (nonatomic, assign)BOOL hiddenCreatDate;

-(NSString *)_createYear;
-(NSString *)_createDate;
-(NSString *)_kCreateDate;
-(NSAttributedString *)_kContent;
-(void)setCreatDateHidden;

@end
