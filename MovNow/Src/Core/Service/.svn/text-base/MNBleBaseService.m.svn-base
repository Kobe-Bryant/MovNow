//
//  MNBleBaseService.m
//  Movnow
//
//  Created by baoyx on 15/4/22.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//

#import "MNBleBaseService.h"
#import "QBleClient.h"
#import "NSDate+Expend.h"
#import "MNUserService.h"
#import "MNUserModel.h"
#import "MNFirmwareModel.h"
#import "MNMovementService.h"
#import "MNSleepService.h"
#import <CoreBluetooth/CoreBluetooth.h>
typedef NS_ENUM(NSInteger,BleFunctionState){
    BleFunctionStateFree = 0,//空闲状态
    BleFunctionStateSync, //同步设备(时间、身高、体重等等)
    BleFunctionStateStep,   //同步计步
    BleFunctionStateSleep,  //同步睡眠
    BleFunctionStateSelectBinding, //查询绑定
    BleFunctionStateEntryBinding, //申请绑定
    BleFunctionStateVerifyBinding, //确认绑定
    BleFunctionStateRemoveBinding, //解除绑定
    BleFunctionStateFindDevice,  //查找设备
    BleFunctionStateLost,        //防丢开关
    BleFunctionStateKeyLock,     //按键锁定(拍照)
    BleFunctionStateLight,      //灯色切换
    BleFunctionStateSelectFirmware, // 查询固件
    BleFunctionStateWarn,           //提醒
    BleFunctionStateCallWarn,       //来电提醒开关
    BleFunctionStateSMSWarn,        //短信提醒开关
    BleFunctionStateElectricity,    //查询设备电量
    BleFunctionStateDialogOtaUpgrade, //dialogOTA升级
    BleFunctionStateOldUpgrade,       //Q1升级
    BleFunctionStateNewUpgrade,       //Q2升级
    
};

typedef void (^SyncSuccess)(id);   //同步成功
typedef void (^SyncFailure)(id);   //同步失败
typedef void (^StepSuccess)(id); //同步计步成功
typedef void (^StepFailure)(id); //同步计步失败
typedef void (^SleepSuccess)(id); //同步睡眠成功
typedef void (^SleepFailure)(id); //同步睡眠失败
typedef void (^SelectBindingSuccess)(id); //查询绑定成功
typedef void (^SelectBindingFailure)(id); //查询绑定失败
typedef void (^EntryBindingSuccess)(id); //申请绑定成功
typedef void (^EntryBindingFailure)(id); //申请绑定失败
typedef void (^VerifyBindingSuccess)(id); //确认绑定成功
typedef void (^VerifyBindingFailure)(id); //确认绑定失败
typedef void (^RemoveBindingSuccess)(id); //解除绑定成功
typedef void (^RemoveBindingFailure)(id); //解除绑定失败
typedef void (^FindDeviceSuccess)(id);  //查找设备成功
typedef void (^FindDeviceFailure)(id);  //查找设备失败
typedef void (^LostSuccess)(id);        //防丢成功
typedef void (^LostFailure)(id);        //防丢失败
typedef void (^KeyLockSuccess)(id);     //按键锁定成功
typedef void (^KeyLockFailure)(id);     //按键锁定失败
typedef void (^LightSuccess)(id);       //灯色切换成功
typedef void (^LightFailure)(id);       //灯色切换失败
typedef void (^SelectFirmwareSuccess)(id); //查询固件成功
typedef void (^SelectFirmwareFailure)(id); //查询固件失败
typedef void (^WarnSuccess)(id);       //提醒成功
typedef void (^WarnFailure)(id);       //提醒失败
typedef void (^CallWarnSuccess)(id);   //来电提醒成功
typedef void (^CallWarnFailure)(id);   //来电提醒失败
typedef void (^SMSWarnSuccess)(id);    //短信提醒成功
typedef void (^SMSWarnFailure)(id);    //短信提醒失败
typedef void (^ElectricitySuccess)(id); //查询设备成功
typedef void (^ElectricityFailure)(id); //查询设备失败
typedef void (^DialogOtaUpgradeSuccess)(id);
typedef void (^DialogOtaUpgradeFailure)(id);
@interface MNBleBaseService()<bleUpdateForDataDelegate>

