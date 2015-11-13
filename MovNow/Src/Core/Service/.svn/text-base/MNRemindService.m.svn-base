 //
//  MNRemindService.m
//  Movnow
//
//  Created by HelloWorld on 15/4/14.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//

#import "MNRemindService.h"
#import "MNBleBaseService.h"
#import "MNRemindData.h"
#import "MNSedentaryData.h"
#import "MNOnceRemind.h"
@implementation MNRemindService
{
    MNBleBaseService *bleBaseService_;
}

+ (MNRemindService *)shareInstance
{
    static dispatch_once_t onceToken;
    static MNRemindService *_mnRemind = nil;
    dispatch_once(&onceToken, ^{
        _mnRemind = [[self alloc]init];
    });
    return _mnRemind;
}

- (id)init
{
    self = [super init];
    if (self) {
        bleBaseService_ = [MNBleBaseService shareInstance];
        MNRemindData *remindData = [[MNRemindData alloc] init];
        MNOnceRemind *onceReminData = [[MNOnceRemind alloc] init];
        _drinkReminds = [NSMutableArray arrayWithArray:[remindData selectClockReminds]];
        _clockReminds = [NSMutableArray arrayWithArray:[remindData selectDrinkRemind]];
        _eventReminds = [NSMutableArray arrayWithArray:[onceReminData seletOnceReminds]];
        MNSedentaryData *sedentaryData = [[MNSedentaryData alloc] init];
        NSDictionary *dic = [sedentaryData select];
        if (dic) {
            _sedentary = dic[@"sedentary"];
            _interval = dic[@"interval"];
            _openType = [dic[@"remindType"] intValue];
        }else
        {
            _sedentary = @"";
            _interval = @(30);
            _openType = WarnEventTypeClose;
        }
        
    }
    return self;
}

#pragma mark 刷新事件提醒数组
-(void)refreshEventReminds
{
     NSDateFormatter *dfDate = [[NSDateFormatter alloc] init];
    [dfDate setDateFormat:@"yyyyMMHHmm"];
    NSInteger today = [[dfDate stringFromDate:[NSDate date]] integerValue];
    __block NSMutableArray *reminds = [NSMutableArray array];
    [_eventReminds enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
        if ([obj[@"date"] integerValue] > today) {
            [obj setValue:@(OnceTypeOpen) forKey:@"type"];
        }else
        {
            [obj setValue:@(OnceTypeClose) forKey:@"type"];
        }
        [reminds addObject:obj];
    }];
    [_eventReminds removeAllObjects];
    [_eventReminds addObjectsFromArray:(NSArray *)reminds];
}

#pragma mark ---------------- 新增闹钟(起床)提醒---------------------
-(void)addClockRemindWithHour:(int)hour withMin:(int)min withSuccess:(void (^)(void))success withFailure:(void (^)(NSString *))failure
{
    [self startWithRemindType:RemindTypeClock withWarnEventType:WarnEventTypeOpen withHour:hour withMin:min withSuccess:^{
        [_clockReminds addObject:[NSString stringWithFormat:@"%02d:%02d",hour,min]];
        [_clockReminds sortUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
            NSComparisonResult result  = [obj1 compare:obj2];
            return result;
        }];
        success();
        
    } withFailure:^(NSString *messgae) {
        failure(messgae);
    }];
}

#pragma mark ---------------------删除闹钟(起床)提醒-----------------------

-(void)deleteClockRemindWithHour:(int)hour withMin:(int)min withSuccess:(void (^)(void))success withFailure:(void (^)(NSString *))failure
{
    [self startWithRemindType:RemindTypeClock withWarnEventType:WarnEventTypeClose withHour:hour withMin:min withSuccess:^{
        [self deleteCLockRemindsWithRemind:[NSString stringWithFormat:@"%02d:%02d",hour,min]];
        [_clockReminds sortUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
            NSComparisonResult result  = [obj1 compare:obj2];
            return result;
        }];
        success();
    } withFailure:^(NSString *messgae) {
        failure(messgae);
    }];
}

#pragma mark 删除闹钟提醒
-(void)deleteCLockRemindsWithRemind:(NSString *)remind
{
    NSInteger count = [_clockReminds count];
    for (NSInteger i =0; i<count; i++) {
        if ([_clockReminds[i] isEqualToString:remind]) {
            [_clockReminds removeObjectAtIndex:i];
        }
    }
}

