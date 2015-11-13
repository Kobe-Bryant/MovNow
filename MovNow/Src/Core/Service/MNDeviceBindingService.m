//
//  MNDeviceBindingService.m
//  Movnow
//
//  Created by LiuX on 15/4/17.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//

#import "MNDeviceBindingService.h"
#import "QBleClient.h"
#import "MNBleBaseService.h"
#import "MNFirmwareModel.h"
#import "MNMovementService.h"
#import "MNSleepService.h"
#import "MNSyncTimeData.h"
typedef void (^BindingFailure)(NSString *failure);
typedef void (^BindingSuccess)(void);

@interface MNDeviceBindingService ()<MNBleBaseServiceBindingMessageDelegate>

/**
 *  plist字典对象
 */
@property (nonatomic,strong) NSMutableDictionary *sourceDict;
@property (nonatomic,strong) NSDictionary *upgradeWayDict;
/**
 *  当前绑定设备的所有功能数组
 */
@property (nonatomic,strong) NSMutableArray *deviceFunctionArr;

@end

@implementation MNDeviceBindingService
{
    NSTimer *bindingWaitTime_;
    BindingFailure bindingFailureBlock_;
    BindingSuccess bindingSuccessBlock_;
}

- (BOOL)hadBindingDevice
{
    return ([[MNFirmwareModel sharestance].uuid isEqualToString:@""] || [MNFirmwareModel sharestance].uuid == nil)?NO:YES;
}

- (id)init
{
    self = [super init];
    if (self) {
        
        _sourceDict = [NSMutableDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Device" ofType:@"plist"]];
        
        _upgradeWayDict  = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"UpgradeWay" ofType:@"plist"]];
        _deviceFunctionArr = [NSMutableArray array];
        
    }
    return self;
}

+ (MNDeviceBindingService *)shareInstance
{
    static dispatch_once_t onceToken;
    static MNDeviceBindingService *_mnDevice = nil;
    dispatch_once(&onceToken, ^{
        _mnDevice = [[self alloc]init];
    });
    return _mnDevice;
}

+(int)readLocalBLEVersionData:(Byte [])data
{
    NSString *cachepath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *filename=[NSString string];
    if ([MNDeviceBindingService shareInstance].upgradeType == UpgradeTypeDialogOta) {
        filename=[cachepath stringByAppendingPathComponent:@"firmware.img"];
    }else
    {
        filename=[cachepath stringByAppendingPathComponent:@"firmware.bin"];
    }
    NSData *reader = [NSData dataWithContentsOfFile:filename];
    
    if (reader == nil || [reader length] == 0) {
        return 0;
    }
    NSUInteger len = [reader length];
    if (len > 59990) {
        NSLog(@"ble fill lenght");
        return 0;
    }
    //data = (Byte*)malloc(len);
    memcpy(data, [reader bytes], len);
    return (int)len;
}

#pragma mark 停止绑定等待的定时器
-(void)stopBindingWaitTimeOut
{
    if (bindingWaitTime_) {
        [bindingWaitTime_ invalidate];
        bindingWaitTime_=nil;
    }
}

#pragma mark 等待绑定超时
-(void)bindingWaitTimeOut
{
    [[qBleClient sharedInstance] clearPeriperal];
    bindingFailureBlock_(@"绑定超时");
}

