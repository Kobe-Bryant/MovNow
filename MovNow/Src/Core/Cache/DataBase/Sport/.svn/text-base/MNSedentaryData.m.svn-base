//
//  MNSedentaryData.m
//  Movnow
//
//  Created by baoyx on 15/5/8.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//

#import "MNSedentaryData.h"
#import "FMDB.h"
#import "MNBaseData.h"
#import "MNUserModel.h"
#import "MNFirmwareModel.h"
@implementation MNSedentaryData
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

-(void)updateWithSedentary:(NSString *)sedentary withInterval:(NSNumber *)interval withRemindType:(NSNumber *)remindType
{
    [self deleteAll];
    [dbQueue_ inTransaction:^(FMDatabase *db, BOOL *rollback) {
        [db executeUpdate:@"insert into MNSedentary (sedentary,interval,remindType,userId,device) values (?,?,?,?,?)",sedentary,interval,remindType,[MNUserModel shareInstance].userId,[MNFirmwareModel sharestance].number];
    }];
}
-(NSDictionary *)select
{
    __block NSDictionary *remind = [NSDictionary dictionary];
    [dbQueue_ inDatabase:^(FMDatabase *db) {
       FMResultSet *set =[db executeQuery:@"select sedentary,interval,remindType from MNSedentary where userId=? and deviceId=?",[MNUserModel shareInstance].userId,[MNFirmwareModel sharestance].number];
        while ([set next]) {
            NSString *sedentary = [set stringForColumn:@"sedentary"];
            NSNumber *interval = [NSNumber numberWithInt:[set intForColumn:@"interval"]];
            NSNumber *remindType = [NSNumber numberWithInt:[set intForColumn:@"remindType"]];
            remind = @{@"sedentary":sedentary,@"interval":interval,@"remindType":remindType};
        }
    }];
    return remind;
}

-(void)deleteAll
{
    [dbQueue_ inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"delete from MNSedentary where userId=? and deviceId=?",[MNUserModel shareInstance].userId,[MNFirmwareModel sharestance].number];
    }];
}

@end
