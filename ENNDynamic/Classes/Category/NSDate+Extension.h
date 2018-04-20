//
//  NSDate+Extension.h
//  ICome
//
//  Created by ENN on 16/4/27.
//  Copyright © 2016年 iCom. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger ,NSDateType){
    
    NSDateTypeYear = 1,
    NSDateTypeMonth,
    NSDateTypeDay,
    NSDateTypeWeak
};

typedef NS_ENUM(NSInteger ,NSDateWholeType){
    
    NSDateWholeTypeToWeb = 1,
    NSDateWholeTypeToLocal
};

@interface NSDate (Extension)

/** 设置IM聊天列表时间*/
-(NSString *)formattedTime;

+ (NSDate *)dateWithTimeIntervalInMilliSecondSince1970:(double)timeIntervalInMilliSecond;

+ (BOOL)isSameDay:(NSDate*)date1 date2:(NSDate*)date2;

+ (NSString *)dateWithFormatter:(NSString *)formatter timeInterval:(NSTimeInterval)timeInterval;

///计算时间精确到时 分
+ (NSString *)getWholeTimeWithType:(NSDateWholeType)type date:(NSDate *)date;
+ (NSNumber *)convertNumberFromTime:(NSDate *)time;

///通过日期计算对应周一的日期信息
+ (NSString *)getMondayTime:(NSDate *)date;

+ (NSInteger)getDateType:(NSDateType)type date:(NSDate *)date;

+ (NSDate *)getSelectedNextDate:(NSDate *)date compareDate:(NSDate *)compareDate;

///longTime转NSDate
+ (NSDate *)getDateTimeFromNumber:(NSNumber *)time;
+ (NSString *)getFormatTime:(NSDate *)date;
+ (NSString *)getHourAndMinTime:(NSDate *)date;
+ (NSString *)getWholeFormatTime:(NSDate *)date;
+(long)longFromDate:(NSDate*)date;
+(NSDate*)dateFromLongLong:(long long)msSince1970;
+ (NSInteger)addMinuteForDate:(NSDate *)date;
+ (NSDate *)switchDateWithCurrentDate:(NSDate *)date index:(NSInteger)index;

+ (NSDate *)getSelectedLastDate:(NSDate *)date;

+ (NSDate *)getDateFromString:(NSString *)strDate;
@end
