//
//  ICDiscoverModel.m
//  ICome
//
//  Created by zhangrongwu on 16/6/17.
//  Copyright © 2016年 iCom. All rights reserved.
//

#import "ICDiscoverModel.h"
#import "EnnDynamicHeader.h"

@interface ICDiscoverModel()
@property (nonatomic, strong)NSString *hCreatDate;
@property (nonatomic, strong)NSString *nCreatDate;
@end
@implementation ICDiscoverModel
-(void)setCreatDateHidden {
    self.nCreatDate = [self _kCreateDate];
    self.hCreatDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"hCreatDate"];
    if (![self.hCreatDate isEqualToString:self.nCreatDate]) {
        [[NSUserDefaults standardUserDefaults] setObject:self.nCreatDate forKey:@"hCreatDate"];
        self.hiddenCreatDate = NO;
    } else {
        self.hiddenCreatDate = YES;
    }
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"commentList":@"ICCommentModel",
             @"praiseList":@"ICPraiseModel"};
}

/** 年月*/
-(NSString *)_createYear
{
    NSDate *confromTimesp = [ICDiscoverModel dateFromLongLong:self.createDate];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年"];
    return [dateFormatter stringFromDate:confromTimesp];
}

-(NSString *)_createDate {
    NSDate *confromTimesp = [ICDiscoverModel dateFromLongLong:self.createDate];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    return [dateFormatter stringFromDate:confromTimesp];
}

-(NSString *)_kCreateDate {
    NSDate *confromTimesp = [ICDiscoverModel dateFromLongLong:self.createDate];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM月dd日"];
    NSString *date = @"";
    if ([confromTimesp isToday]) {
        date = @"今天";
    } else {
        date = [dateFormatter stringFromDate:confromTimesp];
    }
    return date;
}
// 处理网页链接
-(NSAttributedString *)_kContent {
    NSMutableAttributedString *sourceText = [NSMutableAttributedString new];
    if (self.content.length) {
        static NSRegularExpression *hrefRegex, *textRegex;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            hrefRegex = [NSRegularExpression regularExpressionWithPattern:@"(?<=href=\').+(?=\'>)" options:kNilOptions error:NULL];
            textRegex = [NSRegularExpression regularExpressionWithPattern:@"(?<=>).+(?=<)" options:kNilOptions error:NULL];
        });
        NSTextCheckingResult *hrefResult, *textResult;
        NSString *href = nil, *text = nil, *newText;
        hrefResult = [hrefRegex firstMatchInString:self.content options:kNilOptions range:NSMakeRange(0, self.content.length)];
        textResult = [textRegex firstMatchInString:self.content options:kNilOptions range:NSMakeRange(0, self.content.length)];
        
        if (hrefResult && textResult && hrefResult.range.location != NSNotFound && textResult.range.location != NSNotFound) {
            href = [self.content substringWithRange:hrefResult.range];
            text = [self.content substringWithRange:textResult.range];
            
            newText = [self.content stringByReplacingCharactersInRange:NSMakeRange((hrefResult.range.location - 9), textResult.range.location+textResult.range.length - (hrefResult.range.location - 9) + 4) withString:text];
        }
        
        
        if (href.length && text.length && newText.length) {
            NSMutableAttributedString *url = [NSMutableAttributedString new];
            [url appendString:newText];
            [sourceText appendAttributedString:url];
            [sourceText setAttributes:@{NSForegroundColorAttributeName : ICRGB(0x5f6f95),NSFontAttributeName : ICFont(15), NSLinkAttributeName :href} range:[newText rangeOfString:text]];
        } else {
            [sourceText appendString:self.content];
        }
    }
    return sourceText;
}

+(NSDate*)dateFromLongLong:(long long)msSince1970 {
    
    return [NSDate dateWithTimeIntervalSince1970:msSince1970 / 1000];
}

@end
