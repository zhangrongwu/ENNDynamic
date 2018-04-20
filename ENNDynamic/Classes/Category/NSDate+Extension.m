//
//  NSDate+Extension.m
//  ICome
//
//  Created by ENN on 16/4/27.
//  Copyright © 2016年 iCom. All rights reserved.
//

#import "NSDate+Extension.h"
#import "NSDateFormatter+Extension.h"
#import "ICCalendarShareTool.h"
#define D_HOUR		3600

@implementation NSDate (Extension)


+ (NSDate *)dateWithTimeIntervalInMilliSecondSince1970:(double)timeIntervalInMilliSecond
{
    NSDate *ret = nil;
    double timeInterval = timeIntervalInMilliSecond;
    // judge if the argument is in secconds(for former data structure).
    if(timeIntervalInMilliSecond > 140000000000) {
        timeInterval = timeIntervalInMilliSecond / 1000;
    }
    ret = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    return ret;
}

-(NSString *)formattedTime
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYYMMdd"];
    NSString * dateNow = [formatter stringFromDate:[NSDate date]];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:[[dateNow substringWithRange:NSMakeRange(6,2)] intValue]];
    [components setMonth:[[dateNow substringWithRange:NSMakeRange(4,2)] intValue]];
    [components setYear:[[dateNow substringWithRange:NSMakeRange(0,4)] intValue]];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *date = [gregorian dateFromComponents:components]; //今天 0点时间
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
     NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSMinuteCalendarUnit | NSCalendarUnitSecond;
#pragma clang diagnostic pop
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:self];
    NSInteger month = comps.month;
    
    
    NSInteger hour = [self hoursAfterDate:date];
    NSDateFormatter *dateFormatter = nil;
    NSString *ret = @"";
    
    //hasAMPM==TURE为12小时制，否则为24小时制
    NSString *formatStringForHours = [NSDateFormatter dateFormatFromTemplate:@"j" options:0 locale:[NSLocale currentLocale]];
    NSRange containsA = [formatStringForHours rangeOfString:@"a"];
    BOOL hasAMPM = containsA.location != NSNotFound;
    
    if (!hasAMPM) { //24小时制
        if (hour <= 24 && hour >= 0) {
            dateFormatter = [NSDateFormatter dateFormatterWithFormat:@"HH:mm"];
        }else if (hour < 0 && hour >= -24) {
            dateFormatter = [NSDateFormatter dateFormatterWithFormat:@"昨天"];
        }else {
            if(month > 9){
                dateFormatter = [NSDateFormatter dateFormatterWithFormat:@"MM月dd日"];
            }else{
                dateFormatter = [NSDateFormatter dateFormatterWithFormat:@"M月dd日"];
            }
        }
    }else {
        if (hour >= 0 && hour <= 6) {
            dateFormatter = [NSDateFormatter dateFormatterWithFormat:@"上午hh:mm"];
        }else if (hour > 6 && hour <=11 ) {
            dateFormatter = [NSDateFormatter dateFormatterWithFormat:@"上午hh:mm"];
        }else if (hour > 11 && hour <= 17) {
            dateFormatter = [NSDateFormatter dateFormatterWithFormat:@"下午hh:mm"];
        }else if (hour > 17 && hour <= 24) {
            dateFormatter = [NSDateFormatter dateFormatterWithFormat:@"下午hh:mm"];
        }else if (hour < 0 && hour >= -24){
            dateFormatter = [NSDateFormatter dateFormatterWithFormat:@"昨天"];
        }else  {
            if(month > 9){
                dateFormatter = [NSDateFormatter dateFormatterWithFormat:@"MM月dd日"];
            }else{
                dateFormatter = [NSDateFormatter dateFormatterWithFormat:@"M月dd日"];
            }
        }
    }
    ret = [dateFormatter stringFromDate:self];
    return ret;
}


- (NSInteger) hoursAfterDate: (NSDate *) aDate
{
    NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
    return (NSInteger) (ti / D_HOUR);
}




