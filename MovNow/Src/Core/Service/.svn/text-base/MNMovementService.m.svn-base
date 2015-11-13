//
//  MNMovementService.m
//  Movnow
//
//  Created by HelloWorld on 15/4/14.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//

#import "MNMovementService.h"
#import "MNSyncTimeData.h"
#import "MNBleBaseService.h"
#import "QBleClient.h"
#import "MNStepModel.h"
#import "MNStepData.h"
#import "MNPutService.h"
#import "MNDeviceBindingService.h"
#import "MNTemporaryStepData.h"
#import "MNStepData.h"
#import "MNUserModel.h"
#import "MNGoalStepData.h"
#import "MNUserKeyChain.h"
#import "MNFirmwareModel.h"
#import "MNetManager.h"
#import "MNStepViewModel.h"
typedef void (^SyncStepProgress)(int);
typedef void (^SyncStepFailure)(NSString *reason);
@interface MNMovementService()<MNBleBaseServiceStepDataDelegate,MNBleBaseServiceTempStepsDelegate>

@end
@implementation MNMovementService
{
    qBleClient *bleClient_;
    MNBleBaseService *bleBaseService_;
    SyncStepProgress syncStepProgressBlock_;
    SyncStepFailure syncStepFailureBlock_;
    
    
    int dayTotal;  //总共天数
    int dayCount;  //天数计数、长包序号
    int packageTotal; //包总数
    int packageCount;  //短包计数
    NSMutableArray *timeArr;
    BOOL isLossPag;   //是否掉包
    
    // 同步数据缓冲区
    Byte revStepTempData[6][17];  //一个长包缓存数据
    int tempLength[6];
    int tempShortCount[15];   //每一个长包中短包的长度
    Byte revStepData[15][96];
    
    Byte transferStateTable[15];        //一个长包的位域表

    NSTimer *longTimer;    //长包需要时长定时器
    BOOL isRevff;
    BOOL isRevfe;
    
    NSInteger temporaryStep_; //临时步数
}

+ (MNMovementService *)shareInstance
{
    static dispatch_once_t onceToken;
    static MNMovementService *_mnMovement = nil;
    dispatch_once(&onceToken, ^{
        _mnMovement = [[self alloc]init];
    });
    return _mnMovement;
}

- (id)init
{
    self = [super init];
    if (self) {
        _stepLastSyncTime = [[[MNSyncTimeData alloc] init] selectSyncTimeWithyncType:syncTypeStep];
        timeArr = [NSMutableArray array];
        bleClient_ = [qBleClient sharedInstance];
        bleBaseService_ = [MNBleBaseService shareInstance];
        bleBaseService_.stepDataDelegate=self;
        bleBaseService_.tempStepsDelegate=self;
        NSDate *date = [NSDate date];
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyyMMdd"];
        NSInteger time = [[df stringFromDate:date] integerValue];
        _goalStep = [[[MNGoalStepData alloc] init] selectGoalStep:time];
        temporaryStep_ = [[[MNTemporaryStepData alloc] init] selectNumber];
        _stepViewModel = [[MNStepViewModel alloc] initToday];
        
    }
    return self;
}
#pragma mark 更新同步计步时间
-(void)updateStepLastSyncTime
{
    _stepLastSyncTime = [NSDate date];
    [[[MNSyncTimeData alloc] init] updateSyncTimeWithSyncType:syncTypeStep withSyncTime:_stepLastSyncTime];
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
    syncStepFailureBlock_(@"长包接收超时");
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
        syncStepFailureBlock_(reason);
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
        syncStepFailureBlock_(reason);
    }];
}

#pragma mark cleanTransferStateTable
-(void)cleanTransferStateTable
{
    isLossPag=NO;
    DLog(@"清空位域表");
    for (int i = 0; i<15; i++) {
        transferStateTable[i] =0xff;
    }
}

