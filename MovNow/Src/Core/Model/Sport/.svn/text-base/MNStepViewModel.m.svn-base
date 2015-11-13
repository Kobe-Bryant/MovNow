//
//  MNStepViewModel.m
//  Movnow
//
//  Created by baoyx on 15/5/8.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//

#import "MNStepViewModel.h"
#import "MNStepData.h"
#import "MNTemporaryStepData.h"
#import "MNDeviceBindingService.h"
#import "MNGoalStepData.h"
#import "MNMovementService.h"
#import "MNUserModel.h"
@implementation MNStepViewModel
{
    NSInteger goalStep_;  //目标步数
    NSInteger temporaryStep_; //临时步数
    NSInteger totalSteps_; //总步数
}

-(instancetype)initHistoryWithTime:(NSInteger)time
{
    if (self = [super init]) {
        NSDictionary *stepDatails = [[[MNStepData alloc] init] selectStepDatailsWithDate:time];
        _allDaystepDetails = stepDatails[@"allDay"];
        _diurnalstepDetails = stepDatails[@"diurnal"];
        _allDayMaxStep = [stepDatails[@"allDayMax"] intValue];
        _diurnalMaxStep = [stepDatails[@"diurnalMax"] intValue];
        [self selectStepWithDate:NO withTime:time];
        [self selectGoalStepWithTime:time];
        [self updateData];
    }
    return self;
}

-(instancetype)initToday
{
    if (self = [super init]) {
        NSDate *date = [NSDate date];
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyyMMdd"];
        NSInteger time = [[df stringFromDate:date] integerValue];
        NSDictionary *stepDatails = [[[MNStepData alloc] init] selectStepDatailsWithDate:time];
        _allDaystepDetails = stepDatails[@"allDay"];
        _diurnalstepDetails = stepDatails[@"diurnal"];
        _allDayMaxStep = [stepDatails[@"allDayMax"] intValue];
        _diurnalMaxStep = [stepDatails[@"diurnalMax"] intValue];
        [self selectTemporaryStep];
        [self selectStepWithDate:YES withTime:time];
        [self selectGoalStepWithTime:time];
        [self updateData];
    }
    return self;
}


#pragma mark 更新计步详情

-(void)updateStepDeatils
{
    NSDate *date = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyyMMdd"];
    NSInteger time = [[df stringFromDate:date] integerValue];
    NSDictionary *stepDatails = [[[MNStepData alloc] init] selectStepDatailsWithDate:time];
    _allDaystepDetails = stepDatails[@"allDay"];
    _diurnalstepDetails = stepDatails[@"diurnal"];
    _allDayMaxStep = [stepDatails[@"allDayMax"] integerValue];
    _diurnalMaxStep = [stepDatails[@"diurnalMax"] integerValue];
}

#pragma mark 重新更新模型属性的值
-(void)updateData
{
    _steps = [NSString stringWithFormat:@"%ld",(long)totalSteps_];
    _percent = totalSteps_*100/goalStep_;
    _mileage = [MNMovementService getMileageWithSteps:totalSteps_];
    _calorie = [MNMovementService getCalorieWithSteps:totalSteps_];
}

#pragma mark 总步数
-(void)selectStepWithDate:(BOOL)isToday withTime:(NSInteger)time
{
    MNDeviceBindingService *bindingService = [MNDeviceBindingService shareInstance];
    NSArray *functionds = [bindingService getDeviceFunctionWithDeviceType:bindingService.currentDeviceType];
    if ([functionds containsObject:@"SHORTPACKAGE"] && isToday) {
        [self selectTemporaryStep];
    }
    totalSteps_ = (NSInteger)[[[MNStepData alloc] init] selectTotoalStepWithTime:time];
    totalSteps_ = totalSteps_>temporaryStep_?totalSteps_:temporaryStep_;
    
}

#pragma mark 临时步数 (当天步数 支持短包计步数据设备)
-(void)selectTemporaryStep
{
    temporaryStep_ = [[[MNTemporaryStepData alloc] init] selectNumber];
}

#pragma mark 目标步数
-(void)selectGoalStepWithTime:(NSInteger)time
{
    goalStep_ = [[[MNGoalStepData alloc] init] selectGoalStep:time];
}

#pragma mark 更新目标步数
-(void)updateWithGoalStep:(NSInteger)goalStep
{
    goalStep_ = goalStep;
    [self updateData];
}

#pragma mark 更新总步数
-(void)updateTotalStep
{
    NSDate *date = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyyMMdd"];
    NSInteger time = [[df stringFromDate:date] integerValue];
    [self selectStepWithDate:YES withTime:time];
    [self updateStepDeatils];
    [self updateData];
}

#pragma mark 更新临时步数
-(void)updateWithTemporaryStep:(NSInteger)temporaryStep
{
    NSDate *date = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyyMMdd"];
    NSInteger time = [[df stringFromDate:date] integerValue];
    temporaryStep_ = temporaryStep;
    totalSteps_ = (NSInteger)[[[MNStepData alloc] init] selectTotoalStepWithTime:time];
    totalSteps_ = totalSteps_>temporaryStep_?totalSteps_:temporaryStep_;
    [self updateData];
}




@end
