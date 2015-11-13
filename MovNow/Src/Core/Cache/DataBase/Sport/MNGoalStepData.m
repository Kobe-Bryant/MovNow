//
//  MNGoalStepsData.m
//  Movnow
//
//  Created by baoyx on 15/4/22.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//

#import "MNGoalStepData.h"
#import "MNBaseData.h"
#import "MNUserModel.h"
#import "FMDB.h"
@implementation MNGoalStepData
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

-(void)updateWithGoalStep:(NSInteger)goalStep
{
    [dbQueue_ inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSDate *date = [NSDate date];
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyyMMdd"];
        NSInteger time = [[df stringFromDate:date] integerValue];
        FMResultSet *set = [db executeQuery:@"select goalNumber from MNGoalStep where dateTime=? and userId=?",[NSNumber numberWithInteger:time],[MNUserModel shareInstance].userId];
        if ([set next]) {
            //更新目标步数
            if (![db executeUpdate:@"update MNGoalStep set goalNumber=? where dateTime=? and userId=?",[NSNumber numberWithInteger:goalStep],[NSNumber numberWithInteger:time],[MNUserModel shareInstance].userId]) {
                DLog(@"update MNGoalStep error,%@,%@",[MNUserModel shareInstance].userId,[NSNumber numberWithInteger:time]);
            }
        }else
        {
            //新增目标步数
            if (![db executeUpdate:@"insert into MNGoalStep (userId,dateTime,goalNumber) values (?,?,?)",[MNUserModel shareInstance].userId,[NSNumber numberWithInteger:time],[NSNumber numberWithInteger:goalStep]]) {
                 DLog(@"insert MNGoalStep error,%@,%@",[MNUserModel shareInstance].userId,[NSNumber numberWithInteger:time]);
            }
        }
        [set close];
    }];
}

-(NSInteger)selectGoalStep:(NSInteger)dataTime
{
    //初始化目标步数  默认为7000
    __block NSInteger goalStep=7000;
    [dbQueue_ inDatabase:^(FMDatabase *db) {
        FMResultSet *set = [db executeQuery:@"select goalNumber from MNGoalStep where dateTime=? and userId=?",[NSNumber numberWithInteger:dataTime],[MNUserModel shareInstance].userId];
        if ([set next]) {
                goalStep = (NSInteger)[set intForColumn:@"goalNumber"];
        }else
        {
            set = [db executeQuery:@"select goalNumber,dateTime from MNGoalStep where userId=? and dateTime<? order by dateTime desc",[MNUserModel shareInstance].userId,[NSNumber numberWithInteger:dataTime]];
            if ([set next]) {
                    goalStep = (NSInteger)[set intForColumn:@"goalNumber"];
            }
        }
        [set close];
    }];
    return goalStep;
}

@end
