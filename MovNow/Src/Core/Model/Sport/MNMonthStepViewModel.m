//
//  MNMonthStepViewModel.m
//  Movnow
//
//  Created by baoyx on 15/5/19.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//

#import "MNMonthStepViewModel.h"
#import "MNStepData.h"
@implementation MNMonthStepViewModel

-(instancetype)initMonthWithStartMonth:(NSInteger)month
{
    if (self = [super init]) {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyyMMdd"];
        NSInteger today = [[df stringFromDate:[NSDate date]] integerValue];
        NSInteger startTime = [[NSString stringWithFormat:@"%ld01",(long)month] integerValue];
        NSInteger endTime = [[NSString stringWithFormat:@"%ld%ld",(long)month,(long)[NSDate getDayWithMonth:month]] integerValue];
        if (endTime>today) {
            endTime = today;
        }
        NSDictionary *stepDetails = [[[MNStepData alloc] init] selectMonthDatailsWithStartDate:startTime withEndData:endTime];
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
    }
    return self;
}
@end
