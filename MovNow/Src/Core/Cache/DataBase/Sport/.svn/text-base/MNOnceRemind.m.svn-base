//
//  MNOnceRemind.m
//  Movnow
//
//  Created by baoyx on 15/5/11.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//

#import "MNOnceRemind.h"
#import "FMDB.h"
#import "MNBaseData.h"
#import "MNUserModel.h"
#import "MNFirmwareModel.h"
@implementation MNOnceRemind
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

-(void)insertWithOnceReminds:(NSArray *)reminds
{
    [dbQueue_ inTransaction:^(FMDatabase *db, BOOL *rollback) {
        [reminds enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
            [db executeUpdate:@"insert intp MNOnceRemind (userId,deviceId,time,date) values (?,?,?,?)",[MNUserModel shareInstance].userId,[MNFirmwareModel sharestance].number,obj[@"time"],obj[@"date"]];
        }];
    }];
}


-(NSArray *)seletOnceReminds
{
    __block NSMutableArray *reminds = [NSMutableArray array];
    NSDate *date = [NSDate date];
    NSDateFormatter *dfDate = [[NSDateFormatter alloc] init];
    [dfDate setDateFormat:@"yyyyMMdd"];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyyMMddHHmm"];
    NSNumber *today = [NSNumber numberWithInteger:[[NSString stringWithFormat:@"%@0000",[dfDate stringFromDate:date]] integerValue]];
    NSUInteger timeMinute = [[df stringFromDate:date] integerValue];
    [dbQueue_ inDatabase:^(FMDatabase *db) {
       FMResultSet *set =[db executeQuery:@"select time,date from MNOnceRemind where deviceId=? and userId=? and date>=?",[MNFirmwareModel sharestance].number,[MNUserModel shareInstance].userId,today];
        while ([set next]) {
            NSString *time = [set stringForColumn:@"time"];
            NSInteger dateTime = [set intForColumn:@"date"];
            NSInteger onceType = 0 ;
            if (dateTime > timeMinute) {
                onceType =1;
            }
            [reminds addObject:@{@"time":time,@"date":@(dateTime),@"type":@(onceType)}];
        }
    }];
    return reminds;
}



-(void)deleteAll
{
    [dbQueue_ inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"delete from MNOnceRemind where userId=? and deviceId=?",[MNUserModel shareInstance].userId,[MNFirmwareModel sharestance].number];
        
    }];
}
@end