#pragma mark 同步计步数据
-(void)startSyncStepDataWithSuccess:(void(^)(void))success withProgress:(void(^)(int progress))progress withFailure:(void(^)(NSString *reason))failure
{
    syncStepFailureBlock_ = [failure copy];
    syncStepProgressBlock_= [progress copy];
    progress(0);
    [bleBaseService_ syncStepWithSuccess:^(id result) {
        if ([[result allKeys] containsObject:@"totalToday"]) {
            if ([result[@"totalToday"] isEqual:@(0)]) {
                progress(100);
                DLog(@"无最新数据");
                [self updateStepLastSyncTime];
                success();
            }else
            {
                dayTotal =[result[@"totalToday"] intValue];
                [self startLongTimer];
            }

        }else{
            progress(100);
            DLog(@"同步计步数据完成");
            [self updateStepLastSyncTime];
            success();
            [_stepViewModel updateTotalStep];
            if (_delegate && [_delegate respondsToSelector:@selector(changeStepViewmodel:)]) {
                [_delegate changeStepViewmodel:_stepViewModel];
            }
        }
    } withFailure:^(id reason) {
        failure(reason);
    }];
}

-(void)startDisconnectSyncStepDataWithSuccess:(void (^)(void))success withProgress:(void (^)(int))progress withFailure:(void (^)(NSString *))failure
{
    syncStepFailureBlock_ = [failure copy];
    syncStepProgressBlock_= [progress copy];
    

    
    qBleClient *bleClient = [qBleClient sharedInstance];
    [bleClient connectBleWithBindingDeviceType:Bracelet success:^(id result) {
        MNDeviceBindingService *bindingService = [MNDeviceBindingService shareInstance];
        if ([[bindingService getDeviceFunctionWithDeviceType:bindingService.currentDeviceType] containsObject:@"BOUND"]) {
            [[MNBleBaseService shareInstance] verifyBindingWithSuccess:^(id result) {
                progress(0);
                [bleBaseService_ syncStepWithSuccess:^(id result) {
                    if ([[result allKeys] containsObject:@"totalToday"]) {
                        if ([result[@"totalToday"] isEqual:@(0)]) {
                            progress(100);
                            DLog(@"无最新数据");
                            [self updateStepLastSyncTime];
                            success();
                        }else
                        {
                            dayTotal =[result[@"totalToday"] intValue];
                            [self startLongTimer];
                        }
                        
                    }else{
                        progress(100);
                        DLog(@"同步计步数据完成");
                        [self updateStepLastSyncTime];
                        success();
                        [_stepViewModel updateTotalStep];
                        if (_delegate && [_delegate respondsToSelector:@selector(changeStepViewmodel:)]) {
                            [_delegate changeStepViewmodel:_stepViewModel];
                        }
                    }
                } withFailure:^(id reason) {
                    failure(reason);
                }];
            } withFailure:^(id reason) {
                failure(reason);
            }];
        }else
        {
            progress(0);
            [bleBaseService_ syncStepWithSuccess:^(id result) {
                if ([[result allKeys] containsObject:@"totalToday"]) {
                    if ([result[@"totalToday"] isEqual:@(0)]) {
                        progress(100);
                        DLog(@"无最新数据");
                        [self updateStepLastSyncTime];
                        success();
                    }else
                    {
                        dayTotal =[result[@"totalToday"] intValue];
                        [self startLongTimer];
                    }
                    
                }else{
                    progress(100);
                    DLog(@"同步计步数据完成");
                    [self updateStepLastSyncTime];
                    success();
                    [_stepViewModel updateTotalStep];
                    if (_delegate && [_delegate respondsToSelector:@selector(changeStepViewmodel:)]) {
                        [_delegate changeStepViewmodel:_stepViewModel];
                    }
                }
            } withFailure:^(id reason) {
                failure(reason);
            }];
        }
    } failure:^(id reason) {
        failure(reason);
    }];
}
#pragma mark  --------------------------MNBleBaseServiceDelegate----------------------------------
-(void)receviceStepData:(NSData *)stepData
{
    int length = (int)[stepData length];
    Byte temp[length];
    [stepData getBytes:temp length:length];
    switch (temp[0]) {
        case 0x5A:
            [self receive5AWithLength:length data:temp];
            break;
        default:
            break;
    }
    
}
#pragma mark  --------------------------计步数据处理模块----------------------------------