@end
@implementation MNBleBaseService
{
    BOOL isFree_; //是否空闲状态
    BleFunctionState state_;
    NSMutableArray *datas_;
    qBleClient *bleClient_;
    
    SyncSuccess syncSuccessBlock_;
    SyncFailure syncFailureBlock_;
    StepSuccess stepSuccessBlock_;
    StepFailure stepFailureBlock_;
    SleepSuccess sleepSuccessBlock_;
    SleepFailure sleepFailureBlock_;
    SelectBindingSuccess selectBindingSuccessBlock_;
    SelectBindingFailure selectBindingFailureBlock_;
    EntryBindingSuccess entryBindingSuccessBlock_;
    EntryBindingFailure entryBindingFailureBlock_;
    VerifyBindingSuccess verifyBindingSuccessBlock_;
    VerifyBindingFailure verifyBindingFailureBlock_;
    RemoveBindingSuccess removeBindingSuccessBlock_;
    RemoveBindingFailure removeBindingFailureBlock_;
    FindDeviceSuccess findDeviceSuccessBlock_;
    FindDeviceFailure findDeviceFailureBlock_;
    LostSuccess lostSuccessBlock_;
    LostFailure lostFailureBlock_;
    KeyLockSuccess keyLockSuccessBlock_;
    KeyLockFailure KeyLockFailureBlock_;
    LightSuccess lightSuccessBlock_;
    LightFailure lightFailureBlock_;
    SelectFirmwareSuccess selectFirmwareSuccessBlock_;
    SelectFirmwareFailure selectFirmwareFailureBlock_;
    WarnSuccess warnSuccessBlock_;
    WarnFailure warnFailureBlock_;
    CallWarnSuccess callWarnSuccessBlock_;
    CallWarnFailure callWarnFailureBlock_;
    SMSWarnSuccess sMSWarnSuccessBlock_;
    SMSWarnFailure sMSWarnFailureBlock_;
    ElectricitySuccess electricitySuccessBlock_;
    ElectricityFailure electricityFailureBlock_;
    DialogOtaUpgradeSuccess dialogOtaUpgradeSuccessBlock_;
    DialogOtaUpgradeFailure dialogOtaUpgradeFailureBlock_;
    
    NSTimer *sendTimeOut_;  //发送定时器
}
+(MNBleBaseService*)shareInstance
{
    static MNBleBaseService *simple;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        simple = [[MNBleBaseService alloc] init];
    });
    return simple;
}
-(instancetype)init
{
    if (self=[super init]) {
        isFree_ =YES ;
        bleClient_ = [qBleClient sharedInstance];
        bleClient_.bleUpdateForDataDelegate=self;
        datas_ = [NSMutableArray array];
    }
    return self;
}

#pragma mark 更新发送数据到缓存中
-(void)updateData:(NSData *)data functionState:(BleFunctionState)state
{
    [datas_ addObject:@{@"data":data,@"state":@(state)}];
    if (isFree_) {
        [self sendWithBleData];
    }
}

#pragma 发送数据到设备
-(void)sendWithBleData
{
    if ([datas_ count]<1) {
        return;
    }
    isFree_=NO;
    NSDictionary *dataDic = (NSDictionary *)[datas_ lastObject];
    NSData *sendData = dataDic[@"data"];
    state_ = [dataDic[@"state"] intValue];
    if (bleClient_.periperal) {
        if (bleClient_.periperal.state ==CBPeripheralStateConnected) {
            //外设存在且连接状态
            DLog(@"1");
            [bleClient_ sendData:sendData withFailure:^(id reason) {
                [self setFailureBlockWithReason:reason];
            }];
        }else
        {
            //外设存在且断开状态
            DLog(@"2");
            [bleClient_ connectWithPeriperal:bleClient_.periperal success:^(id result) {
                [bleClient_ sendData:sendData withFailure:^(id reason) {
                    [self setFailureBlockWithReason:reason];
                }];
                
            } failure:^(id reason) {
                [self setFailureBlockWithReason:reason];
            }];
        }
    }else
    {
        //外设不存在
        DLog(@"3");
        [bleClient_ connectBleWithBindingDeviceType:Bracelet success:^(id result) {
            [bleClient_ sendData:sendData withFailure:^(id reason) {
                [self setFailureBlockWithReason:reason];
            }];
        } failure:^(id reason) {
            [self setFailureBlockWithReason:reason];
        }];
    }
    sendTimeOut_ = [NSTimer scheduledTimerWithTimeInterval:SEND_INTERVAL target:self selector:@selector(sendCommandTimeOut) userInfo:nil repeats:NO];

}


#pragma mark 发送指令超时
-(void)sendCommandTimeOut
{
    [self setFailureBlockWithReason:@"发送命令超时"];
}

#pragma mark 停止发送指令超时定时器
-(void)stopSendTimeOut
{
    if (sendTimeOut_) {
        [sendTimeOut_ invalidate];
        sendTimeOut_=nil;
    }
    isFree_=YES;
    state_ = BleFunctionStateFree;
    [datas_ removeLastObject];
    [self sendWithBleData];
}

