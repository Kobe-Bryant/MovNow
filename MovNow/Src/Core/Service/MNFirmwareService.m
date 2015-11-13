//
//  MNFirmwareService.m
//  Movnow
//
//  Created by baoyx on 15/5/4.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//

#import "MNFirmwareService.h"
#import "MNFirmwareModel.h"
#import "MNetManager.h"
#import "MNPutService.h"
#import "MNDeviceBindingService.h"
#import "OtaApi.h"
#import "MNBleBaseService.h"
#import "MNDialogOtaUpgradeService.h"
#import "MNQuinticUpgradeService.h"
typedef void (^UpgradePress)(int);
typedef void (^UpgradeInitialize)(void);
@interface MNFirmwareService()<otaApiUpdateAppDataDelegate,otaEnableConfirmDelegate>
@end
@implementation MNFirmwareService
{
    uint16_t pubFwLength;
    CoreSuccess upgradeSuccessBlock_;
    CoreFailure upgradeFailureBlock_;
    UpgradePress upgradePressBlock_;
    UpgradeInitialize upgradeInitializeBlock_;
}
+(MNFirmwareService *)shareInstance
{
    static MNFirmwareService *simple;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        simple = [[MNFirmwareService alloc] init];
    });
    return simple;
}
#pragma mark 检查最新固件版本
-(BOOL)isLatestFirmware
{
    __block BOOL isLatestFirmware=NO;
    
    [self queryNetFirmwareWithSuccess:^(id result) {
        if ([(NSString *)result[@"error"] isEqualToString:@"0"]) {
            if ([result[@"version"] intValue] > [[MNFirmwareModel sharestance].firmwareVersion intValue]) {
                isLatestFirmware=YES;
            }
        }
        
    } failure:nil];
    
    return isLatestFirmware;
}

/**
 *  获取最新固件信息
 *
 *  @param success      成功
 *  @param failure      失败
 */
-(void)queryNetFirmwareWithSuccess:(CoreSuccess)success failure:(CoreFailure)failure
{
    //参数字典
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setValue:@"bracelet.firmwareupgrade" forKey:@"method"];
    [parameter setValue:[MNFirmwareModel sharestance].type forKey:@"deviceType"];
    [MNetManager netGetWithParameter:(NSDictionary *)parameter success:^(id result) {
        success(result);
    } failure:^(id reason) {
        failure(reason);
    }];
}

#pragma mark 开始固件升级
-(void)startUpgradeWithNo:(void(^)(void))no withProgress:(void (^)(int upgradeProgress))progress withInitialize:(void(^)(void))initialize withSuccess:(CoreFailure)success withFailure:(CoreFailure)failure
{
    upgradeSuccessBlock_  = [success copy];
    
    [self upgradeWithNo:^{
        no();
    } withProgress:^(int upgradeProgress) {
        progress(upgradeProgress);
    } withInitialize:^{
        [[qBleClient sharedInstance] setUpgradeFinish];
        [[MNBleBaseService shareInstance]setBleFunctionStateFree];
        initialize();
        //同步参数
        [self performSelector:@selector(sync) withObject:nil afterDelay:5.0f];
    } withFailure:^(id reason) {
        failure(reason);
    }];
}


