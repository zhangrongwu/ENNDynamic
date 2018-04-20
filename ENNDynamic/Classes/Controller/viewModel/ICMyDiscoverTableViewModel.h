//
//  ICMyDiscoverTableViewModel.h
//  ICome
//
//  Created by zhangrongwu on 16/6/24.
//  Copyright © 2016年 iCom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ICDiscoverModel.h"
#import "ICMyDiscoverTableViewCellViewModel.h"
@interface ICMyDiscoverTableViewModel : NSObject
@property (nonatomic, strong) NSMutableArray<ICMyDiscoverTableViewCellViewModel *> *cellViewModels;

//ICDiscoverModel -- >> ICMyDiscoverTableViewModel -- >> cellViewModels
+(ICMyDiscoverTableViewModel *)viewModelWithSubjects:(NSArray <ICDiscoverModel *>*)subjects;

@end
