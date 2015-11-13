//
//  MNBaseData.m
//  Movnow
//
//  Created by baoyx on 15/4/16.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//

#import "MNBaseData.h"
#import "FMDB.h"
@implementation MNBaseData
{
    FMDatabaseQueue *dbQueue_;  //线程安全
}
+(MNBaseData *)shareInstance
{
    static MNBaseData *simple;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        simple = [[MNBaseData alloc] init];
    });
    return simple;
}

-(instancetype)init
{
    if (self = [super init]) {
        //创建数据库Movnow
        _dbPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Movnow.db"];
        dbQueue_ = [FMDatabaseQueue databaseQueueWithPath:_dbPath];
        NSMutableArray *sqls=[NSMutableArray array];
        //创建运动数据表
        [sqls addObject:@"create table if  not exists MNStep(userId integer,deviceId txt,sportTime integer,serialNumber integer,sportType integer,sportStep integer,dataFrequency integer,primary key(serialNumber,sportTime,userId,deviceId))"];
        //创建睡眠数据表
        [sqls addObject:@"create table if  not exists MNSleep(userId integer,deviceId txt,dateTime integer,startTime integer,sleepDuration integer,sleepState  integer,primary key(startTime,dateTime,userId,deviceId))"];
        [sqls addObject:@"create table if not exists MNGoalStep(userId integer,dateTime integer,goalNumber integer,primary key(userId,dateTime))"];
        [sqls addObject:@"create table if not exists MNSyncTime(userId integer,deviceId txt,time text,type integer,primary key(userId,deviceId,type,time))"];
        [sqls addObject:@"create table if not exists MNRemind(userId integer,deviceId txt,time text,type integer,primary key(userId,deviceId,type,time))"];
        [sqls addObject:@"create table if not exists MNOnceRemind(userId integer,deviceId txt,time text,date integer,primary key(userId,deviceId,time,date))"];
        [sqls addObject:@"create table if not exists MNTemporaryStep(number integer,time integer,userId integer,device text,primary key(time,userId,device))"];
        [sqls addObject:@"create table if not exists MNSedentary(sedentary text,interval integer,remindType integer,userId integer,device text,primary key(userId,device))"];
        [dbQueue_ inTransaction:^(FMDatabase *db, BOOL *rollback) {
            [sqls enumerateObjectsUsingBlock:^(NSString *sql, NSUInteger idx, BOOL *stop) {
                    [db executeUpdate:sql];
            }];
        }];
    }
    return self;
}
@end
