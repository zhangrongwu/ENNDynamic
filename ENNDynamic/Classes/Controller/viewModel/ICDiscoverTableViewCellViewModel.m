//
//  ICDiscoverTableViewCellViewModel.m
//  ICome
//
//  Created by zhangrongwu on 16/6/17.
//  Copyright © 2016年 iCom. All rights reserved.
//

#import "ICDiscoverTableViewCellViewModel.h"
#import "ICPraiseModel.h"
#import "ICVideoManager.h"
#import "ICMediaManager.h"
#import "ICCommentModel.h"

@implementation ICDiscoverTableViewCellViewModel
+ (nonnull ICDiscoverTableViewCellViewModel *)viewModelWithSubject:(nonnull ICDiscoverModel *)subject {
    // 处理model与view关系
    ICDiscoverTableViewCellViewModel *vm = [[ICDiscoverTableViewCellViewModel alloc] init];
    vm.eName  = subject.eName;
    vm.eId    = subject.eId;
    vm.findId = subject.findId;
    vm.pic    = [[ICPicModel alloc] initWithMedialKeys:subject.mediaKeys]; // 图片初始化数据
    vm.video  = [[ICVideoModel alloc] initWithMedialKeys:subject.mediaKeys]; // 视频初始化
    vm.webPage= [[ICWebPageModel alloc] initWithMedialKeys:subject.mediaKeys];
    vm.comment= [[ICCommentModel alloc] init];
    vm.content     = subject.content;
    vm.contentallCount = subject.contentallCount;
    vm.contentAttributedString = [subject _kContent];
    vm.createDate  = [subject _createDate];
    vm.mediaKeys   = subject.mediaKeys;
    vm.mediaType   = subject.mediaType;
    vm.praiseList  = subject.praiseList;
    vm.commentList = subject.commentList;
    vm.photoId = subject.photoId;
    vm.praiseCount = subject.praiseCount;
    vm.commentCount= subject.commentCount;
    vm.likeAttributedString = [ICDiscoverTableViewCellViewModel likeAttributedStringViewModelWithSubject:subject];
    return vm;
}

+(NSAttributedString *)likeAttributedStringViewModelWithSubject:(nonnull ICDiscoverModel *)subject  {
    if (subject.praiseList.count > 0 ) {
        NSTextAttachment *attachment = [NSTextAttachment new];
        attachment.image = [UIImage imageNamed:@"icon_discover_support"];
        attachment.bounds = CGRectMake(0, -3, 16, 16);
        NSAttributedString *likeIcon = [NSAttributedString attributedStringWithAttachment:attachment];
        NSMutableAttributedString *likeAttributedString = [[NSMutableAttributedString alloc] init];
        [likeAttributedString appendAttributedString:likeIcon];

        for (ICPraiseModel *model in  subject.praiseList) {
            [likeAttributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
            NSString *eName = model.eName;
            NSString *eId = model.eId;
            NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:eName];
            UIColor *highLightColor = [UIColor blueColor];
            [attString setAttributes:@{NSForegroundColorAttributeName : highLightColor, NSLinkAttributeName : eId} range:[eName rangeOfString:eName]];
            [likeAttributedString appendAttributedString:attString];
        }
        return likeAttributedString;
    }
    return [[NSMutableAttributedString alloc] init];
}

-(nonnull NSAttributedString *)commentsAttributedStringWithIndex:(NSInteger)index {
    if (self.commentList.count > 0) {
        ICCommentModel *model = [self.commentList objectAtIndex:index];
        NSString *eName = model.eName;
        if (model.tName.length) {
            eName = [eName stringByAppendingString:[NSString stringWithFormat:@"回复%@", model.tName]];
        }
        eName = [eName stringByAppendingString:[NSString stringWithFormat:@" : %@", model.comment]];
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:eName];
        attString.font = ICFont(14);
        UIColor *highLightColor = ICRGB(0x606F95);
        [attString setAttributes:@{NSForegroundColorAttributeName : highLightColor,NSFontAttributeName : ICFont(14), NSLinkAttributeName :model.eId} range:[eName rangeOfString:model.eName]];
        if (model.tName) {
            [attString setAttributes:@{NSForegroundColorAttributeName : highLightColor,NSFontAttributeName : ICFont(14), NSLinkAttributeName : model.tId} range:[eName rangeOfString:model.tName]];
        }
        // 若动态评论文字颜色与链接颜色相同时 需到 MLLinkLabel中找到对应的方法 根据id更该颜色: if ([link.linkValue hasPrefix:@"_"]) {}
        NSString *commContentId = [NSString stringWithFormat:@"_%@_%@_%@", model.findCommentId,model.eId,model.eName];
        [attString setAttributes:@{NSForegroundColorAttributeName : ICRGB(0x9a9a9a), NSFontAttributeName : ICFont(14),
                                   NSLinkAttributeName : commContentId} range:[eName rangeOfString:model.comment]];
        return attString;
    }
    return [[NSMutableAttributedString alloc] init];
}

-(NSString *)isLike {
    NSString *isLike = @"赞";
    for (ICPraiseModel *model in self.praiseList) {
        if ([model.eId isEqualToString:[ICUser currentUser].eId]) {
            isLike = NSLocalizedString(@"cancel", nil);
        }
    }
    return isLike;
}

-(BOOL)hasComments {
    return self.commentList.count > 0 ? YES : NO;
}
-(BOOL)hasPraise {
    return self.praiseList.count > 0 ? YES : NO;
}

- (CGFloat)praiseViewHeight {
    return [[self.likeAttributedString string] sizeForFont:ICFont(14) size:CGSizeMake(DiscContentWidth, CGFLOAT_MAX) mode:NSLineBreakByWordWrapping].height;
}

@end
