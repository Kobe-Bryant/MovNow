//
//  MNWeekMonthViewModel.m
//  Movnow
//
//  Created by baoyx on 15/5/18.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//

#import "MNWeekStepViewModel.h"
#import "MNStepData.h"
#import "NSDate+Expend.h"
@implementation MNWeekStepViewModel

-(instancetype)initWeekWithStartDate:(NSDate *)startDate withEndDate:(NSDate *)endDate
{
    if (self = [super init]) {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyyMMdd"];
        NSInteger startTime = [[df stringFromDate:startDate] integerValue];
        NSInteger endTime = [[df stringFromDate:endDate] integerValue];
        NSInteger today = [[df stringFromDate:[NSDate date]] integerValue];
        if (endTime>today) {
            endTime = today;
        }
        NSDictionary *stepDetails = [[[MNStepData alloc] init] selectWeekDatailsWithStartDate:startTime withEndData:endTime];
        _steps = stepDetails[@"steps"];
        _mileages = stepDetails[@"mileages"];
        _calories = stepDetails[@"calories"];
        _maxStep = [stepDetails[@"maxStep"] integerValue];
        _maxCalorie = [stepDetails[@"maxCalorie"] integerValue];
        _maxMileage = [stepDetails[@"maxMileage"] integerValue];
        _sumStep = [stepDetails[@"sumSteps"] integerValue];
        _sumCalorie = [stepDetails[@"sumCalorie"] integerValue];
        _sumMileage = [stepDetails[@"sumMileage"] integerValue];
        _movementDetails = stepDetails[@"movementDetails"];
        _maxMovementDetailsStep = stepDetails[@"maxMovementDetailsStep"];
       
    }
    return self;
}
@end