#pragma mark绑定设备
- (void)startBindingDeviceWithSuccess:(void(^)(void))success withFailure:(void(^)(NSString *messgae))failure withWaitUserOperation:(void(^)(void))operation
{
    bindingFailureBlock_ = [failure copy];
    bindingSuccessBlock_ = [success copy];
    qBleClient *bleClient = [qBleClient sharedInstance];
    [bleClient connectBleWithNoBindingDeviceType:Bracelet success:^(id result) {
        MNBleBaseService *bleBaseService=[MNBleBaseService shareInstance];
        bleBaseService.bindingMessageDelegate=self;
        [bleBaseService syncWithSuccess:^(id result) {
            DLog(@"-----type=%@",[MNFirmwareModel sharestance].type);
            if (self.currentDeviceType == MNDeviceTypeUnknown) {
                [bleClient cancelBinding];
                failure(NSLocalizedString(@"movnow不支持的设备",nil));
                [bleClient clearPeriperal];
            }else{
                if ([[self getDeviceFunctionWithDeviceType:self.currentDeviceType] containsObject:@"BOUND"]) {
                    [bleBaseService entryBindingWithSuccess:^(id result) {
                        if ([result[@"error" ] isEqualToString:@"0"]) {
                            operation();
                            bindingWaitTime_ = [NSTimer scheduledTimerWithTimeInterval:[result[@"duration"] intValue] target:self selector:@selector(bindingWaitTimeOut) userInfo:nil repeats:NO];
                        }else
                        {
                            [bleClient cancelBinding];
                            failure(NSLocalizedString(result[@"message"],nil));
                            [bleClient clearPeriperal];
                        }
                        
                    } withFailure:^(id reason) {
                        [bleClient cancelBinding];
                        failure(reason);
                        [bleClient clearPeriperal];
                    }];
                }else
                {  [bleClient cancelBinding];
                    success();
                    [[MNMovementService shareInstance] downLastMonthMovementDateWithSuccess:^(id result) {
                        DLog(@"step......result=%@",result);
                        [[MNSleepService shareInstance] downLastMonthSleepDateWithSuccess:^(id result) {
                             DLog(@"sleep......result=%@",result);
                        }];
                    }];
                }
            }
        } withBinding:YES withFailure:^(id reason) {
            [bleClient cancelBinding];
            failure((NSString *)reason);
            [bleClient clearPeriperal];
        }];
        
    } failure:^(id reason) {
        [bleClient cancelBinding];
        failure((NSString *)reason);
        [bleClient clearPeriperal];
    }];
}

#pragma mark 解绑设备
- (void)unbindWithSuccess:(void(^)(void))success withFailure:(void(^)(NSString *messgae))failure
{
    if ([[self getDeviceFunctionWithDeviceType:self.currentDeviceType] containsObject:@"BOUND"] && [[MNFirmwareModel sharestance].type isEqualToString:@"W077A"]) {
        //支持绑定
        [[MNBleBaseService shareInstance] removeBindingWithSuccess:^(id result) {
            [[MNMovementService shareInstance] unBindingSyncTime];
            DLog(@"result=%@",result);
            [[qBleClient sharedInstance] clearPeriperal];
            
            success();
        } withFailure:^(id reason) {
            failure(reason);
        }];
    }else
    {
        //不支持绑定
        [[MNMovementService shareInstance] unBindingSyncTime];
        [[qBleClient sharedInstance] clearPeriperal];
         success();
    }
}

#pragma mark 获取升级方式
-(UpgradeType)upgradeType
{
    UpgradeType type = UpgradeTypeNo;
    NSString *firmwareType = [MNFirmwareModel sharestance].type;
    if ([_upgradeWayDict[firmwareType] isEqualToString:@"UpgradeTypeOld"]) {
        type = UpgradeTypeOld;
    }else if ([_upgradeWayDict[firmwareType] isEqualToString:@"UpgradeTypeNew"])
    {
        type =UpgradeTypeNew;
    }else if ([_upgradeWayDict[firmwareType] isEqualToString:@"UpgradeTypeLibOta"])
    {
        type =UpgradeTypeLibOta;
    }else if ([_upgradeWayDict[firmwareType] isEqualToString:@"UpgradeTypeDialogOta"])
    {
        type =UpgradeTypeDialogOta;
    }
    
    return type;
}

#pragma mark获取设备类型
- (MNDeviceType)currentDeviceType
{
    int type =MNDeviceTypeUnknown;
    if ([[MNFirmwareModel sharestance].type isEqualToString:@"W001A"]) {
        type = MNDeviceTypeW001A;
    }else if ([[MNFirmwareModel sharestance].type isEqualToString:@"W001B"])
    {
        type =MNDeviceTypeW001B;
    }
    else if ([[MNFirmwareModel sharestance].type isEqualToString:@"W001C"])
    {
        type =MNDeviceTypeW001C;
    }else if ([[MNFirmwareModel sharestance].type isEqualToString:@"W002A"])
    {
        type= MNDeviceTypeW002A;
    }else if ([[MNFirmwareModel sharestance].type isEqualToString:@"W002B"])
    {
        type= MNDeviceTypeW002B;
    }else if ([[MNFirmwareModel sharestance].type isEqualToString:@"W002C"])
    {
        type= MNDeviceTypeW002C;
    }else if ([[MNFirmwareModel sharestance].type isEqualToString:@"W002D"])
    {
        type= MNDeviceTypeW002D;
    }else if ([[MNFirmwareModel sharestance].type isEqualToString:@"W002E"])
    {
        type= MNDeviceTypeW002E;
    }else if ([[MNFirmwareModel sharestance].type isEqualToString:@"W002F"])
    {
        type= MNDeviceTypeW002F;
    }else if ([[MNFirmwareModel sharestance].type isEqualToString:@"W002G"])
    {
        type= MNDeviceTypeW002G;
    }else if ([[MNFirmwareModel sharestance].type isEqualToString:@"W079A"])
    {
        type= MNDeviceTypeW079A;
    }else if ([[MNFirmwareModel sharestance].type isEqualToString:@"W007A"])
    {
        type= MNDeviceTypeW007A;
    }else if ([[MNFirmwareModel sharestance].type isEqualToString:@"W007C"])
    {
        type= MNDeviceTypeW007C;
    }else if ([[MNFirmwareModel sharestance].type isEqualToString:@"W032A"])
    {
        type= MNDeviceTypeW032A;
    }else if ([[MNFirmwareModel sharestance].type isEqualToString:@"W027B"])
    {
        type= MNDeviceTypeW027B;
    }else if ([[MNFirmwareModel sharestance].type isEqualToString:@"W077A"])
    {
        type= MNDeviceTypeW077A;
    }else if ([[MNFirmwareModel sharestance].type isEqualToString:@"W034C"])
    {
        type= MNDeviceTypeW034C;
    }else
    {
        type=MNDeviceTypeUnknown;
    }
    return type;
}