#pragma mark 发送失败设置block
-(void)setFailureBlockWithReason:(id)reason
{
    switch (state_) {
        case BleFunctionStateSync:
            //同步失败
            [self stopSendTimeOut];
            syncFailureBlock_(reason);
            break;
        case BleFunctionStateStep:
            //同步计步失败
            [self stopSendTimeOut];
            stepFailureBlock_(reason);
            break;
        case BleFunctionStateSleep:
            //同步睡眠失败
            [self stopSendTimeOut];
            sleepFailureBlock_(reason);
            break;
        case BleFunctionStateSelectBinding:
            //查询绑定失败
            [self stopSendTimeOut];
            selectBindingFailureBlock_(reason);
            break;
        case BleFunctionStateEntryBinding:
            //申请绑定失败
            [self stopSendTimeOut];
            entryBindingFailureBlock_(reason);
            break;
        case BleFunctionStateVerifyBinding:
            //确认绑定失败
            [self stopSendTimeOut];
            verifyBindingFailureBlock_(reason);
            break;
        case BleFunctionStateRemoveBinding:
            //解除绑定失败
            [self stopSendTimeOut];
            removeBindingFailureBlock_(reason);
            break;
         case BleFunctionStateFindDevice:
            //查找设备失败
            [self stopSendTimeOut];
            findDeviceFailureBlock_(reason);
            break;
        case BleFunctionStateLost:
            //防丢失败
            [self stopSendTimeOut];
            lostFailureBlock_(reason);
            break;
        case BleFunctionStateKeyLock:
            //按键锁定失败
            [self stopSendTimeOut];
            KeyLockFailureBlock_(reason);
            break;
        case BleFunctionStateLight:
            //灯色切换失败
            [self stopSendTimeOut];
            lightFailureBlock_(reason);
            break;
        case BleFunctionStateSelectFirmware:
            //查询固件失败
            [self stopSendTimeOut];
            selectFirmwareFailureBlock_(reason);
            break;
        case BleFunctionStateWarn:
            //提醒失败
            [self stopSendTimeOut];
            warnFailureBlock_(reason);
            break;
        case BleFunctionStateCallWarn:
            //电话来电提醒失败
            [self stopSendTimeOut];
            callWarnFailureBlock_(reason);
            break;
        case BleFunctionStateSMSWarn:
            //短信提醒失败
            [self stopSendTimeOut];
            sMSWarnFailureBlock_(reason);
            break;
        case BleFunctionStateElectricity:
            //查询电量失败
            [self stopSendTimeOut];
            electricityFailureBlock_(reason);
            break;
        case BleFunctionStateDialogOtaUpgrade:
            //查询电量失败
            [self stopSendTimeOut];
            dialogOtaUpgradeFailureBlock_(reason);
            break;

        default:
            break;
    }
}

#pragma mark 发送成功设置blcok
-(void)setSuccessBlockWithResult:(id)result
{
    switch (state_) {
        case BleFunctionStateSync:
            [self stopSendTimeOut];
            syncSuccessBlock_(result);
            break;
        case BleFunctionStateStep:
            [self stopSendTimeOut];
            stepSuccessBlock_(result);
            break;
        case BleFunctionStateSleep:
            [self stopSendTimeOut];
            sleepSuccessBlock_(result);
            break;
         case BleFunctionStateSelectBinding:
            [self stopSendTimeOut];
            selectBindingSuccessBlock_(result);
            break;
        case BleFunctionStateEntryBinding:
            [self stopSendTimeOut];
            entryBindingSuccessBlock_(result);
            break;
        case BleFunctionStateVerifyBinding:
            [self stopSendTimeOut];
            verifyBindingSuccessBlock_(result);
            break;
        case BleFunctionStateRemoveBinding:
            [self stopSendTimeOut];
            removeBindingSuccessBlock_(result);
            break;
        case BleFunctionStateFindDevice:
            [self stopSendTimeOut];
            findDeviceSuccessBlock_(result);
            break;
        case BleFunctionStateLost:
            [self stopSendTimeOut];
            lostSuccessBlock_(result);
            break;
        case BleFunctionStateKeyLock:
            [self stopSendTimeOut];
            keyLockSuccessBlock_(result);
            break;
        case BleFunctionStateLight:
            [self stopSendTimeOut];
            lightSuccessBlock_(result);
            break;
        case BleFunctionStateSelectFirmware:
            [self stopSendTimeOut];
            selectFirmwareSuccessBlock_(result);
            break;
        case BleFunctionStateWarn:
            [self stopSendTimeOut];
            warnSuccessBlock_(result);
            break;
        case BleFunctionStateCallWarn:
            [self stopSendTimeOut];
            callWarnSuccessBlock_(result);
            break;
        case BleFunctionStateSMSWarn:
            [self stopSendTimeOut];
            sMSWarnSuccessBlock_(result);
            break;
        case BleFunctionStateElectricity:
             [self stopSendTimeOut];
            electricitySuccessBlock_(result);
            break;
        default:
            break;
    }
}

#pragma mark 设置空闲状态(升级完成,升级失败)
-(void)setBleFunctionStateFree
{
    state_ = BleFunctionStateFree;
    isFree_ = YES;
}

#pragma mark --------------------------蓝牙功能模块----------------------------------
#pragma mark 同步参数到绑定的设备上(时间、身高、体重等等)

