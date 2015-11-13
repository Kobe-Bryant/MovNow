//
//  QBleClient.h
//  Movnow
//
//  Created by baoyx on 15/4/20.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//

#import <Foundation/Foundation.h>
static NSString * SPOTA_SERVICE_UUID     = @"0000fef5-0000-1000-8000-00805f9b34fb";
static NSString * SPOTA_MEM_DEV_UUID     = @"8082caa8-41a6-4021-91c6-56f9b954cc34";
static NSString * SPOTA_GPIO_MAP_UUID    = @"724249f0-5ec3-4b5f-8804-42345af08651";
static NSString * SPOTA_MEM_INFO_UUID    = @"6c53db25-47a1-45fe-a022-7c92fb334fd4";
static NSString * SPOTA_PATCH_LEN_UUID   = @"9d84b9a3-000c-49d8-9183-855b673fda31";
static NSString * SPOTA_PATCH_DATA_UUID  = @"457871e8-d516-4ca1-9116-57d0b17b9cb2";
static NSString * SPOTA_SERV_STATUS_UUID = @"5f78df94-798c-46f5-990a-b3eb6a065c88";

typedef NS_ENUM(NSInteger,BLEState){
    Unknown = 0,   //初始化中
    Unsupported,  //不支持蓝牙
    PoweredOff,       //未打开蓝牙
    PoweredOn,        //蓝牙已启动
};

typedef NS_ENUM(NSInteger,DeviceType){
    Bracelet = 0, //手环
};


@class CBCharacteristic;
@class qBleClient;
@class CBPeripheral;
@class CBService;
/// ble update for char delegate.

@protocol bleDidConnectionsDelegate<NSObject>

/**
 ****************************************************************************************
 * @brief       delegate ble update connected peripheral.
 *
 * @param[out]  aPeripheral : the connected peripheral.
 *
 ****************************************************************************************
 */
-(void)bleDidConnectPeripheral : (CBPeripheral *)aPeripheral;
@end
@protocol bleUpdateForOtaDelegate<NSObject>

/**
 ****************************************************************************************
 * @brief       delegate ble update service and chara.
 *
 * @param[out]  aPeripheral    : the peripheral connected.
 * @param[out]  aService       : the OTA service discovered.
 * @param[out]  error          : the error from CoreBluetooth if there is.
 *
 ****************************************************************************************
 */
-(void)bleDidUpdateCharForOtaService : (CBPeripheral *)aPeri
                         withService : (CBService *)aService
                               error : (NSError *)error;

/**
 ****************************************************************************************
 * @brief       delegate ble update value for Char.
 *
 * @param[out]  aService       : the OTA service discovered.
 * @param[out]  characteristic : the OTA characteristic updated.
 * @param[out]  error          : the error from CoreBluetooth if there is.
 *
 ****************************************************************************************
 */
-(void)bleDidUpdateValueForOtaChar : (CBService *)aService
                          withChar : (CBCharacteristic *)characteristic
                             error : (NSError *)error;
@end

@protocol  bleDisConnectionsDelegate<NSObject>

/**
 *  设备蓝牙非正常断开代理
 *
 *  @param aPeripheral 断开外设
 */
-(void)bleDisConnectPeripheral : (CBPeripheral *)aPeripheral;

@end
@protocol  bleUpdateForDataDelegate<NSObject>
-(void)bledidWriteValueForChar:(CBCharacteristic *)characteristic error : (NSError *)error;
-(void)bleDidUpdateValueForChar:(CBCharacteristic *)characteristic error : (NSError *)error;
@end

@interface qBleClient : NSObject
@property (nonatomic,assign) id <bleUpdateForOtaDelegate>  bleUpdateForOtaDelegate;
@property (nonatomic,assign) id <bleDidConnectionsDelegate> bleDidConnectionsDelegate;
@property (nonatomic,assign) id<bleDisConnectionsDelegate>bleDisConnectionsDelegate;
@property (nonatomic,assign) id<bleUpdateForDataDelegate>bleUpdateForDataDelegate;
@property (nonatomic,copy,readonly) CBCharacteristic *spota_mem_dev_ch;
@property (nonatomic,copy,readonly) CBCharacteristic *spota_gpio_map_ch;
@property (nonatomic,copy,readonly) CBCharacteristic *spota_mem_info_ch;
@property (nonatomic,copy,readonly) CBCharacteristic *spota_patch_len_ch;
@property (nonatomic,copy,readonly) CBCharacteristic *spota_patch_data_ch;
@property (nonatomic,copy,readonly) CBCharacteristic *spota_serv_statasus_ch;
@property (nonatomic,readonly,copy) CBCharacteristic *writeChar;
@property (nonatomic,readonly,copy) CBCharacteristic *notifyChar;
@property (nonatomic, readonly, retain) NSMutableArray *discoveredServices;
@property (nonatomic,readonly,strong) CBPeripheral *periperal;

@property (nonatomic,readonly) BLEState state;
+(qBleClient *)sharedInstance;
/**
 *  启动蓝牙(在AppDelegate设置)
 */
-(void)startBle;
/**
 *  连接未绑定不同类型设备(手环、体质称)
 *
 *  @param type    设备类型
 *  @param success 连接成功
 *  @param failure 连接失败
 */
-(void)connectBleWithNoBindingDeviceType:(DeviceType)type success:(CoreSuccess)success failure:(CoreFailure)failure;
/**
 *  连接已经绑定不同类型设备(手环、体质称,外设不存在)
 *
 *  @param type    设备类型
 *  @param success 连接成功
 *  @param failure 连接失败
 */
-(void)connectBleWithBindingDeviceType:(DeviceType)type success:(CoreSuccess)success failure:(CoreFailure)failure;

/**
 *  连接外设已经存在的设备(设备断开)
 *
 *  @param periperal  外设
 *  @param success   连接成功
 *  @param failure   连接失败
 */
-(void)connectWithPeriperal:(CBPeripheral *)periperal success:(CoreSuccess)success failure:(CoreFailure)failure;
/**
 *  开始OTA升级
 */
-(void)startOTAUpgrade;
/**
 *  停止OTA升级
 */
-(void)stopOTAUpgrade;
/**
 *  手动断开连接(昆天科OTA升级前需要断开蓝牙)
 */
-(void)manualDisconnectBle;
/**
 *  设置升级完成(升级完成,设备主动断开,不需要设置蓝牙断开的代理)
 */
-(void)setUpgradeFinish;
/**
 *  写数据
 *
 *  @param data 数据信息
 */
-(void)sendData:(NSData *)data withFailure:(CoreFailure)failure;
/**
 *  清除外设数据(绑定失败或者解除绑定)
 */
-(void)clearPeriperal;
/**
 *  解除正在绑定
 */
-(void)cancelBinding;

@end
