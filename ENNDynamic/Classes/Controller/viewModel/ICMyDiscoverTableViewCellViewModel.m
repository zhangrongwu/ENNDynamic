//
//  ICMyDiscoverTableViewCellViewModel.m
//  ICome
//
//  Created by zhangrongwu on 16/6/24.
//  Copyright © 2016年 iCom. All rights reserved.
//

#import "ICMyDiscoverTableViewCellViewModel.h"
#import "EnnDynamicHeader.h"
@implementation ICMyDiscoverTableViewCellViewModel
+(nonnull ICMyDiscoverTableViewCellViewModel *)viewModelWithSubject:(nonnull ICDiscoverModel *)subject {
    ICMyDiscoverTableViewCellViewModel *vm = [[ICMyDiscoverTableViewCellViewModel alloc] init];
    // 处理
    vm.eName  = subject.eName;
    vm.eId    = subject.eId;
    vm.findId = subject.findId;
    vm.content     = subject.content;
    vm.contentAttributedString = [subject _kContent];
    NSString * time =  [subject _kCreateDate];
    if([time hasPrefix:@"0"])
    {
        time = [time substringFromIndex:1];;
    }
    vm.createDate  = time;
    vm.mediaKeys   = subject.mediaKeys;
    vm.mediaType   = subject.mediaType;
    vm.praiseList  = subject.praiseList;
    vm.commentList = subject.commentList;
    vm.hiddenCreatDate = subject.hiddenCreatDate;
//    vm.contentHeight = [ICMyDiscoverTableViewCellViewModel cellHeightWithSubject:subject];
    vm.video  = [[ICVideoModel alloc] initWithMedialKeys:subject.mediaKeys]; // 视频初始化
    vm.pic    = [[ICPicModel alloc] initWithMedialKeys:subject.mediaKeys]; // 图片初始化数据
    vm.webPage = [[ICWebPageModel alloc] initWithMedialKeys:subject.mediaKeys];
    vm.photoId = subject.photoId;
    vm.yearTime = @"0";
    return vm;
}

+ (CGFloat)cellHeightWithSubject:(nonnull ICDiscoverModel *)subject {
    return [subject.content sizeForFont:ICFont(14) size:CGSizeMake(DiscContentWidth, CGFLOAT_MAX) mode:NSLineBreakByWordWrapping].height;
}
@end