+ (BOOL)isSameDay:(NSDate*)date1 date2:(NSDate*)date2
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:date1];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:date2];
    return [comp1 day]   == [comp2 day] &&
    [comp1 month] == [comp2 month] &&
    [comp1 year]  == [comp2 year];
}


+ (NSString *)dateWithFormatter:(NSString *)formatter timeInterval:(NSTimeInterval)timeInterval
{
    NSDateFormatter *format = [NSDateFormatter dateFormatterWithFormat:formatter];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    return [format stringFromDate:date];
}

+ (NSString *)getWholeTimeWithType:(NSDateWholeType)type date:(NSDate *)date
{
    NSString *time = @"";
    if (date != nil) {
        
        //static NSCalendar *calendar;
        static NSInteger unitFlags;
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        
#ifdef __IPHONE_8_0
        //calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        unitFlags = NSCalendarUnitYear |
        NSCalendarUnitMonth |
        NSCalendarUnitDay |
        NSCalendarUnitWeekday |
        NSCalendarUnitHour |
        NSCalendarUnitMinute |
        NSCalendarUnitSecond;
#else
        //calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        unitFlags = NSYearCalendarUnit |
        NSMonthCalendarUnit |
        NSDayCalendarUnit |
        NSWeekdayCalendarUnit |
        NSHourCalendarUnit |
        NSMinuteCalendarUnit |
        NSSecondCalendarUnit;
#endif
        comps = [[ICCalendarShareTool shareCalendar].calendar components:unitFlags fromDate:date];
        NSInteger year=[comps year];
        NSInteger month = [comps month];
        NSInteger day = [comps day];
        NSInteger hour = [comps hour];
        NSInteger minu = [comps minute];
//        NSInteger week = [comps weekday];
        if (type == NSDateWholeTypeToWeb) {
           time = [NSString stringWithFormat:@"%ld-%.2ld-%.2ld %.2ld:%.2ld",year,month,day,hour,minu];
        }else
        {
            time = [NSString stringWithFormat:@"%ld年%.2ld月%.2ld日 %.2ld:%.2ld",year,month,day,hour,minu];
        }
        if (time == nil) {
            
            time = @"";
        }
    }else
    {
        time = @"";
    }
    return time;
}


+ (NSNumber *)convertNumberFromTime:(NSDate *)time
{
    NSNumber *time2 = nil;
    if ((NSObject *)time != [NSNull null] && [time isKindOfClass:[NSDate class]]) {
        long long l = [time timeIntervalSince1970];
        time2 = [NSNumber numberWithDouble:l];
    } else {
        time2 = [NSNumber numberWithDouble:0];
    }
    return time2;
    
}

+ (NSString *)getMondayTime:(NSDate *)date
{
    NSString *time = @"";
    if (date != nil) {
        
        //static NSCalendar *calendar;
        static NSInteger unitFlags;
        NSDateComponents *comps = [[NSDateComponents alloc] init];
#ifdef __IPHONE_8_0
        //calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        unitFlags = NSCalendarUnitYear |
        NSCalendarUnitMonth |
        NSCalendarUnitDay |
        NSCalendarUnitWeekday;
#else
        //calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        unitFlags = NSYearCalendarUnit |
        NSMonthCalendarUnit |
        NSDayCalendarUnit |
        NSWeekdayCalendarUnit;
#endif
        comps = [[ICCalendarShareTool shareCalendar].calendar components:unitFlags fromDate:date];
        NSInteger week = [comps weekday];
        if (week == 1) {
            week = 8;
        }
        NSInteger daycount = week - 2;//addTimeInterval
        NSDate *weekdaybegin = [date dateByAddingTimeInterval:-daycount*60*60*24];
        //周一的日期
        time = [self getFormatTime:weekdaybegin];
        if (time == nil) {
            
            time = @"";
        }
    }else
    {
        time = @"";
    }
    return time;
}

+ (NSString *)getFormatTime:(NSDate *)date
{
    NSString *time = @"";
    if (date != nil) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YYYY-MM-dd"];
        time = [dateFormatter stringFromDate:date];
        if (time == nil) {
            time = @"";
        }
    } else {
        time = @"";
    }
    return time;
}

