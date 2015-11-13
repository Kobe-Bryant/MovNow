//
//  MNSyncTimeData.m
//  Movnow
//
//  Created by baoyx on 15/4/23.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//

#import "MNSyncTimeData.h"
#import "MNUserModel.h"
#import "MNFirmwareModel.h"
#import "FMDB.h"
#import "MNBaseData.h"
@implementation MNSyncTimeData
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
-(void)updateSyncTimeWithSyncType:(SyncType)type withSyncTime:(NSDate *)timeDate
{
    [dbQueue_ inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        FMResultSet *set = [db executeQuery:@"select time from MNSyncTime where userId=? and deviceId=? and type=?",[MNUserModel shareInstance].userId,[MNFirmwareModel sharestance].number,@(type)];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
        NSString *time =[dateFormatter stringFromDate:timeDate];
        if ([set next]) {
            if (![db executeUpdate:@"update MNSyncTime set time=? where userId=? and deviceId=?  and type=?",time,[MNUserModel shareInstance].userId,[MNFirmwareModel sharestance].number,@(type)]) {
                DLog(@"update MNSyncTime error,%@,%@,%@",[MNUserModel shareInstance].userId,[MNFirmwareModel sharestance].number,@(type));
            }
        }else
        {
            if (![db executeUpdate:@"insert into MNSyncTime (userId,deviceId,type,time) values (?,?,?,?)",[MNUserModel shareInstance].userId,[MNFirmwareModel sharestance].number,@(type),time]) {
                 DLog(@"insert MNSyncTime error,%@,%@,%@",[MNUserModel shareInstance].userId,[MNFirmwareModel sharestance].number,@(type));
            }
        }
        [set close];
    }];
}

-(NSDate *)selectSyncTimeWithyncType:(SyncType)type
{
   __block NSDate *syncDate = [[NSDate alloc] init];
    [dbQueue_ inTransaction:^(FMDatabase *db, BOOL *rollback) {
        FMResultSet *set = [db executeQuery:@"select time from MNSyncTime where userId=? and deviceId=? and type=?",[MNUserModel shareInstance].userId,[MNFirmwareModel sharestance].number,@(type)];
        if ([set next]) {
            while ([set next]) {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
                syncDate = [dateFormatter dateFromString:[set stringForColumn:@"time"]];
            }
        }
        [set close];
    }];
    
    return syncDate;
}

-(void)deleteAll
{
    [dbQueue_ inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"delete from MNSyncTime where userId=? and deviceId=?",[MNUserModel shareInstance].userId,[MNFirmwareModel sharestance].number];
    }];
}
@end
