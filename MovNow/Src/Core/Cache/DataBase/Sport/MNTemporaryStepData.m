//
//  MNTemporaryStepData.m
//  Movnow
//
//  Created by baoyx on 15/5/5.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//

#import "MNTemporaryStepData.h"
#import "MNFirmwareModel.h"
#import "MNUserModel.h"
#import "MNBaseData.h"
#import "FMDB.h"
@implementation MNTemporaryStepData
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
-(void)insertWithNumber:(NSInteger)number
{
    NSDate *date = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyyMMdd"];
    NSNumber *time = [NSNumber numberWithInt:[[df stringFromDate:date] intValue]];
    [dbQueue_ inDatabase:^(FMDatabase *db) {
         FMResultSet *set=[db executeQuery:@"select number from MNTemporaryStep where time=? and userId=? and device=?",time,[MNUserModel shareInstance].userId,[MNFirmwareModel sharestance].number];
        if ([set next]) {
             [db executeUpdate:@"update MNTemporaryStep set number=? where time=?  and userId=? and device=?",[NSNumber numberWithInteger:number],time,[MNUserModel shareInstance].userId,[MNFirmwareModel sharestance].number];
        }else
        {
           [db executeUpdate:@"insert into MNTemporaryStep (number,time,userId,device) values (?,?,?,?)",[NSNumber numberWithInteger:number],time,[MNUserModel shareInstance].userId,[MNFirmwareModel sharestance].number];
        }
        [set close];
    }];
}

-(NSInteger)selectNumber
{
    __block NSInteger number = 0;
    NSDate *date = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyyMMdd"];
    NSNumber *time = [NSNumber numberWithInt:[[df stringFromDate:date] intValue]];
    [dbQueue_ inDatabase:^(FMDatabase *db) {
        FMResultSet *set=[db executeQuery:@"select number from MNTemporaryStep where time=? and userId=? and device=?",time,[MNUserModel shareInstance].userId,[MNFirmwareModel sharestance].number];
        while ([set next]) {
            number = [set intForColumn:@"number"];
        }
        [set close];
    }];
    return number;
}

-(void)deleteNumber
{
    [dbQueue_ inDatabase:^(FMDatabase *db) {
        [ db executeUpdate:@"delete from MNTemporaryStep where userId=? and device=?",[MNUserModel shareInstance].userId,[MNFirmwareModel sharestance]];
    }];
}
@end
