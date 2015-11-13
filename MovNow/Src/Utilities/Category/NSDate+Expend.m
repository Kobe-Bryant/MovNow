//
//  NSDate+Expend.m
//  BodyScaleBLE
//
//  Created by Jason on 13-1-30.
//  Copyright (c) 2013年 Jason. All rights reserved.
//

#import "NSDate+Expend.h"

@implementation NSDate (Expend)

+(int)getDaysFrom1970:(NSString*)dateString
{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date1=[dateFormatter dateFromString:@"1970-1-1"];
    NSDate *date2=[dateFormatter dateFromString:dateString];
    NSTimeInterval time=[date2 timeIntervalSinceDate:date1];
    int days=((int)time)/(3600*24);
    return days;
}

+(NSDate *)getDateByDayPassedFrom1970:(int)passDays
{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date1=[dateFormatter dateFromString:@"1970-1-1"];
    NSDate *date2=[date1 dateByAddingTimeInterval:passDays*3600*24];
    return date2;
}

+(NSDate *)getDateByTimePassedFrom1970:(long long)passTime
{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date1=[dateFormatter dateFromString:@"1970-1-1"];
    NSDate *date2=[date1 dateByAddingTimeInterval:passTime];
    return date2;
}

+(int)getCurrentYear
{
    NSDate *now = [NSDate date];
    NSLog(@"now date is: %@", now);
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    int year = (int)[dateComponent year];
    return year;
}

+(int)getCurrentMonth
{
    NSDate *now = [NSDate date];
    NSLog(@"now date is: %@", now);
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    int month = (int)[dateComponent month];
    return month;
}

+(int)getCurrentDay
{
    NSDate *now = [NSDate date];
    NSLog(@"now date is: %@", now);
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    int day = (int)[dateComponent day];
    return day;
}

+(int)getCurrentHour
{
    NSDate *now = [NSDate date];
    NSLog(@"now date is: %@", now);
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    int hour = (int)[dateComponent hour];
    return hour;

}

+(int)getCurrentMin
{
    NSDate *now = [NSDate date];
    NSLog(@"now date is: %@", now);
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    int min = (int)[dateComponent minute];
    return min;

}

+(int)getCurrentSecond
{
    NSDate *now = [NSDate date];
    NSLog(@"now date is: %@", now);
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    int second = (int)[dateComponent second];
    return second;
}

+(NSDate*)preDay:(NSDate*)nowDate Days:(int)dayLength
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];
    NSString * reportDate = [format stringFromDate:nowDate];
    NSDate *date = [format dateFromString:reportDate];
    NSDate *newDate = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:([date timeIntervalSinceReferenceDate] - 24*3600*dayLength)];
    reportDate = [format stringFromDate:newDate];
    return newDate;
}

+(NSDate*)nextDay:(NSDate*)nowDate Days:(int)dayLength
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];
    NSString * reportDate = [format stringFromDate:nowDate];
    NSDate *date = [format dateFromString:reportDate];
    NSDate *newDate = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:([date timeIntervalSinceReferenceDate] + 24*3600*dayLength)];
    reportDate = [format stringFromDate:newDate];
    return newDate;
}

+(NSUInteger)getWeekdayFromDate:(NSDate*)date
{
    
    NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents* components = [[NSDateComponents alloc] init];
    
    NSInteger unitFlags = NSYearCalendarUnit |
    
    NSMonthCalendarUnit |
    
    NSDayCalendarUnit |
    
    NSWeekdayCalendarUnit |
    
    NSHourCalendarUnit |
    
    NSMinuteCalendarUnit |
    
    NSSecondCalendarUnit;
    
    
    
    components = [calendar components:unitFlags fromDate:date];
    
    NSUInteger weekday = [components weekday];
    
    return weekday;
    
}

-(int)getYear
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:self];
    return (int)[components year];
}

-(int)getMon
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:self];
    return (int)[components month];
}

-(int)getDay
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:self];
    return (int)[components day];
}

-(int)getGeoYear
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorian components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:self];
    return (int)[components year];
}

-(int)getGeoMon
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorian components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:self];
    return (int)[components month];
}

-(int)getGeoDay
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorian components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:self];
    return (int)[components day];
}

-(int)getHour
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit|NSHourCalendarUnit fromDate:self];
    return (int)[components hour];
}

-(int)getMin
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit|NSMinuteCalendarUnit fromDate:self];
    return (int)[components minute];
}

-(int)getSecond
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit |NSSecondCalendarUnit fromDate:self];
    return (int)[components second];
}

+(NSDate *)getPriousorLaterDateFromDate:(NSDate *)date withMonth:(int)month

{
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    [comps setYear:0];
    
    [comps setMonth:month];
    
    [comps setDay:0];
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDate *mDate = [calender dateByAddingComponents:comps toDate:date options:0];
    
    return mDate;
    
}

