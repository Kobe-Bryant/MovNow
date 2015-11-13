//
//  MNStepData.m
//  Movnow
//
//  Created by baoyx on 15/4/16.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//

#import "MNStepData.h"
#import "MNBaseData.h"
#import "MNStepModel.h"
#import "FMDB.h"
#import "MNUserModel.h"
#import "MNFirmwareModel.h"
#import "MNMovementService.h"
@implementation MNStepData
{
    FMDatabaseQueue *dbQueue_;
}
-(instancetype)init
{
    if (self = [super init]) {
        MNBaseData *baseData = [MNBaseData shareInstance];
        dbQueue_ = [FMDatabaseQueue databaseQueueWithPath:baseData.dbPath];
    }
    return self;
}
-(void)updateWithMNStepModels:(NSArray *)MNStepModels
{
    [dbQueue_ inTransaction:^(FMDatabase *db, BOOL *rollback) {
       
        [MNStepModels enumerateObjectsUsingBlock:^(MNStepModel* model, NSUInteger idx, BOOL *stop) {
            NSNumber *sportTime = [NSNumber numberWithInt:[[model.sportTime substringToIndex:8] intValue]];
            
            NSNumber *serialNumber =[NSNumber numberWithInt:([[model.sportTime substringWithRange:NSMakeRange(8,2)] intValue]*2 + ([[model.sportTime substringWithRange:NSMakeRange(10, 2)] intValue]==30?1:0))];
            
            FMResultSet *set = [db executeQuery:@"select sportStep from MNStep where serialNumber =? and sportTime=? and userId=? and deviceId=?",serialNumber,sportTime,model.userId,model.deviceId];
            if ([set next]) {
                if (![db executeUpdate:@"update MNStep set sportType=? and sportStep=? and dataFrequency=? where serialNumber =? and sportTime=? and userId=? and deviceId=?",model.sportType,model.sportStep,model.dataFrequency,serialNumber,sportTime,model.userId,model.deviceId]) {
                    
                    DLog(@"update MNStep error,%@,%@,%@,%@",serialNumber,sportTime,model.userId,model.deviceId);
                }
            }else
            {
                if (![db executeUpdate:@"insert into MNStep (userId ,deviceId,sportTime,serialNumber,sportType,sportStep,dataFrequency) values (?,?,?,?,?,?,?)",model.userId,model.deviceId,sportTime,serialNumber,model.sportType,model.sportStep,model.dataFrequency]) {
                    DLog(@"insert into MNStep error,%@,%@,%@,%@",serialNumber,sportTime,model.userId,model.deviceId);
                }
            }
            [set close];
        }];
    }];
}

-(int)selectTotoalStepWithTime:(NSInteger)sportTime
{
    __block int totalStep = 0;
    
    [dbQueue_ inDatabase:^(FMDatabase *db) {
        
        FMResultSet *set = [db executeQuery:@"select sum(sportStep) as totalSteps  from MNStep where sportTime=? and userId=? and deviceId=?",@(sportTime),[MNUserModel shareInstance].userId,[MNFirmwareModel sharestance].number];
        if ([set next]) {
            totalStep = [set intForColumn:@"totalSteps"];
        }
        [set close];
        
    }];
    return totalStep;
}

-(NSSet *)selectFromStepWithAllTime
{
    __block NSMutableSet * tset = [NSMutableSet set];
    [dbQueue_ inDatabase:^(FMDatabase *db) {
        FMResultSet *set = [db executeQuery:@"select distinct sportTime from MNStep where userId=? and deviceId=?",[MNUserModel shareInstance].userId,[MNFirmwareModel sharestance].number];
        while ([set next]) {
            NSString *time = [NSString stringWithFormat:@"%d",[set intForColumn:@"time"]];
            [tset addObject:time];
        }
        [set next];
    }];
    return tset;
}

-(NSDictionary *)selectStepDatailsWithDate:(NSInteger)date
{
    __block NSMutableArray *allDayStepDatails = [NSMutableArray array];
    __block NSMutableArray *diurnalStepDatails = [NSMutableArray array];
    for (int index= 0; index<48; index++) {
        [allDayStepDatails addObject:@(0)];
    }
    for (int index= 0; index<36; index++) {
        [diurnalStepDatails addObject:@(0)];
    }
    __block NSInteger allDayMaxStep = 0;
    __block NSInteger diurnalMaxStep = 0;
     [dbQueue_ inDatabase:^(FMDatabase *db) {
         FMResultSet *set = [db executeQuery:@"select serialNumber,sportStep from MNStep where userId=? and deviceId=? and sportTime=?",[MNUserModel shareInstance].userId,[MNFirmwareModel sharestance].number,@(date)];
         while ([set next]) {
             NSInteger index = [set intForColumn:@"serialNumber"];
             allDayStepDatails[index-1] = @([set intForColumn:@"sportStep"]);
             if ([allDayStepDatails[index-1] intValue]>allDayMaxStep) {
                 allDayMaxStep = [allDayStepDatails[index-1] intValue];
             }
             if (index>6 || index<44) {
                 diurnalStepDatails[index-7] = @([set intForColumn:@"sportStep"]);
                 if ([diurnalStepDatails[index-1] intValue]>diurnalMaxStep) {
                     diurnalMaxStep = [diurnalStepDatails[index-1] intValue];
                 }
             }
         }
         [set close];
     }];
    return @{@"allDay":allDayStepDatails,@"diurnal":diurnalStepDatails,@"allDayMax":@(allDayMaxStep),@"diurnalMax":@(diurnalMaxStep)};
}

