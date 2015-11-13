//
//  NSDate+Expend.h
//  BodyScaleBLE
//
//  Created by Jason on 13-1-30.
//  Copyright (c) 2013年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Expend)

+(int)getDaysFrom1970:(NSString*)dateString;
+(NSDate *)getDateByDayPassedFrom1970:(int)passDays;
+(NSDate *)getDateByTimePassedFrom1970:(long long)passTime;
+(int)getCurrentYear;
+(int)getCurrentMonth;
+(int)getCurrentDay;
+(int)getCurrentHour;
+(int)getCurrentMin;
+(int)getCurrentSecond;
+(NSDate*)preDay:(NSDate*)nowDate Days:(int)dayLength;
+(NSDate*)nextDay:(NSDate*)nowDate Days:(int)dayLength;
+(NSUInteger)getWeekdayFromDate:(NSDate*)date;
-(int)getYear;
-(int)getMon;
-(int)getDay;
-(int)getHour;
-(int)getMin;
-(int)getSecond;
-(int)getGeoYear;
-(int)getGeoMon;
-(int)getGeoDay;
+(NSDate *)getPriousorLaterDateFromDate:(NSDate *)date withMonth:(int)month;
- (BOOL)sameWeekWithDate:(NSDate *)otherDate;
+(NSString*)getEngMon:(int)monNum;


/**
 *  将字符串转化为NSDate对象
 */
+ (NSDate *)getDateWithFormat:(NSString *)format andString:(NSString *)string;
/**
 *  将NSDate转化为字符串对象
 */
+ (NSString *)getStringWithFormat:(NSString *)format andDate:(NSDate *)date;
/**
 *  将出生年月转化为年龄
 */
+(NSInteger)getCurrentAgeFromBirthdayDate:(NSDate *)date;
/**
 *  获取某天的时间信息 (格式为1990/01/01 周一)
 */
+ (NSString *)getTimeInfoWithDate:(NSDate *)date;
/**
 *  获取某个日期所在星期的时间范围 (数组第一项为周日 第二项为周六)
 */
+ (NSArray *)getWeekRangeArrWithDate:(NSDate *)date;
/**
 *  获取每月的总天数
 *
 *  @param month 月份(yyyyMM)
 *
 *  @return 总天数
 */
+(NSInteger )getDayWithMonth:(NSInteger)month;

@end
