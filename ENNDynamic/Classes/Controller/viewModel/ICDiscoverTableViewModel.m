//
//  ICDiscoverTableViewModel.m
//  ICome
//
//  Created by zhangrongwu on 16/6/17.
//  Copyright © 2016年 iCom. All rights reserved.
//

#import "ICDiscoverTableViewModel.h"
#import "ICDiscoverTableViewCellViewModel.h"

@implementation ICDiscoverTableViewModel
+ (nonnull ICDiscoverTableViewModel *)viewModelWithSubjects:(nonnull NSArray<ICDiscoverModel *>*)subjects {
    NSMutableArray<ICDiscoverTableViewCellViewModel *> *arr = [[NSMutableArray alloc] initWithCapacity:subjects.count];
    [subjects enumerateObjectsUsingBlock:^(ICDiscoverModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [arr addObject:[ICDiscoverTableViewCellViewModel viewModelWithSubject:obj]];
    }];
    
    ICDiscoverTableViewModel *vm = [[ICDiscoverTableViewModel alloc] init];
    vm.cellViewModels = arr;
    return vm;
}

@end

