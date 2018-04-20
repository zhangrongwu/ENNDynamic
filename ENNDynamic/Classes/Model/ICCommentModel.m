//
//  ICCommentModel.m
//  ICome
//
//  Created by zhangrongwu on 16/5/6.
//  Copyright © 2016年 iCom. All rights reserved.
//

#import "ICCommentModel.h"

@implementation ICCommentModel
-(NSAttributedString *)commentsAttributedString {
    if (![ICTools stringEmpty:self.comment]) {
        NSString *eName = self.eName;
        if (self.tName.length) {
            eName = [eName stringByAppendingString:[NSString stringWithFormat:@"回复%@", self.tName]];
        }
        eName = [eName stringByAppendingString:[NSString stringWithFormat:@" : %@", self.comment]];
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:eName];
        attString.font = ICFont(14);
        UIColor *highLightColor = ICRGB(0x606F95);
        [attString setAttributes:@{NSForegroundColorAttributeName : highLightColor,NSFontAttributeName : ICFont(14), NSLinkAttributeName :self.eId} range:[eName rangeOfString:self.eName]];
        if (self.tName) {
            [attString setAttributes:@{NSForegroundColorAttributeName : highLightColor,NSFontAttributeName : ICFont(14), NSLinkAttributeName : self.tId} range:[eName rangeOfString:self.tName]];
        }
        return attString;
    }
    return [[NSMutableAttributedString alloc] init];
}

- (CGFloat)calculateCellHeight {
    return [[[self commentsAttributedString] string] sizeForFont:ICFont(14) size:CGSizeMake(DiscContentWidth, CGFLOAT_MAX) mode:NSLineBreakByWordWrapping].height + 5;
}
@end