#pragma mark 5A数据
-(void)receive5AWithLength:(int)length data:(Byte *)temp
{
    switch (temp[1]) {
        case 0x05:
        {
            if(isLossPag && [self isRecvPerfect])
            {
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
                            revStepData[dayCount][tempNum]=revStepTempData[i][j];
                        }else
                        {
                            revStepData[dayCount-1][tempNum]=revStepTempData[i][j];
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
                    syncStepProgressBlock_(progress);
                    //发送下一个包
                    [self sendRevRequestCMD];
                    
                }
                
                if(isRevff)
                {
                    
                    isRevff=NO;
                    
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
                            revStepTempData[packageTotal-1][i-3]=temp[i];
                        }
                        [self sendWithTransferStateTable];
                    }
                        break;
                    case 0xfe:
                    {
                        isRevfe=YES;
                        for(int i=3;i<length;i++)
                        {
                            revStepTempData[packageTotal-1][i-3]=temp[i];
                        }
                        
                        [self sendWithTransferStateTable];
                        
                    }
                        break;
                    default:
                    {
                        for(int i=3;i<length;i++)
                        {
                            revStepTempData[packageCount-1][i-3]=temp[i];
                        }
                        int progress;
                        if (dayTotal==1) {
                            progress=(int)(((packageCount/(float)packageTotal)*(1/(float)dayTotal)+(dayCount)/(float)dayTotal)*100);
                        }else
                        {
                            progress=(int)(((packageCount/(float)packageTotal)*(1/(float)dayTotal)+(dayCount-1)/(float)dayTotal)*100);
                        }
                        DLog(@"progress=%d,packageCount=%d,packageTotal=%d,dayTotal=%d,dayCount=%d",progress,packageCount,packageTotal,dayTotal,dayCount);
                        syncStepProgressBlock_(progress);
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
    NSMutableArray *revStepArr=[NSMutableArray array];
    for(int i=0; i<dayTotal;i++)
    {
        DLog(@"tempShortCount=%d",tempShortCount[i]);
        DLog(@"time=%@",timeArr);
        int num=1;
        int sumNum =0;
        if (tempShortCount[i]>=96) {
            sumNum=96;
        }else
        {
            sumNum=tempShortCount[i];
        }
        for(int j=0;j<sumNum;j=j+2)
        {
            MNStepModel *stepModel =[[MNStepModel alloc] init];
            int stepNumber=revStepData[i][j]*256+revStepData[i][j+1];
            DLog(@"stepNumber=%d",stepNumber);
            if (stepNumber !=0) {
                stepModel.sportStep= @(stepNumber);
                int hour = num/2;
                int minute = (num%2)?30:0;
                stepModel.sportTime = [NSString stringWithFormat:@"%@%02d%02d00",(NSString *)timeArr[i],hour,minute];
                [revStepArr addObject:stepModel];
            }
            num++;
        }
    }
    [timeArr removeAllObjects];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    if (revStepArr.count >0) {
        [[MNPutService shareInstance] synchronousStepLog:revStepArr];
    }
    
    dispatch_group_async(group, queue, ^{
        if (revStepArr.count >0) {
            [[[MNStepData alloc] init] updateWithMNStepModels:revStepArr];
        }
    });
    dispatch_group_notify(group,dispatch_get_main_queue(), ^{
        [[MNBleBaseService shareInstance] setSuccessBlockWithResult:@{@"error":@"0",@"message":@"同步计步数据成功"}];
    });
}

#pragma mark --------------MNBleBaseServiceTempStepsDelegate-----------------------
-(void)receviceTempSteps:(int)steps
{
    temporaryStep_ = steps;
    [_stepViewModel updateWithTemporaryStep:steps];
    if (_delegate && [_delegate respondsToSelector:@selector(changeStepViewmodel:)]) {
        [_delegate changeStepViewmodel:_stepViewModel];
    }
}

#pragma mark 保存临时数据
-(void)saveTemporaryStep
{
    [[[MNTemporaryStepData alloc ] init] insertWithNumber:temporaryStep_];
    [[[MNGoalStepData alloc] init] updateWithGoalStep:_goalStep];
}



#pragma mark 用户设置运动目标接口
- (void)setMovementTargetWithSteps:(NSInteger)steps success:(CoreSuccess)success failure:(CoreFailure)failure
{
    __weak typeof(_delegate)weakDelegate = _delegate;
    __weak typeof (_stepViewModel)weakStepViewModel = _stepViewModel;
    _goalStep =steps;
    NSDate *date = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyyMMdd"];
    int time = [[df stringFromDate:date] intValue];
    [[MNBleBaseService shareInstance] syncWithSuccess:^(id result) {
        success(result);
        __strong typeof(weakDelegate)strongDelegate = weakDelegate;
        __strong typeof (weakStepViewModel)strongStepViewModel = weakStepViewModel;
        [strongStepViewModel updateWithGoalStep:steps];
        if (strongDelegate && [strongDelegate respondsToSelector:@selector(changeStepViewmodel:)]) {
            [strongDelegate changeStepViewmodel:strongStepViewModel];
        }
        
    } withBinding:NO withFailure:^(id reason) {
        failure(reason);
        _goalStep =[[[MNGoalStepData alloc] init] selectGoalStep:time];
    }];
}

#pragma mark 下载网络数据
-(void)downNetMovementDateWithStartData:(NSString *)startData withEndData:(NSString *)endData withSuccess:(CoreSuccess)success
{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setValue:@"bracelet.getsportsdata" forKey:@"method"];
    [parameter setValue:[MNUserKeyChain readUserID] forKey:@"userId"];
    [parameter setValue:[MNFirmwareModel sharestance].number forKey:@"deviceId"];
    [parameter setValue:startData forKey:@"startDate"];
    [parameter setValue:endData forKey:@"endDate"];
    [MNetManager netGetCacheWithParameter:parameter success:^(id result) {
        //网络下载运动数据
        if ([(NSString *)result[@"error"] isEqualToString:@"0"]) {
            __block NSMutableArray *steps = [NSMutableArray array];
            [((NSArray *)result[@"sports"]) enumerateObjectsUsingBlock:^(NSDictionary *sport, NSUInteger idx, BOOL *stop) {
                MNStepModel *stepModel = [[MNStepModel alloc] init];
                stepModel.sportTime = sport[@"sportTime"];
                stepModel.sportStep = sport[@"sportStep"];
                [steps addObject:stepModel];
            }];
            
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_group_t group = dispatch_group_create();
            
            dispatch_group_async(group, queue, ^{
                if (steps.count >0) {
                    [[[MNStepData alloc] init] updateWithMNStepModels:steps];
                }
            });
            
            dispatch_group_notify(group,dispatch_get_main_queue(), ^{
                NSSet *set = [[[MNStepData alloc] init] selectFromStepWithAllTime];
                success(@{@"times":set,@"messsage":@"数据下载完毕"});
            });
            
        }
        
    } failure:nil loginOut:nil];
}


#pragma mark  下载最近一个月的计步数据
-(void)downLastMonthMovementDateWithSuccess:(CoreSuccess)success
{
    __weak typeof(_delegate)weakDelegate = _delegate;
    __weak typeof (_stepViewModel)weakStepViewModel = _stepViewModel;
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyyMMdd"];
    NSString *startDate = [format stringFromDate:[NSDate preDay:[NSDate date] Days:30]];
    NSString *endDate = [format stringFromDate:[NSDate date]];
    [self downNetMovementDateWithStartData:startDate withEndData:endDate withSuccess:^(id result) {
        success(result);
        __strong typeof(weakDelegate)strongDelegate = weakDelegate;
        __strong typeof (weakStepViewModel)strongStepViewModel = weakStepViewModel;
        [strongStepViewModel updateTotalStep];
        if (strongDelegate && [strongDelegate respondsToSelector:@selector(changeStepViewmodel:)]) {
            [strongDelegate changeStepViewmodel:strongStepViewModel];
        }
        
    }];
}

#pragma mark 根据运动数据模型的内容获取分享的文字
-(NSString *)getShareTextWithStepsModel:(MNStepViewModel *)model
{
    NSString *shareText = nil;
    NSString *dateStr = [NSDate getTimeInfoWithDate:[NSDate date]];
    NSInteger currentSteps = [model.steps integerValue];
    
    if (currentSteps == 0) {
        shareText = [NSString stringWithFormat:
                     NSLocalizedString(@"%@ 额，我今天比较懒，没挪动一步...",nil),dateStr];
    } else if (currentSteps < 7000){
        shareText = [NSString stringWithFormat:NSLocalizedString(@"%@ 我走了%d步，连普通目标都没完成", nil),dateStr,currentSteps];
    } else if (currentSteps < 12000 && currentSteps >=7000) {
        shareText = [NSString stringWithFormat:NSLocalizedString(@"%@ 我走了%d步，完成普普通通目标", nil),dateStr,currentSteps];
    } else if (currentSteps < 17000 && currentSteps >= 12000) {
        shareText = [NSString stringWithFormat:NSLocalizedString(@"%@ 我走了%d步，完成了我的目标，获得活跃分子称号",nil),dateStr,currentSteps];
    } else if (currentSteps >= 17000){
        shareText = [NSString stringWithFormat:NSLocalizedString(@"%@ 我走了%d步，完成了我的目标，荣升减肥牛人",nil),dateStr,currentSteps];
    }
    
    return shareText;
}

-(void)unBindingSyncTime
{
    _stepLastSyncTime = nil;
    [[[MNSyncTimeData alloc]init]deleteAll];
}

#pragma mark 获取行走里程
+(CGFloat)getMileageWithSteps:(NSInteger)steps
{
    NSInteger stepLength = [self readDisCMByHeight:[[MNUserModel shareInstance].height intValue]];
    return (stepLength * steps)/100000.0;
}

#pragma mark 获取卡路里

+(CGFloat)getCalorieWithSteps:(NSInteger)steps
{
    CGFloat mileage = [self getMileageWithSteps:steps];
    CGFloat Weight = [[MNUserModel shareInstance].weight floatValue];
    return 0.6 * Weight * mileage;
}


#pragma mark 计算步长
+(int)readDisCMByHeight:(int)hei
{
    int tempHei = hei;
    
    if (tempHei < 50) {
        tempHei = 50;
    } else if (tempHei > 190) {
        tempHei = 190;
    } else {
        if (tempHei%10) {
            tempHei = (tempHei/10+1)*10;
        } else {
            tempHei = tempHei/10*10;
        }
    }
    
    int stepLength;
    switch (tempHei) {
        case 50:
        {
            stepLength = 20;
        }
            break;
        case 60:
        {
            stepLength = 22;
        }
            break;
        case 70:
        {
            stepLength = 25;
        }
            break;
        case 80:
        {
            stepLength = 29;
        }
            break;
        case 90:
        {
            stepLength = 33;
        }
            break;
        case 100:
        {
            stepLength = 37;
        }
            break;
        case 110:
        {
            stepLength = 40;
        }
            break;
        case 120:
        {
            stepLength = 44;
        }
            break;
        case 130:
        {
            stepLength = 48;
        }
            break;
        case 140:
        {
            stepLength = 51;
        }
            break;
        case 150:
        {
            stepLength = 55;
        }
            break;
        case 160:
        {
            stepLength = 59;
        }
            break;
        case 170:
        {
            stepLength = 62;
        }
            break;
        case 180:
        {
            stepLength = 66;
        }
            break;
        case 190:
        {
            stepLength = 70;
        }
            break;
        default:
            break;
    }
    return stepLength;
}

@end
