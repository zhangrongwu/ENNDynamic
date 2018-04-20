//
//  ICMyDiscvoerDataController.m
//  ICome
//
//  Created by zhangrongwu on 16/6/24.
//  Copyright © 2016年 iCom. All rights reserved.
//

#import "ICMyDiscvoerDataController.h"
#import "ICVideoManager.h"
#import "MBProgressHUD+Tool.h"
#import "ICDynamicNetworkManager.h"
#import "EnnDynamicHeader.h"
@implementation ICMyDiscvoerDataController

- (void)requestFindListWithParam:(NSDictionary *)dict
                        Callback:(ICCompletionCallback)callback {
    [[ICDynamicNetworkManager sharedInstance] requestMyFindListWithParam:dict Success:^(BOOL isSuccess, NSArray *findList) {
        if (isSuccess) {
            [self.subjects addObjectsFromArray:findList];
            callback(nil);
        } else {
            NSError *err;
            callback(err);
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"请求失败"];
        callback(error);
    }];
}

- (void)requestMyFindListASCWithParam:(NSDictionary *)dict
                           Callback:(ICCompletionCallback)callback {
    [[ICDynamicNetworkManager sharedInstance] requestMyFindListASCWithParam:dict Success:^(BOOL isSuccess, NSArray *findList) {
        if (isSuccess) {
            [self.subjects removeAllObjects];
            [self.subjects insertObjects:findList atIndex:0];
            callback(nil);
        } else {
            NSError *err;
            callback(err);
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"请求失败"];
        callback(error);
    }];
}

- (void)downloadVideo:(NSString *)fileKey
           indexPatch:(NSIndexPath *)indexPatch
             progress:(Progress)progress
             Callback:(ICCompletionCallback)callback {
    // 下载视频
    NSString *path = [[ICVideoManager shareManager] videoPathWithFileName:fileKey fileDir:kDiscvoerVideoPath];
    NSData *data = [NSData dataWithContentsOfFile:path];
    if (!data && ![ICTools stringEmpty:fileKey]) { // 本地没数据 进行网络请求
        [[ICNetworkManager sharedInstance] downloadMedia:fileKey fileDir:kDiscvoerVideoPath progress:^(NSProgress *pro) {
            progress(pro);
        } success:^(id object) {
            if (object) {
                ICDiscoverModel *model = [self.subjects objectAtIndex:indexPatch.row];
                model.locVideoPath = path;
                callback(nil);
            } else {
                NSError *error;
                callback(error);
            }
        } failure:^(NSError *error) {
            [MBProgressHUD showError:@"下载失败"];
        }];
    } else {
        callback(nil);
    }
}

-(NSMutableArray<ICDiscoverModel *> *)subjects {
    if (!_subjects) {
        _subjects = [[NSMutableArray alloc] init];
    }
    return _subjects;
}
@end