#pragma mark 固件升级
-(void)upgradeWithNo:(void (^)(void))no withProgress:(void (^)(int upgradeProgress))progress withInitialize:(void (^)(void))initialize withFailure:(CoreFailure)failure
{
    upgradeFailureBlock_ = [failure copy];
    upgradePressBlock_ = [progress copy];
    upgradeInitializeBlock_ = [initialize copy];
    [self queryNetFirmwareWithSuccess:^(id result) {
        if ([(NSString *)result[@"error"] isEqualToString:@"0"]) {
            if ([result[@"version"] intValue] > [[MNFirmwareModel sharestance].firmwareVersion intValue]) {
                NSString *fileName = @"";
                if ([MNDeviceBindingService shareInstance].upgradeType == UpgradeTypeDialogOta) {
                    fileName = @"firmware.img";
                }else
                {
                    fileName = @"firmware.bin";
                }
                
                [MNetManager downLatestFirmwareWithUrl:result[@"url"] withToken:result[@"token"] withFileName:fileName withSuccess:^(id result) {
                    //  下载成功
                    MNDeviceBindingService *deviceBindingService = [MNDeviceBindingService shareInstance];
                    switch (deviceBindingService.upgradeType) {
                        case UpgradeTypeOld:
                        {
                            //Q1升级
                            DLog(@"Q1升级");
                        }
                            break;
                        case UpgradeTypeNew:
                        {
                            //Q2升级
                            DLog(@"Quintic固件升级");
                            [[MNQuinticUpgradeService shareInstance] startQuinticUpgradeProgress:^(int progress) {
                                upgradePressBlock_(progress);
                            } withSuccess:^(id reason) {
                                initialize();
                            } withFailure:^(id reason) {
                                 failure(reason);
                            }];
                        }
                            break;
                        case UpgradeTypeLibOta:
                        {
                            //昆电科OTA升级
                            DLog(@"昆电科OTA升级");
                            [self upgradeLibOta];
                        }
                            break;
                        case UpgradeTypeDialogOta:
                        {
                            //dialogOTA升级
                            DLog(@"dialogOTA升级");
                            [[MNDialogOtaUpgradeService shareInstance] startDialogOtaUpgradeProgress:^(int progress) {
                                upgradePressBlock_(progress);
                            } withSuccess:^(id reason) {
                                initialize();
                            } withFailure:^(id reason) {
                                failure(reason);
                            }];
                            
                        }
                            break;
                        
                        default:
                            break;
                    }
                    
                } withFailure:^(id reason) {
                    //固件下载失败
                    failure(NSLocalizedString(@"固件下载失败",nil));
                }];
            }else{
                no();
            }
            
        }else if ([(NSString *)result[@"error"] isEqualToString:@"15"])
        {
            failure(NSLocalizedString(@"设备类型未上传固件",nil));
        }
        
    } failure:^(id reason) {
        failure(reason);
    }];
}

-(void)sync
{
    [[MNBleBaseService shareInstance] syncWithSuccess:^(id result) {
        upgradeSuccessBlock_(result);
    } withBinding:NO withFailure:^(id reason) {
        upgradeFailureBlock_(reason);
    }];
}

#pragma mark --------------------昆电科OTA升级 部分-------------------

#pragma mark 昆电科OTA升级
-(void)upgradeLibOta
{
    qBleClient *bleClient = [qBleClient sharedInstance];
    [bleClient manualDisconnectBle];
    [bleClient startOTAUpgrade];
    [otaApi sharedInstance].otaEnableConfirmDelegate=self;
    [otaApi sharedInstance].otaApiUpdateAppDataDelegate=self;
}

-(void)didOtaEnableConfirm : (CBPeripheral *)aPeripheral
                withStatus : (enum otaEnableResult) otaEnableStatus
{
    
    
    NSString *cachepath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *filename=[cachepath stringByAppendingPathComponent:@"firmware.bin"];
    NSData *newFwFile =[NSData dataWithContentsOfFile:filename];
    
    const uint8_t *newFwFileByte = [newFwFile bytes];
    
    // uint32_t
    pubFwLength = (uint16_t) [newFwFile length];
    
    
    NSLog(@"newFwFileByte : %d", pubFwLength);
    
    if(pubFwLength == 0)
    {
        NSLog(@"文件为空");
        
        return;
    }
    
    if(pubFwLength > 50*1024)
    {
        
        NSLog(@"文件太大");
        
        return;
    }
    NSLog(@"aPeripheral=%@",aPeripheral);
    // ===== to start download ======
    [[otaApi sharedInstance] otaStart : aPeripheral
                         withDataByte : newFwFileByte
                           withLength : pubFwLength
                             withFlag : FALSE];
}

-(void)didOtaAppProgress : (enum otaResult)otaPackageSentStatus
            withDataSent : (uint16_t)otaDataSent
{
    int progress=(int)((otaDataSent/(float)pubFwLength)*100);
    upgradePressBlock_(progress);
}
-(void)didOtaMetaDataResult : (enum otaResult)otaMetaDataSentStatus
{
    
}
-(void)didOtaAppResult : (enum otaResult )otaResult
{
    upgradePressBlock_(100);
    [[qBleClient sharedInstance] stopOTAUpgrade];
    upgradeInitializeBlock_();
    
}





@end
