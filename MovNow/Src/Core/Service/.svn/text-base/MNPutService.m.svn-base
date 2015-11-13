//
//  MNPutService.m
//  Movnow
//
//  Created by baoyx on 15/4/16.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//

#import "MNPutService.h"
#import "MNetManager.h"
#import "MNFirmwareModel.h"
#import "MNUserKeyChain.h"
#import "MNStepModel.h"
#import "MNSleepModel.h"
@implementation MNPutService
+(MNPutService *)shareInstance
{
    static MNPutService *simple;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        simple = [[MNPutService alloc] init];
    });
    return simple;
}
-(void)bindingLog
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHMMss"];
    NSString *timeStr=[formatter stringFromDate:[NSDate date]];
    NSMutableDictionary *logObject = [NSMutableDictionary dictionary];
    [logObject setValue:@(4) forKey:@"logType"];
    [logObject setValue:@(1) forKey:@"result"];
    [logObject setValue:timeStr forKey:@"optTime"];
    [logObject setValue:[MNFirmwareModel sharestance].number forKey:@"deviceId"];
    [logObject setValue:[MNFirmwareModel sharestance].type forKey:@"deviceType"];
    [logObject setValue:[MNUserKeyChain readUserID] forKey:@"userId"];
    [logObject setValue:[MNFirmwareModel sharestance].firmwareVersion forKey:@"firmwareVer"];
    NSArray *logArr = [NSArray arrayWithObject:logObject];
    NSDictionary *dic=@{@"log":logArr};
    [MNetManager sendUpdateBraceletDataWithData:dic];
}

-(void)unBindingLog
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHMMss"];
    NSString *timeStr=[formatter stringFromDate:[NSDate date]];
    NSMutableDictionary *logObject = [NSMutableDictionary dictionary];
    [logObject setValue:@(5) forKey:@"logType"];
    [logObject setValue:@(1) forKey:@"result"];
    [logObject setValue:timeStr forKey:@"optTime"];
    [logObject setValue:[MNFirmwareModel sharestance].number forKey:@"deviceId"];
    [logObject setValue:[MNFirmwareModel sharestance].type forKey:@"deviceType"];
    [logObject setValue:[MNUserKeyChain readUserID] forKey:@"userId"];
    [logObject setValue:[MNFirmwareModel sharestance].firmwareVersion forKey:@"firmwareVer"];
    NSArray *logArr = [NSArray arrayWithObject:logObject];
    NSDictionary *dic=@{@"log":logArr};
    [MNetManager sendUpdateBraceletDataWithData:dic];
}
-(void)updateFirmwareLog
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHMMss"];
    NSString *timeStr=[formatter stringFromDate:[NSDate date]];
    NSMutableDictionary *logObject = [NSMutableDictionary dictionary];
    [logObject setValue:@(3) forKey:@"logType"];
    [logObject setValue:@(1) forKey:@"result"];
    [logObject setValue:timeStr forKey:@"optTime"];
    [logObject setValue:[MNFirmwareModel sharestance].number forKey:@"deviceId"];
    [logObject setValue:[MNFirmwareModel sharestance].type forKey:@"deviceType"];
    [logObject setValue:[MNUserKeyChain readUserID] forKey:@"userId"];
    [logObject setValue:[MNFirmwareModel sharestance].firmwareVersion forKey:@"firmwareVer"];
    NSArray *logArr = [NSArray arrayWithObject:logObject];
    NSDictionary *dic=@{@"log":logArr};
    [MNetManager sendUpdateBraceletDataWithData:dic];
}
-(void)downloadFirmwareLog
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHMMss"];
    NSString *timeStr=[formatter stringFromDate:[NSDate date]];
    NSMutableDictionary *logObject = [NSMutableDictionary dictionary];
    [logObject setValue:@(2) forKey:@"logType"];
    [logObject setValue:@(1) forKey:@"result"];
    [logObject setValue:timeStr forKey:@"optTime"];
    [logObject setValue:[MNFirmwareModel sharestance].number forKey:@"deviceId"];
    [logObject setValue:[MNFirmwareModel sharestance].type forKey:@"deviceType"];
    [logObject setValue:[MNUserKeyChain readUserID] forKey:@"userId"];
    [logObject setValue:[MNFirmwareModel sharestance].firmwareVersion forKey:@"firmwareVer"];
    NSArray *logArr = [NSArray arrayWithObject:logObject];
    NSDictionary *dic=@{@"log":logArr};
    [MNetManager sendUpdateBraceletDataWithData:dic];
}
-(void)synchronousSleepLog:(NSArray *)sleeps
{
    __block NSMutableArray *sports = [NSMutableArray array];
    [sleeps enumerateObjectsUsingBlock:^(MNSleepModel *obj, NSUInteger idx, BOOL *stop) {
        [sports addObject:[obj toDictionary]];
    }];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHMMss"];
    NSString *timeStr=[formatter stringFromDate:[NSDate date]];
    NSMutableDictionary *logObject = [NSMutableDictionary dictionary];
    [logObject setValue:@(1) forKey:@"logType"];
    [logObject setValue:@(1) forKey:@"result"];
    [logObject setValue:timeStr forKey:@"optTime"];
    [logObject setValue:[MNFirmwareModel sharestance].number forKey:@"deviceId"];
    [logObject setValue:[MNFirmwareModel sharestance].type forKey:@"deviceType"];
    [logObject setValue:[MNUserKeyChain readUserID] forKey:@"userId"];
    [logObject setValue:[MNFirmwareModel sharestance].firmwareVersion forKey:@"firmwareVer"];
    NSArray *logArr = [NSArray arrayWithObject:logObject];
    NSDictionary *dic = @{@"sleep":sports,@"log":logArr};
    [MNetManager sendUpdateBraceletDataWithData:dic];
}

-(void)synchronousStepLog:(NSArray *)steps
{
    __block NSMutableArray *sports = [NSMutableArray array];
    [steps enumerateObjectsUsingBlock:^(MNStepModel *obj, NSUInteger idx, BOOL *stop) {
        DLog(@"obj=%@",obj);
        DLog(@"toDictionary=%@",[obj toDictionary]);
        [sports addObject:[obj toDictionary]];
    }];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *timeStr=[formatter stringFromDate:[NSDate date]];
    NSMutableDictionary *logObject = [NSMutableDictionary dictionary];
    [logObject setValue:@(1) forKey:@"logType"];
    [logObject setValue:@(1) forKey:@"result"];
    [logObject setValue:timeStr forKey:@"optTime"];
    [logObject setValue:[MNFirmwareModel sharestance].number forKey:@"deviceId"];
    [logObject setValue:[MNFirmwareModel sharestance].type forKey:@"deviceType"];
    [logObject setValue:[MNUserKeyChain readUserID] forKey:@"userId"];
    [logObject setValue:[MNFirmwareModel sharestance].firmwareVersion forKey:@"firmwareVer"];
    NSArray *logArr = [NSArray arrayWithObject:logObject];
    NSDictionary *dic = @{@"sport":sports,@"log":logArr};
    DLog(@"dic=%@",dic);
    [MNetManager sendUpdateBraceletDataWithData:dic];
}
@end