+ (NSString *)getWholeFormatTime:(NSDate *)date
{
    NSString *time = @"";
    if (date != nil) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YYYY年MM月dd日 EEEE"];
        time = [dateFormatter stringFromDate:date];
        if (time == nil) {
            time = @"";
        }
    } else {
        time = @"";
    }
    return time;
}

+ (NSString *)getHourAndMinTime:(NSDate *)date
{
    NSString *time = @"";
    if (date != nil) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:mm"];
        time = [dateFormatter stringFromDate:date];
        if (time == nil) {
            time = @"";
        }
    } else {
        time = @"";
    }
    return time;
}


+ (NSInteger)getDateType:(NSDateType)type date:(NSDate *)date
{
    NSInteger DateTime = 0;
    if (date != nil) {
        
        //static NSCalendar *calendar;
        static NSInteger unitFlags;
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        
#ifdef __IPHONE_8_0
        //calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        unitFlags = NSCalendarUnitYear |
        NSCalendarUnitMonth |
        NSCalendarUnitDay |
        NSCalendarUnitWeekday;
#else
        //calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        unitFlags = NSYearCalendarUnit |
        NSMonthCalendarUnit |
        NSDayCalendarUnit |
        NSWeekdayCalendarUnit;
#endif
        comps = [[ICCalendarShareTool shareCalendar].calendar components:unitFlags fromDate:date];
        
        switch (type) {
            case NSDateTypeYear:
                
                DateTime = [comps year];
                break;
                
            case NSDateTypeMonth:
                
                DateTime = [comps month];
                break;
                
            case NSDateTypeDay:
                
                DateTime = [comps day];
                break;
                
            case NSDateTypeWeak:{
            
                NSInteger weekDay = [comps weekday];
                DateTime = (weekDay == 1)? 7 : (weekDay -1);
            }
                break;
            default:
                break;
        }
    }
    return DateTime;
}

+ (NSDate *)getSelectedNextDate:(NSDate *)date compareDate:(NSDate *)compareDate
{
    NSDate *weekdayDate = nil;
    if (date != nil) {
        
        //static NSCalendar *calendar;
        static NSInteger unitFlags;
        
        NSDateComponents *comps = [[NSDateComponents alloc] init];
#ifdef __IPHONE_8_0
        //calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        unitFlags = NSCalendarUnitYear |
        NSCalendarUnitMonth |
        NSCalendarUnitDay |
        NSCalendarUnitWeekOfYear|
        NSCalendarUnitWeekday;
#else
        //calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        unitFlags = NSYearCalendarUnit |
        NSMonthCalendarUnit |
        NSDayCalendarUnit |
        NSWeekCalendarUnit|
        NSWeekdayCalendarUnit;
#endif
        
        comps = [[ICCalendarShareTool shareCalendar].calendar components:unitFlags fromDate:date];
        NSInteger day = [comps day];
        if ([date timeIntervalSinceDate:compareDate] > 0.0f) {
            [comps setDay:day - 7];
        }else
        {
            [comps setDay:day + 7];
        }
        weekdayDate = [[ICCalendarShareTool shareCalendar].calendar dateFromComponents:comps];
    }
    return weekdayDate;
}

+ (NSDate *)getSelectedLastDate:(NSDate *)date
{
    NSDate *weekdayDate = nil;
    if (date != nil) {
        
        //static NSCalendar *calendar;
        static NSInteger unitFlags;
        
        NSDateComponents *comps = [[NSDateComponents alloc] init];
#ifdef __IPHONE_8_0
        //calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        unitFlags = NSCalendarUnitYear |
        NSCalendarUnitMonth |
        NSCalendarUnitDay |
        NSCalendarUnitWeekOfYear|
        NSCalendarUnitWeekday;
#else
        //calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        unitFlags = NSYearCalendarUnit |
        NSMonthCalendarUnit |
        NSDayCalendarUnit |
        NSWeekCalendarUnit|
        NSWeekdayCalendarUnit;
#endif
        
        comps = [[ICCalendarShareTool shareCalendar].calendar components:unitFlags fromDate:date];
        NSInteger day = [comps day];
        [comps setDay:day - 7];
        weekdayDate = [[ICCalendarShareTool shareCalendar].calendar dateFromComponents:comps];
    }
    return weekdayDate;
}