- (NSDateComponents *)componentsOfDay
{
    return [[NSCalendar currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:self];
}

- (NSUInteger)year
{
    return [self componentsOfDay].year;
}
- (NSUInteger)month
{
    return [self componentsOfDay].month;
}
- (NSUInteger)day162
{
    return [self componentsOfDay].day;
}
- (NSUInteger)weekday
{
    return [self componentsOfDay].weekday;
}
- (NSUInteger)weekOfDayInYear
{
    return [[NSCalendar currentCalendar] ordinalityOfUnit:NSWeekOfYearCalendarUnit inUnit:NSYearCalendarUnit forDate:self];
}


- (BOOL)sameWeekWithDate:(NSDate *)otherDate
{
    if (self.year == otherDate.year  && self.month == otherDate.month && self.weekOfDayInYear == otherDate.weekOfDayInYear) {
        return YES;
    } else {
        return NO;
    }
}

+(NSString*)getEngMon:(int)monNum
{
    switch (monNum) {
        case 1:
            return @"Jan";
            break;
        case 2:
            return @"Feb";
            break;
        case 3:
            return @"Mar";
            break;
        case 4:
            return @"Apr";
            break;
        case 5:
            return @"May";
            break;
        case 6:
            return @"Jun";
            break;
        case 7:
            return @"Jul";
            break;
        case 8:
            return @"Aug";
            break;
        case 9:
            return @"Sep";
            break;
        case 10:
            return @"Oct";
            break;
        case 11:
            return @"Nov";
            break;
        case 12:
            return @"Dec";
            break;
        default:
            break;
    }
    return @"";
}

+ (NSDate *)getDateWithFormat:(NSString *)format andString:(NSString *)string
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    dateFormat.dateFormat = format;
    dateFormat.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"];
    return [dateFormat dateFromString:string];
}

+ (NSString *)getStringWithFormat:(NSString *)format andDate:(NSDate *)date
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    dateFormat.dateFormat = format;
    dateFormat.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"];
    return [dateFormat stringFromDate:date];
}

+ (NSInteger)getCurrentAgeFromBirthdayDate:(NSDate *)date
{
    // 出生日期转换 年月日
    NSDateComponents *components1 = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:date];
    NSInteger brithDateYear  = [components1 year];
    NSInteger brithDateMonth = [components1 month];
    NSInteger brithDateDay   = [components1 day];
    
    // 获取系统当前 年月日
    NSDateComponents *components2 = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:[NSDate date]];
    NSInteger currentDateYear  = [components2 year];
    NSInteger currentDateMonth = [components2 month];
    NSInteger currentDateDay   = [components2 day];
    
    // 计算年龄
    NSInteger iAge = currentDateYear - brithDateYear - 1;
    if ((currentDateMonth > brithDateMonth) || (currentDateMonth == brithDateMonth && currentDateDay >= brithDateDay)) {
        iAge++;
    }
    
    return iAge;
}

+ (NSString *)getTimeInfoWithDate:(NSDate *)date
{
    NSString *weekString = nil;
    
    switch ([NSDate getWeekdayFromDate:date]) {
        case 2:
        {
            weekString = @"周一";
        }
            break;
        case 3:
        {
            weekString = @"周二";
        }
            break;
        case 4:
        {
            weekString = @"周三";
        }
            break;
        case 5:
        {
            weekString = @"周四";
        }
            break;
        case 6:
        {
            weekString = @"周五";
        }
            break;
        case 7:
        {
            weekString = @"周六";
        }
            break;
        case 1:
        {
            weekString = @"周日";
        }
            break;
        default:
            break;
    }
    
    return [NSString stringWithFormat:@"%@ %@",[self getStringWithFormat:@"yyyy/MM/dd" andDate:date],weekString];
}

+ (NSArray *)getWeekRangeArrWithDate:(NSDate *)date
{
    double interval = 0;
    NSDate *beginDate = nil;
    NSDate *endDate = nil;
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [calendar setFirstWeekday:1];
    
    //“某个时间点”所在的“单元”的起始时间，以及起始时间距离“某个时间点”的时差（单位秒）
    [calendar rangeOfUnit:NSWeekCalendarUnit startDate:&beginDate interval:&interval forDate:date];
    endDate = [beginDate dateByAddingTimeInterval:interval - 1];
    
    return @[beginDate,endDate];
}

+(NSInteger )getDayWithMonth:(NSInteger)month
{
    NSInteger day = 0;
    NSString *monthStr = [NSString stringWithFormat:@"%ld",(long)month];
    NSInteger year = [[monthStr substringToIndex:4] integerValue];
    NSInteger mon = [[monthStr substringFromIndex:4] integerValue];
    switch (mon) {
        case 1:
        case 3:
        case 5:
        case 7:
        case 8:
        case 10:
        case 12:
            day=31;
            break;
        case 4:
        case 6:
        case 9:
        case 11:
            day=30;
            break;
        default:
        {
            if([self isLeapYear:year])
            {
                day=29;
            }else
            {
                day=28;
            }
        }
            break;
    }
    return day;
    return day;
}

+(BOOL)isLeapYear:(NSInteger)year
{
    if ((year % 4  == 0 && year % 100 != 0)  || year % 400 == 0)
        return YES;
    else
        return NO;
}

@end
