//
//  MNSleepService.m
//  Movnow
//
//  Created by HelloWorld on 15/4/14.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//

#import "MNSleepService.h"
#import "MNSyncTimeData.h"
#import "MNBleBaseService.h"
#import "QBleClient.h"
#import "MNSleepData.h"
#import "MNSleepModel.h"
#import "MNPutService.h"
#import "MNSleepViewModel.h"
#import "MNSleepData.h"
#import "MNUserKeyChain.h"
#import "MNFirmwareModel.h"
#import "MNetManager.h"
typedef void (^SyncSleepProgress)(int);
typedef void (^SyncSleepFailure)(NSString *reason);
@interface MNSleepService()<MNBleBaseServiceSleepDataDelegate>
@end
@implementation MNSleepService
{
    qBleClient *bleClient_;
    MNBleBaseService *bleBaseService_;
    SyncSleepProgress syncSleepProgressBlock_;
    SyncSleepFailure syncSleepFailureBlock_;
    
    int dayTotal;  //总共天数
    int dayCount;  //天数计数、长包序号
    int packageTotal; //包总数
    int packageCount;  //短包计数
    NSMutableArray *timeArr;
    
    
    
    BOOL isLossPag;   //是否掉包
    
    // 同步数据缓冲区
    Byte revSleepTempData[12][17];  //一个长包缓存数据
    int tempLength[12];
    int tempShortCount[15];   //每一个长包中短包的长度
    Byte revSleepData[15][196];
    
    Byte transferStateTable[15];        //一个长包的位域表
    
    
    NSTimer *longTimer;    //长包需要时长定时器
    
    BOOL isRevff;
    BOOL isRevfe;
}

+ (MNSleepService *)shareInstance
{
    static dispatch_once_t onceToken;
    static MNSleepService *_mnSleep = nil;
    dispatch_once(&onceToken, ^{
        _mnSleep = [[self alloc]init];
    });
    return _mnSleep;
}

- (id)init
{
    self = [super init];
    if (self) {
        _sleepLastSyncTime = [[[MNSyncTimeData alloc] init] selectSyncTimeWithyncType:syncTypeSleep];
        bleClient_ = [qBleClient sharedInstance];
        bleBaseService_ = [MNBleBaseService shareInstance];
        bleBaseService_.sleepDataDelegate=self;
        _sleepViewModel = [[MNSleepViewModel alloc] initToday];
    }
    return self;
}

-(void)updateSleepLastSyncTime
{
    _sleepLastSyncTime = [NSDate date];
    [[[MNSyncTimeData alloc] init] updateSyncTimeWithSyncType:syncTypeSleep withSyncTime:_sleepLastSyncTime];
}

#pragma mark 停止长包定时器
-(void)stopLongTimer
{
    if(longTimer)
    {
        [longTimer invalidate];
        longTimer=nil;
    }
    
}

#pragma mark 开始长包定时器
-(void)startLongTimer
{
    [self stopLongTimer];
    longTimer = [NSTimer scheduledTimerWithTimeInterval:30.f target:self selector:@selector(longTimeOut) userInfo:nil repeats:NO];
}

#pragma mark 长包超时
-(void)longTimeOut
{
    [self stopLongTimer];
    syncSleepFailureBlock_(@"长包接收超时");
}

#pragma mark 位域表
-(void)sendWithTransferStateTable
{
    DLog(@"发送位域表");
    Byte temp[20]={0};
    temp[0]=0x5B;
    temp[1]=0x05;
    temp[3] =dayCount/256;
    temp[4] = dayCount%256;
    for(int i=0;i<15;i++)
    {
        temp[5+i]=transferStateTable[i];
    }
    
    NSData *data=[NSData dataWithBytes:temp length:20];
    [bleClient_ sendData:data withFailure:^(id reason) {
        syncSleepFailureBlock_(reason);
    }];
}

#pragma mark 判断所有位域表，是否收到所有包
-(BOOL)isRecvPerfect
{
    for (int i = 0; i<15; i++) {
        if (transferStateTable[i] != 0) {
            DLog(@"有掉包");
            isLossPag=YES;
            return NO;
        }
    }
    DLog(@"无掉包");
    return YES;
}

#pragma mark - 发送'长包接收完毕'（请求下一长包)
-(void)sendRevRequestCMD
{
    NSLog(@"请求下一个包");
    [self stopLongTimer];
    Byte temp[5]={0};
    temp[0]=0x5A;
    temp[1]=0x06;
    temp[3]=dayCount/256;
    temp[4]=dayCount%256;
    NSData *data=[NSData dataWithBytes:temp length:5];
    [bleClient_ sendData:data withFailure:^(id reason) {
        syncSleepFailureBlock_(reason);
    }];
}

#pragma mark 清除位域表
-(void)cleanTransferStateTable
{
    isLossPag=NO;
    DLog(@"清空位域表");
    for (int i = 0; i<15; i++) {
        transferStateTable[i] =0xff;
    }
}