-(void)syncWithSuccess:(CoreSuccess)success withBinding:(BOOL)isBinding withFailure:(CoreFailure)failure
{
    syncSuccessBlock_ = [success copy];
    syncFailureBlock_ = [failure copy];
    Byte byteData[20] ={0};
    byteData[0]=0x5a;
    byteData[1]=0x01;
    byteData[3]=([NSDate getCurrentYear]-2000);
    byteData[4]=[NSDate getCurrentMonth];
    byteData[5]=[NSDate getCurrentDay];
    byteData[6]=[NSDate getCurrentHour];
    byteData[7]=[NSDate getCurrentMin];
    byteData[8]=[NSDate getCurrentSecond];
    byteData[9]=([MNMovementService shareInstance].goalStep/100)/256;
    byteData[10]=([MNMovementService shareInstance].goalStep/100)%256;
    byteData[11]=1;
    byteData[12]=1;
    if (isBinding) {
        byteData[13]=0x78;
    }
    byteData[16]= (int)[NSDate getCurrentAgeFromBirthdayDate:[NSDate getDateWithFormat:@"yyyyMMdd" andString:[MNUserModel shareInstance].birthday]];
    if ([[MNUserModel shareInstance].sex isEqual:@(0)]) {
        byteData[16]+=128;
    }
    byteData[17]=[[MNUserModel shareInstance].weight intValue]/1000;
    byteData[18]=[[MNUserModel shareInstance].height intValue];
    byteData[19]=128;
    if (IS_BRITISH_SYSTEM) {
        byteData[19]=64;
    }
    NSData *data = [NSData dataWithBytes:byteData length:20];
    [self updateData:data functionState:BleFunctionStateSync];
}

#pragma mark 同步计步数据
-(void)syncStepWithSuccess:(CoreSuccess)success withFailure:(CoreFailure)failure
{
    stepSuccessBlock_ = [success copy];
    stepFailureBlock_ = [failure copy];
    NSDate *startDate = [MNMovementService shareInstance].stepLastSyncTime;
    Byte byteData[20] ={0};
    byteData[0] = 0x5a;
    byteData[1] = 0x03;
    if (startDate) {
        NSDate *endDate =[NSDate date];
        byteData[3] = ([startDate getYear]-2000);
        byteData[4] = [startDate getMon];
        byteData[5] = [startDate getDay];
        
        byteData[6] = ([endDate getYear]-2000);
        byteData[7] = [endDate getMon];
        byteData[8] = [endDate getDay];
        
    }
    NSArray *deviceNumber = [[MNFirmwareModel sharestance].number componentsSeparatedByString:@"-"];
    byteData[9] = [deviceNumber[0] intValue];
    byteData[10] = [deviceNumber[1] intValue];
    byteData[11] = [deviceNumber[2] intValue];
    byteData[12] = [deviceNumber[3] intValue];
    byteData[13] = [deviceNumber[4] intValue];
    byteData[14] = [deviceNumber[5] intValue];
    byteData[15] = [deviceNumber[6] intValue];
    byteData[16] = [deviceNumber[7] intValue];
    NSData *sendData = [NSData dataWithBytes:byteData length:20];
    [self updateData:sendData functionState:BleFunctionStateStep];
}

#pragma mark 同步睡眠数据
-(void)syncSleepWithSuccess:(CoreSuccess)success withFailure:(CoreFailure)failure
{
    sleepSuccessBlock_ = [success copy];
    sleepFailureBlock_ = [failure copy];
    NSDate *startDate = [MNSleepService shareInstance].sleepLastSyncTime;
    Byte byteData[20]={0};
    byteData[0] = 0x5a;
    byteData[1] = 0x07;
    if (startDate) {
        NSDate *endDate = [NSDate date];
        byteData[3] = [startDate getYear];
        byteData[4] = [startDate getMon];
        byteData[5] = [startDate getDay];
        
        byteData[6] = [endDate getYear];
        byteData[7] = [endDate getMon];
        byteData[8] = [endDate getDay];
    }
    NSArray *deviceNumber = [[MNFirmwareModel sharestance].number componentsSeparatedByString:@"-"];
    byteData[9] = [deviceNumber[0] intValue];
    byteData[10] = [deviceNumber[1] intValue];
    byteData[11] = [deviceNumber[2] intValue];
    byteData[12] = [deviceNumber[3] intValue];
    byteData[13] = [deviceNumber[4] intValue];
    byteData[14] = [deviceNumber[5] intValue];
    byteData[15] = [deviceNumber[6] intValue];
    byteData[16] = [deviceNumber[7] intValue];
    NSData *sendData = [NSData dataWithBytes:byteData length:20];
    [self updateData:sendData functionState:BleFunctionStateSleep];
}

#pragma mark 查询设备绑定情况
-(void)selectBindingWithSuccess:(CoreSuccess)success withFailure:(CoreFailure)failure
{
    selectBindingSuccessBlock_ = [success copy];
    selectBindingFailureBlock_ = [failure copy];
    Byte byteData[4] = {0};
    byteData[0] = 0x5a;
    byteData[1] = 0x0b;
    NSData *sendData = [NSData dataWithBytes:byteData length:4];
    [self updateData:sendData functionState:BleFunctionStateSelectBinding];
}

#pragma mark 申请绑定
-(void)entryBindingWithSuccess:(CoreSuccess)success withFailure:(CoreFailure)failure
{
    entryBindingSuccessBlock_ = [success copy];
    entryBindingFailureBlock_ = [failure copy];
    Byte byteData[4] = {0};
    byteData[0] = 0x5a;
    byteData[1] = 0x0b;
    byteData[3] = 0x01;
    NSData *sendData = [NSData dataWithBytes:byteData length:4];
    [self updateData:sendData functionState:BleFunctionStateEntryBinding];
    
}