#pragma mark 新增喝水提醒
-(void)addDrinkRemindWithHour:(int)hour withMin:(int)min withSuccess:(void (^)(void))success withFailure:(void (^)(NSString *))failure
{
    [self startWithRemindType:RemindTypeDrink withWarnEventType:WarnEventTypeOpen withHour:hour withMin:min withSuccess:^{
        [_drinkReminds addObject:[NSString stringWithFormat:@"%02d:%02d",hour,min]];
        [_drinkReminds sortUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
            NSComparisonResult result  = [obj1 compare:obj2];
            return result;
        }];
        DLog(@"drinkReminds=%@",_drinkReminds);
        success();
    } withFailure:^(NSString *messgae) {
        failure(messgae);
    }];
}
#pragma mark 删除喝水提醒
-(void)deleteDrinkRemindWithHour:(int)hour withMin:(int)min withSuccess:(void (^)(void))success withFailure:(void (^)(NSString *))failure
{
    [self startWithRemindType:RemindTypeDrink withWarnEventType:WarnEventTypeClose withHour:hour withMin:min withSuccess:^{
        [self deleteDrinkRemindsWithRemind:[NSString stringWithFormat:@"%02d:%02d",hour,min]];
        [_drinkReminds sortUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
            NSComparisonResult result  = [obj1 compare:obj2];
            return result;
        }];
        success();
    } withFailure:^(NSString *messgae) {
        failure(messgae);
    }];
}

#pragma mark 删除喝水提醒
-(void)deleteDrinkRemindsWithRemind:(NSString *)remind
{
    NSInteger count = [_drinkReminds count];
    for (NSInteger i =0; i<count; i++) {
        if ([_drinkReminds[i] isEqualToString:remind]) {
            [_drinkReminds removeObjectAtIndex:i];
        }
    }
}


#pragma mark 喝水、闹钟和单次提醒蓝牙发送
-(void)startWithRemindType:(RemindType)remindType withWarnEventType:(WarnEventType)eventType withHour:(int)hour withMin:(int)min withSuccess:(void (^)(void))success withFailure:(void (^)(NSString *))failure
{
    Byte byteData[15] ={0};
    byteData[0] = 0x5A;
    byteData[1] = 0x14;
    
    switch (remindType) {
        case RemindTypeDrink:
        case RemindTypeOnce:
            byteData[4] = 0x01;
            break;
        case RemindTypeSedentary:
            byteData[4] = 0x02;
            break;
        case RemindTypeClock:
            byteData[4] = 0x03;
            break;
        default:
            break;
    }
    if (eventType == WarnEventTypeOpen) {
        byteData[5] = 0x01;
    }
    byteData[6]= hour;
    byteData[7]= min;
    if (remindType != RemindTypeOnce) {
        byteData[8]=1;
        byteData[9]=1;
        byteData[10]=1;
        byteData[11]=1;
        byteData[12]=1;
        byteData[13]=1;
        byteData[14]=1;
    }
    NSData *sendData = [NSData dataWithBytes:byteData length:15];
    [bleBaseService_ warnWithData:sendData withSuccess:^(id result) {
        if ([result[@"error"] isEqualToString:@"0"]) {
            DLog(@"message=%@",result[@"message"]);
            success();
        }else
        {
            failure(result[@"message"]);
        }
    } withFailure:^(id reason) {
        failure(reason);
    }];
    
}

#pragma mark 久坐提醒蓝牙发送
-(void)SedentaryWarnWithWarnEventType:(WarnEventType)eventType withDuration:(int)duration withStartHour:(int)startHour withStartMin:(int)startMin withEndHour:(int)EndHour withEndMin:(int)EndMin withSuccess:(void (^)(void))success withFailure:(void (^)(NSString *))failure
{
    
    __weak typeof(_sedentary)weakSedentary=_sedentary;
    __weak typeof(_interval)weakInterval=_interval;
    Byte byteData[20] ={0};
    byteData[0] = 0x5A;
    byteData[1] = 0x14;
    byteData[4] = 0x02;
    if (eventType == WarnEventTypeOpen) {
        byteData[5] = 0x01;
    }
    byteData[6]=duration/60;
    byteData[7]=duration%60;
    byteData[8]=startHour;
    byteData[9]=startMin;
    byteData[10]=EndHour;
    byteData[11]=EndMin;
     NSData *sendData = [NSData dataWithBytes:byteData length:12];
    [bleBaseService_ warnWithData:sendData withSuccess:^(id result) {
        if ([result[@"error"] isEqualToString:@"0"]) {
            DLog(@"message=%@",result[@"message"]);
            __strong typeof(weakSedentary)strongSedentary=weakSedentary;
            __strong typeof(weakInterval)strongInterval=weakInterval;
            strongInterval =@(duration);
            strongSedentary = [NSString stringWithFormat:@"%02d:%02d-%02d:%02d",startHour,startMin,EndHour,EndMin];
            _openType=eventType;
            success();
        }else
        {
            failure(result[@"message"]);
        }
    } withFailure:^(id reason) {
        failure(reason);
    }];
}


#pragma mark 存储提醒数据(退出APP)
-(void)saveReminds
{
    [[[MNRemindData alloc ] init] updateWithDrinkRemind:_drinkReminds withClockRemind:_clockReminds];
    [[[MNSedentaryData alloc] init] updateWithSedentary:_sedentary withInterval:_interval withRemindType:@(_openType)];
    [[[MNOnceRemind alloc]init]insertWithOnceReminds:_eventReminds];
}

@end