-(void)startSyncSleepDataWithSuccess:(void(^)(void))success withProgress:(void(^)(int progress))progress withFailure:(void(^)(NSString *reason))failure
{
    syncSleepFailureBlock_ = [failure copy];
    syncSleepProgressBlock_ = [progress copy];
    progress(0);
    [bleBaseService_ syncSleepWithSuccess:^(id result) {
        if ([[result allKeys] containsObject:@"totalToday"]) {
            if ([result[@"totalToday"] isEqual:@(0)]) {
                progress(100);
                DLog(@"无最新数据");
                [self updateSleepLastSyncTime];
                success();
            }else
            {
                dayTotal =[result[@"totalToday"] intValue];
                [self startLongTimer];
            }
            
        }else{
            progress(100);
            DLog(@"同步计步数据完成");
            [self updateSleepLastSyncTime];
            [_sleepViewModel updateTotalSleep];
            if (_delegate && [_delegate respondsToSelector:@selector(changeSleepViewModel:)]) {
                [_delegate changeSleepViewModel:_sleepViewModel];
            }
            success();
        }
        
    } withFailure:^(id reason) {
        failure(reason);
    }];
}

- (void)downNetSleepDateWithStartData:(NSString *)startData withEndData:(NSString *)endData withSuccess:(CoreSuccess)success
{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setValue:@"bracelet.getsleepdata" forKey:@"method"];
    [parameter setValue:[MNUserKeyChain readUserID] forKey:@"userId"];
    [parameter setValue:[MNFirmwareModel sharestance].number forKey:@"deviceId"];
    [parameter setValue:startData forKey:@"startDate"];
    [parameter setValue:endData forKey:@"endDate"];
    [MNetManager netGetCacheWithParameter:parameter success:^(id result) {
        if ([(NSString *)result[@"error"] isEqualToString:@"0"]) {
            __block NSMutableArray *sleeps = [NSMutableArray array];
            [((NSArray *)result[@"sleeps"]) enumerateObjectsUsingBlock:^(NSDictionary *sleep, NSUInteger idx, BOOL *stop) {
                MNSleepModel *sleepModel = [[MNSleepModel alloc] init];
                sleepModel.dateTime = sleep[@"dateTime"];
                sleepModel.startTime= sleep[@"startTime"];
                sleepModel.sleepDuration= sleep[@"sleepDuration"];
                sleepModel.sleepState= sleep[@"sleepState"];
                [sleeps addObject:sleepModel];
            }];
            
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_group_t group = dispatch_group_create();
            
            dispatch_group_async(group, queue, ^{
                if (sleeps.count >0) {
                    [[[MNSleepData alloc] init] updateWithMNSleepModels:sleeps];
                }
            });
            
            dispatch_group_notify(group,dispatch_get_main_queue(), ^{
                NSSet *set = [[[MNSleepData alloc] init] selectFromSleepWithAllTime];
                success(@{@"times":set,@"message":@"睡眠数据下载完毕"});
            });
            
        }
    } failure:nil loginOut:nil];
    
}

-(void)downLastMonthSleepDateWithSuccess:(CoreSuccess)success
{
    __weak typeof(_delegate)weakDelegate = _delegate;
    __weak typeof (_sleepViewModel)weakSleepViewModel = _sleepViewModel;
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyyMMdd"];
    NSString *startDate = [format stringFromDate:[NSDate preDay:[NSDate date] Days:30]];
    NSString *endDate = [format stringFromDate:[NSDate date]];
    [self downNetSleepDateWithStartData:startDate withEndData:endDate withSuccess:^(id result) {
        success(result);
        __strong typeof(weakDelegate)strongDelegate = weakDelegate;
        __strong typeof (weakSleepViewModel)strongSleepViewModel = weakSleepViewModel;
        [strongSleepViewModel updateTotalSleep];
        if (strongDelegate && [strongDelegate respondsToSelector:@selector(changeSleepViewModel:)]) {
            [strongDelegate changeSleepViewModel:_sleepViewModel];
        }
    }];
}

#pragma mark  --------------------------MNBleBaseServiceDelegate----------------------------------
-(void)receviceSleepData:(NSData *)sleepData
{
    int length = (int)[sleepData length];
    Byte temp[length];
    [sleepData getBytes:temp length:length];
    switch (temp[0]) {
        case 0x5A:
            [self receive5AWithLength:length data:temp];
            break;
        default:
            break;
    }
}
#pragma mark  --------------------------睡眠数据处理模块----------------------------------