-(NSDictionary *)selectMovementDatailsWithStartDate:(NSInteger)startDate withEndData:(NSInteger)endDate
{
    __block NSMutableArray *steps = [NSMutableArray array];
    __block NSMutableArray *mileages = [NSMutableArray array];
    __block NSMutableArray *calories = [NSMutableArray array];
    __block NSInteger maxStep =0;
    __block NSInteger maxMileage =0;
    __block NSInteger maxCalorie =0;
    __block NSInteger sumSteps = 0;
    __block NSInteger sumMileages = 0;
    __block NSInteger sumCalories = 0;
    for (NSInteger time = startDate;time<=endDate;time++) {
        [steps addObject:@(0)];
        [mileages addObject:@(0)];
        [calories addObject:@(0)];
    }
    [dbQueue_ inTransaction:^(FMDatabase *db, BOOL *rollback) {
        FMResultSet *set = [db executeQuery:@"select sum(sportStep) as totalStep,sportTime from MNStep where userId=? and deviceId=? and sportTime>=? and sportTime<=? group by sportTime",[MNUserModel shareInstance].userId,[MNFirmwareModel sharestance].number,startDate,endDate];
        while ([set next]) {
            NSInteger index = [set intForColumn:@"sportTime"]-startDate;
            NSInteger  totalStep= [set intForColumn:@"totalStep"];
            sumSteps += totalStep;
            NSInteger mileage = [MNMovementService getMileageWithSteps:totalStep];
            sumMileages +=mileage;
            NSInteger calorie = [MNMovementService getCalorieWithSteps:totalStep];
            sumCalories += calorie;
            if (maxStep<totalStep) {
                maxStep = totalStep;
                maxMileage = mileage;
                maxCalorie = calorie;
            }
            steps[index] = @(totalStep);
            mileages[index]=@(mileage);
            calories[index]= @(calorie);
        }
        [set close];
    }];
     return @{@"steps":(NSArray *)steps,@"mileages":(NSArray *)mileages,@"calorie":(NSArray *)calories,@"maxStep":@(maxStep),@"maxMileage":@(maxMileage),@"maxCalorie":@(maxCalorie),@"sumSteps":@(sumSteps),@"sumMileages":@(sumMileages),@"sumCalories":@(sumCalories)};
    
}

-(NSDictionary *)selectDiurnalStepDatailsWithStartDate:(NSInteger)startDate withEndData:(NSInteger)endDate
{
    __block NSMutableArray *diurnalStepDatails = [NSMutableArray array];
    __block NSMutableArray *maxSteps = [NSMutableArray array];
    [dbQueue_ inTransaction:^(FMDatabase *db, BOOL *rollback) {
        for (NSInteger time=startDate;time<=endDate;time++) {
            NSMutableArray *movementDetails = [NSMutableArray array];
            NSInteger maxNum = 0;
            for (int index= 0; index<36; index++) {
                [movementDetails addObject:@(0)];
            }
            FMResultSet *set = [db executeQuery:@"select serialNumber,sportStep from MNStep where userId=? and deviceId=? and sportTime=?",[MNUserModel shareInstance].userId,[MNFirmwareModel sharestance].number,@(time)];
            while ([set next]) {
                NSInteger index = [set intForColumn:@"serialNumber"];
                if (index>6 || index<44) {
                    movementDetails[index-7] = @([set intForColumn:@"sportStep"]);
                    
                    if ([movementDetails[index-1] integerValue]>maxNum) {
                        maxNum = [movementDetails[index-1] integerValue];
                    }
                }
            }
            [diurnalStepDatails addObject:(NSArray *)movementDetails];
            [maxSteps addObject:@(maxNum)];
            [set close];
        }
    }];
    return @{@"movementDetails":diurnalStepDatails,@"maxMovementDetailsStep":maxSteps};
}


-(NSDictionary *)selectWeekDatailsWithStartDate:(NSInteger)startDate withEndData:(NSInteger)endDate
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[self selectMovementDatailsWithStartDate:startDate withEndData:endDate]];
    
    NSDictionary *diurnalStepDatail = [self selectDiurnalStepDatailsWithStartDate:startDate withEndData:endDate];
    [dic setObject:diurnalStepDatail[@"movementDetails"] forKey:@"movementDetails"];
    [dic setObject:diurnalStepDatail[@"maxMovementDetailsStep"] forKey:@"maxMovementDetailsStep"];
    return (NSDictionary *)dic;
}

-(NSDictionary *)selectMonthDatailsWithStartDate:(NSInteger)startDate withEndData:(NSInteger)endDate
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[self selectMovementDatailsWithStartDate:startDate withEndData:endDate]];
    return (NSDictionary *)dic;
}




@end