#pragma mark 获取设备功能数组
- (NSArray *)getDeviceFunctionWithDeviceType:(MNDeviceType)deviceType
{
    if (self.deviceFunctionArr.count > 0) {
        [self.deviceFunctionArr removeAllObjects];
    }
    
    switch (deviceType) {
        case MNDeviceTypeW001A:
        case MNDeviceTypeW001B:
        case MNDeviceTypeW001C:
        case MNDeviceTypeW002A:
        case MNDeviceTypeW002D:
            break;
        case MNDeviceTypeW002B:
        {
            [self.deviceFunctionArr addObjectsFromArray:self.sourceDict[@"W002B"]];
        }
            break;
        case MNDeviceTypeW002C:
        {
            [self.deviceFunctionArr addObjectsFromArray:self.sourceDict[@"W002C"]];
        }
            break;
        case MNDeviceTypeW002E:
        {
            [self.deviceFunctionArr addObjectsFromArray:self.sourceDict[@"W002E"]];
        }
            break;
        case MNDeviceTypeW002F:
        {
            [self.deviceFunctionArr addObjectsFromArray:self.sourceDict[@"W002F"]];
        }
            break;
        case MNDeviceTypeW002G:
        {
            [self.deviceFunctionArr addObjectsFromArray:self.sourceDict[@"W002G"]];
        }
            break;
        case MNDeviceTypeW079A:
        {
            [self.deviceFunctionArr addObjectsFromArray:self.sourceDict[@"W079A"]];
        }
            break;
        case MNDeviceTypeW007A:
        {
            [self.deviceFunctionArr addObjectsFromArray:self.sourceDict[@"W007A"]];
        }
            break;
        case MNDeviceTypeW007C:
        {
            [self.deviceFunctionArr addObjectsFromArray:self.sourceDict[@"W007C"]];
        }
            break;
        case MNDeviceTypeW032A:
        {
            [self.deviceFunctionArr addObjectsFromArray:self.sourceDict[@"W032A"]];
        }
            break;
        case MNDeviceTypeW027B:
        {
            [self.deviceFunctionArr addObjectsFromArray:self.sourceDict[@"W027A"]];
        }
            break;
        case MNDeviceTypeW077A:
        {
            [self.deviceFunctionArr addObjectsFromArray:self.sourceDict[@"W077A"]];
        }
            break;
        case MNDeviceTypeW034C:
        {
            [self.deviceFunctionArr addObjectsFromArray:self.sourceDict[@"W034C"]];
        }
            break;
        default:
            break;
    }
    
    return self.deviceFunctionArr;
}


#pragma mark--------------------------MNBleBaseServiceDelegate----------------------------------
-(void)receviceBindingMessage
{
    [self stopBindingWaitTimeOut];
    [[MNBleBaseService shareInstance] verifyBindingWithSuccess:^(id result) {
        [[qBleClient sharedInstance] cancelBinding];
        bindingSuccessBlock_();
        [[MNMovementService shareInstance] downLastMonthMovementDateWithSuccess:^(id result) {
            DLog(@"step......result=%@",result);
            [[MNSleepService shareInstance] downLastMonthSleepDateWithSuccess:^(id result) {
                DLog(@"sleep......result=%@",result);
            }];
        }];
    } withFailure:^(id reason) {
        bindingFailureBlock_(reason);
    }];
}

@end