#pragma mark 5A数据
-(void)receive5AWithLength:(int)length data:(Byte *)temp
{
    switch (temp[1]) {
        case 0x05:
        {
            if(isLossPag && [self isRecvPerfect])
            {
                //
                [self sendRevRequestCMD];
            }
            
            if(temp[2]==0x01)
            {
                //第一个短包
                [self startLongTimer];
                packageCount=0;
                NSString *timeStr=[NSString stringWithFormat:@"%04d%02d%02d",2000+temp[10],temp[11],temp[12]];
                [timeArr addObject:timeStr];
                int shortCount=temp[3]*256+temp[4];
                NSLog(@"shortCount=%d",shortCount);
                packageTotal=shortCount%17?(shortCount/17+1):(shortCount/17);
                dayCount=temp[5]*256+temp[6];
                for (int i=packageTotal; i<=120; i++) {
                    if(i%8)
                    {
                        transferStateTable[i/8] &=  ~(1<<(8-(temp[2]%8)));
                    }else
                    {
                        transferStateTable[i/8-1] &=0;
                    }
                }
                //填充位域表
                if(temp[2]%8)
                {
                    transferStateTable[temp[2]/8] &= ~(1<<(8-(temp[2]%8)));
                }else{
                    transferStateTable[(temp[2]/8)-1] &=0;
                }
            }else if (temp[2]==0)
            {
                [self stopLongTimer];
                [self cleanTransferStateTable];
                int tempNum=0;
                for(int i=0;i<packageTotal;i++)
                {
                    for(int j=0;j<tempLength[i];j++)
                    {
                        
                        
                        if (dayTotal == 1) {
                            revSleepData[dayCount][tempNum]=revSleepTempData[i][j];
                        }else
                        {
                            revSleepData[dayCount-1][tempNum]=revSleepTempData[i][j];
                        }
                        
                        tempNum++;
                    }
                    
                    
                }
                
                if (dayTotal == 1) {
                    tempShortCount[dayCount]=tempNum;
                }else
                {
                    tempShortCount[dayCount-1]=tempNum;
                }
                
                if(isRevfe)
                {
                    isRevfe=NO;
                    int progress=(int)((dayCount/(float)dayTotal)*100);
                    
                    syncSleepProgressBlock_(progress);
                    //发送下一个包
                    [self sendRevRequestCMD];
                    
                }
                
                if(isRevff)
                {
                    
                    isRevff=NO;
                    syncSleepProgressBlock_(100);
                    // 封装数据
                    [self analysicSyncData];
                }
                
                
            }else
            {
                //填充位域表
                
                if(temp[2]%8)
                {
                    transferStateTable[temp[2]/8] &= ~(1<<(8-(temp[2]%8)));
                }else{
                    transferStateTable[(temp[2]/8)-1] &=0;
                }
                packageCount++;
                if(temp[2]==0xff || temp[2]==0xfe)
                {
                    tempLength[packageTotal-1]=length-3;
                }else{
                    tempLength[temp[2]-2]=length-3;
                }
                
                
                switch (temp[2]) {
                    case 0xff:
                    {
                        isRevff=YES;
                        for(int i=3;i<length;i++)
                        {
                            revSleepTempData[packageTotal-1][i-3]=temp[i];
                        }
                        [self sendWithTransferStateTable];
                    }
                        break;
                    case 0xfe:
                    {
                        isRevfe=YES;
                        for(int i=3;i<length;i++)
                        {
                            revSleepTempData[packageTotal-1][i-3]=temp[i];
                        }
                        
                        [self sendWithTransferStateTable];
                        
                    }
                        break;
                    default:
                    {
                        for(int i=3;i<length;i++)
                        {
                            revSleepTempData[packageCount-1][i-3]=temp[i];
                        }
                        int progress=(int)(((packageCount/(float)packageTotal)*(1/(float)dayTotal)+(dayCount-1)/(float)dayTotal)*100);
                        syncSleepProgressBlock_(progress);
                    }
                        break;
                }
            }
        }
            break;
            
        default:
            break;
    }
}
#pragma mark - 数据接收完毕，进行封装
-(void)analysicSyncData
{
    NSMutableArray *revSleepArr=[NSMutableArray array];
    for(int i=0; i<dayTotal;i++)
    {
        for(int j=0;j<tempShortCount[i];j=j+4)
        {
            if(revSleepData[i][j+2]==0)
            {
                continue;
            }
            MNSleepModel *sleepModel = [[MNSleepModel alloc] init];
            sleepModel.dateTime = (NSString *)timeArr[i];
            sleepModel.startTime = @(revSleepData[i][j]*256+revSleepData[i][j+1]);
            sleepModel.sleepDuration =@(revSleepData[i][j+2]);
            sleepModel.sleepState = @(revSleepData[i][j+3]);
            DLog(@"日期:%@,起始时间:%@,持续时长:%@,状态:%@",sleepModel.dateTime,sleepModel.startTime,sleepModel.sleepDuration,sleepModel.sleepState);
            [revSleepArr addObject:sleepModel];
        }
        
    }
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    [[MNPutService shareInstance] synchronousSleepLog:revSleepArr];
    
    dispatch_group_async(group, queue, ^{
        [[[MNSleepData alloc] init] updateWithMNSleepModels:revSleepArr];
    });
    dispatch_group_notify(group,dispatch_get_main_queue(), ^{
        [[MNBleBaseService shareInstance] setSuccessBlockWithResult:@{@"error":@"0",@"message":@"同步睡眠数据成功"}];
    });
}
@end