+ (NSDate *)getDateTimeFromNumber:(NSNumber *)time
{
    NSDate *time2 = nil;
    if ((NSObject *)time != [NSNull null] && time != nil) {
        time2 = [NSDate dateWithTimeIntervalSince1970:[time doubleValue]];
    }
    return time2;
}

+(long)longFromDate:(NSDate*)date{
    return [date timeIntervalSince1970] * 1000;
}

+(NSDate*)dateFromLongLong:(long long)msSince1970 {
    return [NSDate dateWithTimeIntervalSince1970:msSince1970 / 1000];
}

+ (NSInteger)addMinuteForDate:(NSDate *)date
{
    NSDate *currentDate = [NSDate date];
    NSInteger second = 0;
    NSInteger totalSecond = 0;
    if (date != nil) {
        
        //static NSCalendar *calendar;
        static NSInteger unitFlags;
        NSDateComponents *comps = [[NSDateComponents alloc] init];
#ifdef __IPHONE_8_0
        //calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        unitFlags = NSCalendarUnitHour |
        NSCalendarUnitMinute ;
#else
        //calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        unitFlags = NSHourCalendarUnit |
        NSMinuteCalendarUnit;
#endif        
        comps = [[ICCalendarShareTool shareCalendar].calendar components:unitFlags fromDate:currentDate];
        NSInteger hour = [comps hour];
        NSInteger minute = [comps minute];
        totalSecond = hour*60 + minute;
        
        if (minute >= 1 && minute <= 10) {
            second = 10-minute;
        }
        
        if (minute >= 11 && minute <= 20 ) {
            second = 20-minute;
        }
        
        if (minute >= 21 && minute <= 30 ) {
            second = 30-minute;
        }
        
        if (minute >= 31 && minute <= 40 ) {
            second = 40-minute;
        }
        
        if (minute >= 41 && minute <= 50 ) {
            second = 50-minute;
        }
        
        if (minute >= 51 && minute <= 59 ) {
            
            second = 60-minute;
        }
    }    
    return second+totalSecond;
}

+ (NSDate *)switchDateWithCurrentDate:(NSDate *)date index:(NSInteger)index
{
    NSDate *weekdayDate = nil;
    NSInteger selectedIndex = index +1;
    if (date != nil) {
        
        //static NSCalendar *calendar;
        static NSInteger unitFlags;
        
        NSDateComponents *comps = [[NSDateComponents alloc] init];
#ifdef __IPHONE_8_0
        //calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        unitFlags = NSCalendarUnitYear |
        NSCalendarUnitMonth |
        NSCalendarUnitDay |
        NSCalendarUnitWeekOfYear|
        NSCalendarUnitWeekday;
#else
        //calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        unitFlags = NSYearCalendarUnit |
        NSMonthCalendarUnit |
        NSDayCalendarUnit |
        NSWeekCalendarUnit|
        NSWeekdayCalendarUnit;
#endif
        
        comps = [[ICCalendarShareTool shareCalendar].calendar components:unitFlags fromDate:date];
        NSInteger day = [comps day];
        NSInteger weekDay = [comps weekday];
        NSInteger realWeek = (weekDay == 1)? 7 : (weekDay -1);
        if (realWeek > selectedIndex) {
            [comps setDay:day - (realWeek -selectedIndex)];
        }else if (realWeek == selectedIndex ){
            [comps setDay:day];
        }else
        {
            [comps setDay:day + (selectedIndex-realWeek)];
        }
        weekdayDate = [[ICCalendarShareTool shareCalendar].calendar dateFromComponents:comps];
    }
    return weekdayDate;
}

+ (NSDate *)getDateFromString:(NSString *)strDate
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyy-MM-dd HH:mm";
    [format setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    NSDate *date = [format dateFromString:strDate];
    
    return date;

}
@end