#pragma mark 确认绑定
-(void)verifyBindingWithSuccess:(CoreSuccess)success withFailure:(CoreFailure)failure
{
    verifyBindingSuccessBlock_ = [success copy];
    verifyBindingFailureBlock_ = [failure copy];
    Byte byteData[5] ={0};
    byteData[0] = 0x5b;
    byteData[1] = 0x0b;
    byteData[3] =0x02;
    NSData *sendData = [NSData dataWithBytes:byteData length:5];
    [self updateData:sendData functionState:BleFunctionStateVerifyBinding];
}

#pragma mark 解除绑定
-(void)removeBindingWithSuccess:(CoreSuccess)success withFailure:(CoreFailure)failure
{
    removeBindingSuccessBlock_ = [success copy];
    removeBindingFailureBlock_ = [failure copy];
    Byte byteData[4] ={0};
    byteData[0] = 0x5a;
    byteData[1] = 0x0b;
    byteData[3] =0x03;
    NSData *sendData = [NSData dataWithBytes:byteData length:4];
    [self updateData:sendData functionState:BleFunctionStateRemoveBinding];
}

#pragma mark查找设备
-(void)findDeviceWithSuccess:(CoreSuccess)success withFailure:(CoreFailure)failure
{
    findDeviceSuccessBlock_ = [success copy];
    findDeviceFailureBlock_ = [failure copy];
    Byte byteData[4] ={0};
    byteData[0] = 0x5a;
    byteData[1] = 0x0c;
    byteData[3] =0x06;
    NSData *sendData = [NSData dataWithBytes:byteData length:4];
    [self updateData:sendData functionState:BleFunctionStateFindDevice];
}

#pragma mark 防丢
-(void)lostWithOpen:(BOOL)isOpen withSuccess:(CoreSuccess)success withFailure:(CoreFailure)failure
{
    lostSuccessBlock_ = [success copy];
    lostFailureBlock_ = [failure copy];
    Byte byteData[7] = {0};
    byteData[0] = 0x5a;
    byteData[1] = 0x0c;
    byteData[3] = 0x03;
    if (isOpen) {
        byteData[4]=0x01;
        byteData[5]=LOST_DURATION/256;
        byteData[6]=LOST_DURATION%256;
    }
    NSData *sendData = [NSData dataWithBytes:byteData length:7];
    [self updateData:sendData functionState:BleFunctionStateFindDevice];
}

#pragma mark 按键锁定
-(void)keyLockWithLock:(BOOL)isLock withSuccess:(CoreSuccess)success withFailure:(CoreFailure)failure
{
    keyLockSuccessBlock_ = [success copy];
    KeyLockFailureBlock_ = [failure copy];
    Byte byteData[7] = {0};
    byteData[0] = 0x5a;
    byteData[1] = 0x0c;
    byteData[3] = 0x04;
    if (isLock) {
        byteData[4]=0x01;
        byteData[5]=LOCK_DURATION/256;
        byteData[6]=LOCK_DURATION%256;
    }
    NSData *sendData = [NSData dataWithBytes:byteData length:7];
    [self updateData:sendData functionState:BleFunctionStateKeyLock];
}

#pragma mark 灯色切换
-(void)lightWithLightColorType:(LightColorType)corlor withSuccess:(CoreSuccess)success withFailure:(CoreFailure)failure
{
    lightSuccessBlock_ = [success copy];
    lightFailureBlock_ = [failure copy];
    Byte byteData[5] = {0};
    byteData[0] =0x5a;
    byteData[1]=0x0c;
    byteData[3]=0x05;
    byteData[4]=corlor;
    NSData *sendData = [NSData dataWithBytes:byteData length:5];
   [self updateData:sendData functionState:BleFunctionStateLight];
}

#pragma mark 查询固件
-(void)selectFirmwareWithSuccess:(CoreSuccess)success withFailure:(CoreFailure)failure
{
    selectFirmwareSuccessBlock_  = [success copy];
    selectFirmwareFailureBlock_  = [failure copy];
    Byte byteData[3] = {0};
    byteData[0] = 0x5A;
    byteData[1] = 0x10;
    NSData *sendData = [NSData dataWithBytes:byteData length:3];
    [self updateData:sendData functionState:BleFunctionStateSelectFirmware];
}

#pragma mark 提醒
-(void)warnWithData:(NSData *)data withSuccess:(CoreSuccess)success withFailure:(CoreFailure)failure
{
    warnSuccessBlock_ = [success copy];
    warnFailureBlock_ = [failure copy];
    [self updateData:data functionState:BleFunctionStateWarn];
}

#pragma mark 来电提醒
-(void)callWarnWithOpen:(BOOL)isOpen withSuccess:(CoreSuccess)success withFailure:(CoreFailure)failure
{
    callWarnSuccessBlock_ = [success copy];
    callWarnFailureBlock_ = [failure copy];
    Byte byteData[5]= {0};
    byteData[0]= 0x5a;
    byteData[1]= 0x0c;
    byteData[3]=0x07;
    if (isOpen) {
        byteData[4]=0x01;
    }
    NSData *sendData = [NSData dataWithBytes:byteData length:5];
    [self updateData:sendData functionState:BleFunctionStateCallWarn];

}

