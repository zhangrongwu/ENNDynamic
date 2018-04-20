//
//  ICMyDiscvoerDataController.h
//  ICome
//
//  Created by zhangrongwu on 16/6/24.
//  Copyright © 2016年 iCom. All rights reserved.
//

#import "ICBaseDataController.h"
#import "ICDiscoverModel.h"
@interface ICMyDiscvoerDataController : ICBaseDataController
@property (nonatomic, strong) NSMutableArray<ICDiscoverModel *> *subjects;
- (void)requestFindListWithParam:(NSDictionary *)dict
                        Callback:(ICCompletionCallback)callback;
- (void)requestMyFindListASCWithParam:(NSDictionary *)dict
                             Callback:(ICCompletionCallback)callback;
- (void)downloadVideo:(NSString *)fileKey
           indexPatch:(NSIndexPath *)indexPatch
             progress:(Progress)progress
             Callback:(ICCompletionCallback)callback;
@end
