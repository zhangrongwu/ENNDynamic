//
//  ICDiscoverTableViewModel.h
//  ICome
//
//  Created by zhangrongwu on 16/6/17.
//  Copyright © 2016年 iCom. All rights reserved.
//  装配 tableview 到 tableviwcell 的 veiw 中

#import <Foundation/Foundation.h>
#import "ICDiscoverModel.h"
#import "ICDiscoverTableViewCellViewModel.h"
@interface ICDiscoverTableViewModel : NSObject
// 处理后的viewmodel
@property (nonatomic, strong, nonnull) NSMutableArray<ICDiscoverTableViewCellViewModel *> *cellViewModels;

+ (nonnull ICDiscoverTableViewModel *)viewModelWithSubjects:(nonnull NSArray<ICDiscoverModel *>*)subjects;

@end
