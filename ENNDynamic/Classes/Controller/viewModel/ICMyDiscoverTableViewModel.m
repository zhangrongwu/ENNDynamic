//
//  ICMyDiscoverTableViewModel.m
//  ICome
//
//  Created by zhangrongwu on 16/6/24.
//  Copyright © 2016年 iCom. All rights reserved.
//

#import "ICMyDiscoverTableViewModel.h"
#import "ICMyDiscoverTableViewCellViewModel.h"
#import "ICDiscoverModel.h"
@implementation ICMyDiscoverTableViewModel
+(ICMyDiscoverTableViewModel *)viewModelWithSubjects:(NSArray <ICDiscoverModel *>*)subjects {
    
    NSMutableArray<ICMyDiscoverTableViewCellViewModel *> *arr = [[NSMutableArray alloc] initWithCapacity:subjects.count];
    __block NSString * yeartime = @"0";
    [subjects enumerateObjectsUsingBlock:^(ICDiscoverModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ICMyDiscoverTableViewCellViewModel * model =[ICMyDiscoverTableViewCellViewModel viewModelWithSubject:obj];
        if(![yeartime isEqualToString:@"0"])
        {
            if(![[obj _createYear] isEqualToString:yeartime])
            {
                model.yearTime = [obj _createYear];
            }
        }
        [arr addObject:model];
        
        yeartime = [obj _createYear];

    }];
    
    ICMyDiscoverTableViewModel *vm  = [[ICMyDiscoverTableViewModel alloc] init];
    vm.cellViewModels = arr;
    return vm;
}
@end
