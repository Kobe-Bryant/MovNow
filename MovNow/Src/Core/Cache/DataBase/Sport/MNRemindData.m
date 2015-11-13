//
//  MNRemindData.m
//  Movnow
//
//  Created by baoyx on 15/4/28.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//

#import "MNRemindData.h"
#import "MNUserModel.h"
#import "MNFirmwareModel.h"
#import "FMDB.h"
#import "MNBaseData.h"
@implementation MNRemindData
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

-(NSArray *)selectDrinkRemind
{
    __block NSMutableArray *reminds = [NSMutableArray array];
    [dbQueue_ inDatabase:^(FMDatabase *db) {
        FMResultSet *set = [db executeQuery:@"select time from MNRemind  where type =1 and userId=? and deviceId=?",[MNUserModel shareInstance].userId,[MNFirmwareModel sharestance].number];
        while ([set next]) {
            [reminds addObject:[set stringForColumn:@"time"]];
        }
        [set close];
    }];
    return reminds;
}

-(NSArray *)selectClockReminds
{
    __block NSMutableArray *reminds = [NSMutableArray array];
    [dbQueue_ inDatabase:^(FMDatabase *db) {
        FMResultSet *set = [db executeQuery:@"select time from MNRemind where type =2 and userId=? and deviceId=?",[MNUserModel shareInstance].userId,[MNFirmwareModel sharestance].number];
        while ([set next]) {
            [reminds addObject:[set stringForColumn:@"time"]];
        }
        [set close];
    }];
    return reminds;
}

-(void)updateWithDrinkRemind:(NSArray *)drinkReminds withClockRemind:(NSArray *)clockReminds
{
    [self deleteAll];
    [dbQueue_ inTransaction:^(FMDatabase *db, BOOL *rollback) {
        [drinkReminds enumerateObjectsUsingBlock:^(NSString *time, NSUInteger idx, BOOL *stop) {
            [db executeUpdate:@"insert into MNRemind(userId,deviceId,time,type) values (?,?,?,?)",[MNUserModel shareInstance].userId,[MNFirmwareModel sharestance].number,time,@(1)];
        }];
        [clockReminds enumerateObjectsUsingBlock:^(NSString *time, NSUInteger idx, BOOL *stop) {
            [db executeUpdate:@"insert into MNRemind(userId,deviceId,time,type) values (?,?,?,?)",[MNUserModel shareInstance].userId,[MNFirmwareModel sharestance].number,time,@(2)];
        }];
    }];
    
}

-(void)deleteAll
{
    [dbQueue_ inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"delete from MNRemind where userId=? and deviceId=?",[MNUserModel shareInstance].userId,[MNFirmwareModel sharestance].number];
    }];
}
@end
