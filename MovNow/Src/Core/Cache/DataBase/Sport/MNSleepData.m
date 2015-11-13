//
//  MNSleepData.m
//  Movnow
//
//  Created by baoyx on 15/4/16.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//

#import "MNSleepData.h"
#import "MNSleepModel.h"
#import "FMDB.h"
#import "MNBaseData.h"
#import "MNUserModel.h"
#import "MNFirmwareModel.h"
@implementation MNSleepData
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

-(void)updateWithMNSleepModels:(NSArray *)MNSleepModels
{
    [dbQueue_ inTransaction:^(FMDatabase *db, BOOL *rollback) {
        [MNSleepModels enumerateObjectsUsingBlock:^(MNSleepModel *model, NSUInteger idx, BOOL *stop) {
            FMResultSet *set = [db executeQuery:@"select sleepDuration from MNSleep where startTime =? and dateTime=? and userId=? and deviceId=?",model.startTime,[NSNumber numberWithInt:[model.dateTime intValue]],model.userId,model.deviceId];
            if ([set next]) {
                if (![db executeUpdate:@"update MNSleep set sleepDuration=? and sleepState=? where startTime =?,dateTime=?,userId=? and deviceId=?",model.sleepDuration,model.sleepState,model.startTime,[NSNumber numberWithInt:[model.dateTime intValue]],model.userId,model.deviceId]) {
                    DLog(@"update MNSleep error,%@,%@,%@,%@",model.startTime,[NSNumber numberWithInt:[model.dateTime intValue]],model.userId,model.deviceId);
                } ;
            }else
            {
                if (![db executeUpdate:@"insert into MNSleep(userId,deviceId,dateTime,startTime,sleepDuration,sleepState) values (?,?,?,?,?,?)"]) {
                    DLog(@"insert into MNSleep error,%@,%@,%@,%@",model.startTime,[NSNumber numberWithInt:[model.dateTime intValue]],model.userId,model.deviceId);
                }
            }
            [set close];
        }];
    }];
    
}
-(NSDictionary *)selectSleepWithTime:(NSInteger)time
{
    __block NSDictionary *sleepTime = [NSDictionary dictionary];
    [dbQueue_ inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSInteger sleepDuration = 0;
        NSInteger deepSleepDuration = 0;
        NSInteger lightSleepDuration = 0;
        FMResultSet *set = [db executeQuery:@"select sum(sleepDuration) as duration from MNSleep where dateTime=? and userId=? and deviceId=?",@(time),[MNUserModel shareInstance].userId,[MNFirmwareModel sharestance].number];
        if ([set next]) {
            sleepDuration = [set intForColumn:@"duration"];
        }
        
        set = [db executeQuery:@"select sum(sleepDuration) as duration from MNSleep where dateTime=? and userId=? and deviceId=? and sleepState=0",@(time),[MNUserModel shareInstance].userId,[MNFirmwareModel sharestance].number];
        if ([set next]) {
            deepSleepDuration = sleepDuration = [set intForColumn:@"duration"];
        }
        set = [db executeQuery:@"select sum(sleepDuration) as duration from MNSleep where dateTime=? and userId=? and deviceId=? and sleepState>0",@(time),[MNUserModel shareInstance].userId,[MNFirmwareModel sharestance].number];
        if ([set next]) {
            lightSleepDuration = sleepDuration = [set intForColumn:@"duration"];
        }
        [set close];
        sleepTime = @{@"sleepDuration":@(sleepDuration),@"deepSleepDuration":@(deepSleepDuration),@"lightSleepDuration":@(lightSleepDuration)};
    }];
    
    return sleepTime;
}
-(NSSet *)selectFromSleepWithAllTime
{
    __block NSMutableSet * tset = [NSMutableSet set];
    [dbQueue_ inDatabase:^(FMDatabase *db) {
        FMResultSet *set = [db executeQuery:@"select distinct dateTime from MNSleep where userId=? and deviceId=?",[MNUserModel shareInstance].userId,[MNFirmwareModel sharestance].number];
        while ([set next]) {
            NSString *time = [NSString stringWithFormat:@"%d",[set intForColumn:@"dateTime"]];
            [tset addObject:time];
        }
    }];
    return tset;
}

@end
