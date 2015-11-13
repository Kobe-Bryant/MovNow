//
//  MNBleBaseService.h
//  Movnow
//
//  Created by baoyx on 15/4/22.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CBCharacteristic;
typedef NS_ENUM(NSInteger,LightColorType)
{
    LightColorTypeBlue=0, //蓝色
    LightColorTypeOrange,  //橙色
    LightColorTypeGreen,   //绿色
    LightColorTypeRed,     //红色
};

@protocol MNBleBaseServiceTempStepsDelegate<NSObject>

-(void)receviceTempSteps:(int)steps;   //临时计步数据

@end
@protocol  MNBleBaseServiceBindingMessageDelegate<NSObject>

-(void)receviceBindingMessage;     //设备回应绑定

@end

@protocol  MNBleBaseServicePhotoMessageDelegate<NSObject>

-(void)recevicePhotoMessage;           //设备照相

@end

@protocol  MNBleBaseServiceStepDataDelegate<NSObject>

-(void)receviceStepData:(NSData *)stepData; //接收计步数据

@end
@protocol  MNBleBaseServiceSleepDataDelegate<NSObject>

-(void)receviceSleepData:(NSData *)sleepData; //接收睡眠数据

@end

@protocol  MNBleBaseServiceDialogOtaUpgradeDelegate<NSObject>
-(void)receviceUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error;
-(void)receviceWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error;
@end

@protocol  MNBleBaseServiceQuinticUpgradeDelegate<NSObject>
-(void)receviceQuinticUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error;
@end
@interface MNBleBaseService : NSObject
@property (nonatomic,assign) id<MNBleBaseServiceTempStepsDelegate>tempStepsDelegate;
@property (nonatomic,assign) id<MNBleBaseServiceBindingMessageDelegate>bindingMessageDelegate;
@property (nonatomic,assign) id<MNBleBaseServicePhotoMessageDelegate>photoMessageDelegate;
@property (nonatomic,assign) id<MNBleBaseServiceStepDataDelegate>stepDataDelegate;
@property (nonatomic,assign) id<MNBleBaseServiceSleepDataDelegate>sleepDataDelegate;
@property (nonatomic,assign) id<MNBleBaseServiceDialogOtaUpgradeDelegate>dialogOtaUpgradeDelegate;
@property (nonatomic,assign) id<MNBleBaseServiceQuinticUpgradeDelegate>quinticUpgradeDelegate;
+(MNBleBaseService*)shareInstance;
/**
 *  同步(同步时间、身高和体重等等)
 *
 *  @param success   同步成功
 *  @param isBinding 是否绑定时同步
 *  @param failure   同步失败
 */
-(void)syncWithSuccess:(CoreSuccess)success withBinding:(BOOL)isBinding withFailure:(CoreFailure)failure;
/**
 *  同步计步数据
 *
 *  @param success   同步计步数据成功
 *  @param failure   同步计步失败
 */
-(void)syncStepWithSuccess:(CoreSuccess)success withFailure:(CoreFailure)failure;

/**
 *  同步睡眠数据
 *
 *  @param success   同步睡眠数据成功
 *  @param failure   同步睡眠数据失败
 */
-(void)syncSleepWithSuccess:(CoreSuccess)success withFailure:(CoreFailure)failure;
/**
 *  查询设备绑定情况
 *
 *  @param success 查询成功
 *  @param failure 查询失败
 */
-(void)selectBindingWithSuccess:(CoreSuccess)success withFailure:(CoreFailure)failure;
/**
 *  申请绑定
 *
 *  @param success 申请绑定成功
 *  @param failure 申请绑定失败
 */
-(void)entryBindingWithSuccess:(CoreSuccess)success withFailure:(CoreFailure)failure;
/**
 *  确认绑定
 *
 *  @param success 确认绑定成功
 *  @param failure 确认绑定失败
 */
-(void)verifyBindingWithSuccess:(CoreSuccess)success withFailure:(CoreFailure)failure;
/**
 * 解除绑定
 *
 *  @param success 解除绑定成功
 *  @param failure 解除绑定失败
 */
-(void)removeBindingWithSuccess:(CoreSuccess)success withFailure:(CoreFailure)failure;
/**
 *  查找设备
 *
 *  @param success 查找设备成功
 *  @param failure 查找失败
 */
-(void)findDeviceWithSuccess:(CoreSuccess)success withFailure:(CoreFailure)failure;
/**
 *  防丢
 *
 *  @param isOpen  是否打开
 *  @param success 防丢成功
 *  @param failure 防丢失败
 */
-(void)lostWithOpen:(BOOL)isOpen withSuccess:(CoreSuccess)success withFailure:(CoreFailure)failure;

/**
 *  按键锁定(拍照)
 *
 *  @param isLock  是否锁定
 *  @param success 成功
 *  @param failure 防丢
 */
-(void)keyLockWithLock:(BOOL)isLock withSuccess:(CoreSuccess)success withFailure:(CoreFailure)failure;
/**
 *  灯色切换
 *
 *  @param corlor  颜色
 *  @param success 成功
 *  @param failure 失败
 */
-(void)lightWithLightColorType:(LightColorType)corlor withSuccess:(CoreSuccess)success withFailure:(CoreFailure)failure;

/**
 *  查询固件信息
 *
 *  @param success 成功
 *  @param failure 失败
 */
-(void)selectFirmwareWithSuccess:(CoreSuccess)success withFailure:(CoreFailure)failure;
/**
 *  提醒设置
 *
 *  @param data    设置参数
 *  @param success 设置成功
 *  @param failure 设置失败
 */
-(void)warnWithData:(NSData *)data withSuccess:(CoreSuccess)success withFailure:(CoreFailure)failure;
/**
 *  来电提醒
 *
 *  @param success 成功
 *  @param failure 失败
 */
-(void)callWarnWithOpen:(BOOL)isOpen withSuccess:(CoreSuccess)success withFailure:(CoreFailure)failure;
/**
 *  查询电量
 *
 *  @param success 成功
 *  @param failure 失败
 */
-(void)electricityWithSuccess:(CoreSuccess)success withFailure:(CoreFailure)failure;


/**
 *  dialogOTA升级
 *
 *  @param success 成功
 *  @param failure 失败
 */
-(void)dialogOtaUpgradeWithSuccess:(CoreSuccess)success withFailure:(CoreFailure)failure;

/**
 *   quintic升级
 */
-(void)quinticUpgrade;

/**
 *  发送指令失败
 *
 *  @param reason 指令失败原因
 */
-(void)setFailureBlockWithReason:(id)reason;

/**
 *  发送指令成功
 *
 *  @param result 发送指令成功结果
 */
-(void)setSuccessBlockWithResult:(id)result;
/**
 *  设置空闲状态(升级完成,升级失败)
 */
-(void)setBleFunctionStateFree;

@end
