//
//  NSDateFormatter+Extension.m
//  ICome
//
//  Created by ENN on 16/4/27.
//  Copyright © 2016年 iCom. All rights reserved.
//

#import "NSDateFormatter+Extension.h"

@implementation NSDateFormatter (Extension)

+ (id)dateFormatterWithFormat:(NSString *)dateFormat
{
    NSDateFormatter *dateFormatter = [[self alloc] init];
    dateFormatter.dateFormat = dateFormat;
    return dateFormatter;
}









@end