#pragma mark 查询电量
-(void)electricityWithSuccess:(CoreSuccess)success withFailure:(CoreFailure)failure
{
    electricitySuccessBlock_ = [success copy];
    electricityFailureBlock_ = [failure copy];
    Byte byteData[4]={0};
    byteData[0]= 0x5a;
    byteData[1]=0x0d;
    byteData[3]=0x80;
    NSData *sendData = [NSData dataWithBytes:byteData length:4];
    [self updateData:sendData functionState:BleFunctionStateElectricity];
}

#pragma mark dialogOTA升级
-(void)dialogOtaUpgradeWithSuccess:(CoreSuccess)success withFailure:(CoreFailure)failure;
{
    dialogOtaUpgradeSuccessBlock_ = [success copy];
    dialogOtaUpgradeFailureBlock_ =[failure copy];
    Byte byteData[3]={0};
    byteData[0]= 0x5a;
    byteData[1]=0x11;
    NSData *sendData = [NSData dataWithBytes:byteData length:3];
    [self updateData:sendData functionState:BleFunctionStateDialogOtaUpgrade];
}

#pragma mark  quintic升级
-(void)quinticUpgrade
{
    state_ = BleFunctionStateNewUpgrade;
}

#pragma mark --------------------------bleUpdateForOtaDelegate----------------------------------

#pragma mark 接收数据
-(void)bleDidUpdateValueForChar:(CBCharacteristic *)characteristic error : (NSError *)error
{
    if (!error) {
        NSData *data = characteristic.value;
        DLog(@"Rev:%@  Length:%lu",data,(unsigned long)data.length);
        const uint8_t *reportData = [data bytes];
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:SPOTA_SERV_STATUS_UUID]] || [characteristic.UUID isEqual:[CBUUID UUIDWithString:SPOTA_MEM_INFO_UUID]]) {
            //dialogOTA升级
            if (state_ == BleFunctionStateDialogOtaUpgrade) {
                if (_dialogOtaUpgradeDelegate && [_dialogOtaUpgradeDelegate respondsToSelector:@selector(receviceUpdateValueForCharacteristic:error:)]) {
                    [_dialogOtaUpgradeDelegate receviceUpdateValueForCharacteristic:characteristic error:error];
                }
            }
            
        }else
        {
            if (reportData[0] == 0x5b && reportData[1] == 0x01 && state_ == BleFunctionStateSync) {
                //同步参数处理
                [self receiveSyncData:data];
            }else if (reportData[0]==0x5b && reportData[1]==0x03 && state_ == BleFunctionStateStep)
            {
                //同步计步参数处理
                [self receiveStepData:data];
                
            }else if (reportData[0]==0x5b && reportData[1]==0x07 && state_ == BleFunctionStateSleep)
            {
                //同步睡眠参数处理
                [self receiveSleepData:data];
                
            }else if (reportData[0]==0x5b && reportData[1]==0x0b && reportData[3]==0 && state_ ==BleFunctionStateSelectBinding)
            {
                //查询固件绑定情况
                [self receiveSelectBindingData:data];
            }else if (reportData[0]==0x5b && reportData[1]==0x0b && reportData[3]==1 && state_ ==BleFunctionStateEntryBinding)
            {
                //申请绑定
                [self receiveEntryBindingData:data];
            }else if(reportData[0]==0x5a && reportData[1]==0x0b && reportData[3]==2)
            {
                //设备发送绑定
                if (_bindingMessageDelegate && [_bindingMessageDelegate respondsToSelector:@selector(receviceBindingMessage)]) {
                    [_bindingMessageDelegate receviceBindingMessage];
                }
                
            }else if (reportData[0]==0x5b && reportData[1]==0x0c && reportData[3]==3 && state_ == BleFunctionStateLost)
            {
                //防丢
                [self receiveLostData:data];
            }else if (reportData[0]==0x5b && reportData[1]==0x0c && reportData[3]==4 && state_ == BleFunctionStateKeyLock)
            {
                //设备按键加锁或者解锁
                [self receiveKeyLockData:data];
            }else if (reportData[0]==0x5b && reportData[1]==0x0c && reportData[3]==5 && state_ == BleFunctionStateLight)
            {
                //灯色切换
                [self receiveLightData:data];
            }else if (reportData[0]==0x5b && reportData[1]==0x10 && state_==BleFunctionStateSelectFirmware)
            {
                //查询固件
                [self receiveSelectFirmwareData:data];
            }else if (reportData[0]==0x5b && reportData[1]==0x14 && state_==BleFunctionStateWarn)
            {
                //提醒设置
                [self receiveWarnData:data];
            }else if(state_ ==BleFunctionStateNewUpgrade)
            {
                if (_quinticUpgradeDelegate && [_quinticUpgradeDelegate respondsToSelector:@selector(receviceQuinticUpdateValueForCharacteristic:error:)]) {
                    [_quinticUpgradeDelegate receviceQuinticUpdateValueForCharacteristic:characteristic error:error];
                }
            }
            else if (reportData[0]==0x5b && reportData[1]==0x0D && reportData[3]==0x80)
            {
                //查询电量
                [self receiveElectricityData:data];
            }else if (reportData[0]==0x5a && reportData[1]==0x0D && reportData[3]==0x01)
            {
                //临时步数
                if (_tempStepsDelegate && [_tempStepsDelegate respondsToSelector:@selector(receviceTempSteps:)]) {
                    [_tempStepsDelegate receviceTempSteps:(reportData[4]*256*256*256+reportData[5]*256*256+reportData[6]*256+reportData[7])];
                }
            }else if (reportData[0]==0x5a && reportData[1]==0x16 && reportData[3]==0x01)
            {
                //照相
                if (_photoMessageDelegate && [_photoMessageDelegate respondsToSelector:@selector(recevicePhotoMessage)]) {
                    [_photoMessageDelegate recevicePhotoMessage];
                }
            }else if (reportData[0]==0x5a && reportData[1]==0x05)
            {
                switch (state_) {
                    case BleFunctionStateStep:
                        //计步数据
                        if (_stepDataDelegate && [_stepDataDelegate respondsToSelector:@selector(receviceStepData:)]) {
                            [_stepDataDelegate receviceStepData:data];
                        }
                        break;
                    case BleFunctionStateSleep:
                        //睡眠数据
                        if (_sleepDataDelegate && [_sleepDataDelegate respondsToSelector:@selector(receviceSleepData:)]) {
                            [_sleepDataDelegate receviceSleepData:data];
                        }
                        break;
                        
                    default:
                        break;
                }
            }
        }

        }
}

