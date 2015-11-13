//
//  MNSleepViewModel.m
//  Movnow
//
//  Created by baoyx on 15/5/8.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//

#import "MNSleepViewModel.h"
#import "MNSleepData.h"
@implementation MNSleepViewModel
{
    NSInteger  sleepDuration_;
    NSInteger  deepSleepDuration_;
    NSInteger  lightSleepDuration_;
}

-(instancetype)initHistoryWithTime:(NSInteger)time
{
    if (self = [super init]) {
        [self updateDataWithTime:time];
    }
    return self;
}


-(instancetype)initToday{
    if (self = [super init]) {
        [self updateDataWithToday];
    }
    return self;
}

-(void)updateTotalSleep
{
    [self updateDataWithToday];
}


#pragma mark 重新更新模型属性的值
-(void)updateDataWithTime:(NSInteger)time
{
    MNSleepData *sleepData = [[MNSleepData alloc] init];
    NSDictionary *duration = [sleepData selectSleepWithTime:time];
    sleepDuration_ = [duration[@"sleepDuration"] integerValue];
    deepSleepDuration_ = [duration[@"deepSleepDuration"] integerValue];
    lightSleepDuration_ = [duration[@"lightSleepDuration"] integerValue];
    _percent = 100*sleepDuration_/1440;
    _sleepDuration = [self holdTime:sleepDuration_];
    _deepSleepDuration = [self holdTime:deepSleepDuration_];
    _lightSleepDuration = [self holdTime:lightSleepDuration_];
}

-(void)updateDataWithToday
{
    NSDate *date = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyyMMdd"];
    NSInteger time = [[df stringFromDate:date] integerValue];
    [self updateDataWithTime:time];
}

-(NSString *)holdTime:(NSInteger)time
{
    NSInteger hour = time/60;
    NSInteger minute  = time%60;
    return [NSString stringWithFormat:@"%02ld:%02ld:00",hour,minute];
}

@end