#pragma mark 数据发送到设备端成功代理
-(void)bledidWriteValueForChar:(CBCharacteristic *)characteristic error : (NSError *)error
{
    switch (state_) {
        case BleFunctionStateVerifyBinding:
            [self setSuccessBlockWithResult:(@"确认绑定")];
            break;
        case BleFunctionStateRemoveBinding:
            [self setSuccessBlockWithResult:@"解绑成功"];
            break;
        case BleFunctionStateFindDevice:
            [self setSuccessBlockWithResult:(@"查找设备成功")];
            break;
        case BleFunctionStateCallWarn:
            [self setSuccessBlockWithResult:@"来电提醒成功"];
            break;
        case BleFunctionStateDialogOtaUpgrade:
        {
            if ([characteristic isEqual:bleClient_.writeChar]) {
                if (sendTimeOut_) {
                    [sendTimeOut_ invalidate];
                    sendTimeOut_=nil;
                }
                dialogOtaUpgradeSuccessBlock_(@"设置dialogOTA成功");
            }else
            {
                if (_dialogOtaUpgradeDelegate && [_dialogOtaUpgradeDelegate respondsToSelector:@selector(receviceWriteValueForCharacteristic:error:)]) {
                    [_dialogOtaUpgradeDelegate receviceWriteValueForCharacteristic:characteristic error:error];
                }
            }
            
        }
            break;
        default:
            break;
    }
}
#pragma mark --------------------------接收数据处理----------------------------------


#pragma mark 同步数据处理
-(void)receiveSyncData:(NSData *)data
{
    const uint8_t *reportData = [data bytes];
    NSMutableString *tempIMEI=[NSMutableString string];
    NSMutableString *typeStr=[NSMutableString string];
    for (int i=0; i<8;i++) {
        if (i==7) {
            [tempIMEI appendFormat:@"%02x",reportData[i+3]];
        }else{
            [tempIMEI appendFormat:@"%02x-",reportData[i+3]];
        }
    }
    MNFirmwareModel *model = [MNFirmwareModel sharestance];
    model.number = (NSString *)tempIMEI;
    for(int i=0;i<5;i++)
    {
        if(reportData[15+i]!=0)
        {
            [typeStr appendFormat:@"%c",reportData[15+i]];
        }
    }
    model.type = (NSString *)typeStr;
    model.firmwareVersion = [NSNumber numberWithInt:(int)(reportData[13]*256+reportData[14])];
    [self setSuccessBlockWithResult:@{@"error":@"0",@"message":@"同步参数成功"}];
    
}

#pragma mark 同步计步数据处理
-(void)receiveStepData:(NSData *)data
{
    const uint8_t *reportData = [data bytes];
    if (reportData[3]*256+reportData[4]==0) {
        [self setSuccessBlockWithResult:@{@"error":@"0",@"totalToday":@(reportData[3]*256+reportData[4])}];
    }else{
        if (sendTimeOut_) {
            [sendTimeOut_ invalidate];
            sendTimeOut_=nil;
        }
        stepSuccessBlock_(@{@"error":@"0",@"totalToday":@(reportData[3]*256+reportData[4])});
    }
}

#pragma mark 同步睡眠数据处理
-(void)receiveSleepData:(NSData *)data
{
    const uint8_t *reportData = [data bytes];
    if (reportData[3]*256+reportData[4]==0) {
        [self setSuccessBlockWithResult:@{@"error":@"0",@"totalToday":@(reportData[3]*256+reportData[4])}];
    }else
    {
        if (sendTimeOut_) {
            [sendTimeOut_ invalidate];
            sendTimeOut_=nil;
        }
        sleepSuccessBlock_(@{@"error":@"0",@"totalToday":@(reportData[3]*256+reportData[4])});
    }
    
}

#pragma mark 查询固件绑定数据处理
-(void)receiveSelectBindingData:(NSData *)data
{
    const uint8_t *reportData = [data bytes];
    if (reportData[4] ==0x02) {
        [self setSuccessBlockWithResult:@{@"error":@"1",@"message":@"设备已经绑定了App,不允许再绑定"}];
    }else
    {
        [self setSuccessBlockWithResult:@{@"error":@"0",@"message":@"设备可以进行绑定,允许绑定"}];
    }
}

#pragma mark 提醒数据处理
-(void)receiveWarnData:(NSData *)data
{
    const uint8_t *reportData = [data bytes];
    if (reportData[4] == 1) {
        NSString *message=@"";
        switch (reportData[3]) {
            case 1:
                message = @"喝水提醒设置成功";
                break;
            case 2:
                message = @"久坐提醒设置成功";
                break;
            case 3:
                message = @"闹钟提醒设置成功";
                break;
                
            default:
                break;
        }
        [self setSuccessBlockWithResult:@{@"error":@"0",@"message":message}];
        
    }else if (reportData[4] == 0)
    {
        NSString *message=@"";
        switch (reportData[3]) {
            case 1:
                message = @"喝水提醒设置失败";
                break;
            case 2:
                message = @"久坐提醒设置失败";
                break;
            case 3:
                message = @"闹钟提醒设置失败";
                break;
                
            default:
                break;
        }
        [self setSuccessBlockWithResult:@{@"error":@"1",@"message":message}];
    }
}

#pragma mark 申请绑定数据处理
-(void)receiveEntryBindingData:(NSData *)data
{
    const uint8_t *reportData = [data bytes];
    if (reportData[4]==0) {
        [self setSuccessBlockWithResult:@{@"error":@"0",@"message":@"允许绑定",@"duration":@(reportData[5])}];
    }else
    {
        [self setSuccessBlockWithResult:@{@"error":@"1",@"message":@"设备不允许绑定"}];
    }
    
}

#pragma mark 防丢数据处理
-(void)receiveLostData:(NSData*)data
{
    const uint8_t *reportData = [data bytes];
    if (reportData[4]==0) {
        [self setSuccessBlockWithResult:@{@"error":@"0",@"message":@"停止提醒"}];
    }else if (reportData[4]==1)
    {
        [self setSuccessBlockWithResult:@{@"error":@"0",@"message":@"开启提醒"}];
    }else
    {
        [self setSuccessBlockWithResult:@{@"error":@"1",@"message":@"提醒功能失效"}];
    }
}

#pragma mark 按键数据处理(拍照)
-(void)receiveKeyLockData:(NSData *)data
{
    const uint8_t *reportData = [data bytes];
    if (reportData[4]==0) {
        [self setSuccessBlockWithResult:@{@"error":@"0",@"message":@"按键锁定模式(开启拍照模式)"}];
    }else if (reportData[4]==1)
    {
        [self setSuccessBlockWithResult:@{@"error":@"0",@"message":@"按键解锁模式(关闭拍照模式)"}];
    }else
    {
        [self setSuccessBlockWithResult:@{@"error":@"1",@"message":@"按键锁定或者解锁模式失效"}];
    }
}

#pragma mark 灯色数据处理
-(void)receiveLightData:(NSData *)data
{
    const uint8_t *reportData = [data bytes];
    if (reportData[4]==0) {
        [self setSuccessBlockWithResult:@{@"error":@"0",@"message":@"灯色切换成功"}];
    }else
    {
        [self setSuccessBlockWithResult:@{@"error":@"1",@"message":@"灯色切换失败"}];
    }
}

#pragma mark 查询固件数据处理
-(void)receiveSelectFirmwareData:(NSData *)data
{
    const uint8_t *reportData = [data bytes];
    [MNFirmwareModel sharestance].firmwareVersion = @(reportData[3]*256+reportData[4]);
    NSMutableString *tempIMEI=[NSMutableString string];
    NSMutableString *typeStr=[NSMutableString string];
    for (int i=0; i<8;i++) {
        if (i==7) {
            [tempIMEI appendFormat:@"%02x",reportData[i+5]];
        }else{
            [tempIMEI appendFormat:@"%02x-",reportData[i+5]];
        }
    }
    [MNFirmwareModel sharestance].number = (NSString *)tempIMEI;
    for(int i=0;i<5;i++)
    {
        if(reportData[15+i]!=0)
        {
            [typeStr appendFormat:@"%c",reportData[15+i]];
        }
    }
    [MNFirmwareModel sharestance].type = (NSString *)typeStr;
    [self setSuccessBlockWithResult:@{@"error":@"0",@"message":@"查询固件信息成功"}];
}



#pragma mark 查询电量数据处理
-(void)receiveElectricityData:(NSData *)data
{
    const uint8_t *reportData = [data bytes];
    int electricity = reportData[4];
    [self setSuccessBlockWithResult:@{@"error":@"0",@"message":@"电量查询成功",@"electricity":@(electricity)}];
}

@end
