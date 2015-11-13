//
//  QBleClient.m
//  Movnow
//
//  Created by baoyx on 15/4/20.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//

#import "QBleClient.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "MNFirmwareModel.h"
@interface  qBleClient()<CBCentralManagerDelegate,CBPeripheralDelegate>
@end
@implementation qBleClient
{
    CBCentralManager *manager_;
    CoreSuccess connectSuccess_;
    CoreFailure connectFailure_;
    __block NSMutableArray *scaneServices_;
    __block NSMutableArray *discoveredServices_;
    __block NSMutableArray *writeCBCharacteristics_;
    __block NSMutableArray *readCBCharacteristics_;
    __block NSMutableArray  *allCBCharacteristics_;
    
    //定时器
    NSTimer *searchTime_;    //搜索定时器
    NSTimer *connectTime_;   //连接定时器
    int tempRSSI;   //临时信号强度
    CBPeripheral *tempPeripheral;
    
    BOOL isConnecting; //是否正在连接
    BOOL isManualDisconnect; //是否手动断开
    BOOL isOTAUpgradeing;  //是否正在OTA升级
    BOOL isReConnct;      //是否重连
    BOOL isBinding;       //是否绑定
}
@synthesize discoveredServices = _discoveredServices;
+(qBleClient *)sharedInstance
{
    static qBleClient *simple;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        simple = [[qBleClient alloc] init];
    });
    return simple;
}
-(instancetype)init
{
    if (self = [super init]) {
        _discoveredServices = [NSMutableArray array];
        scaneServices_ = [NSMutableArray array];
        discoveredServices_ = [NSMutableArray array];
        writeCBCharacteristics_ = [NSMutableArray array];
        readCBCharacteristics_ = [NSMutableArray array];
        allCBCharacteristics_ = [NSMutableArray array];
        tempRSSI = -90;
    }
    return self;
}
#pragma mark 启动蓝牙
-(void)startBle
{
    manager_ = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
}

#pragma mark  连接未绑定不同类型设备(手环、体质称)
-(void)connectBleWithNoBindingDeviceType:(DeviceType)type success:(CoreSuccess)success failure:(CoreFailure)failure
{
    isBinding = YES;
    [self initializeSeviceWithDeviceType:type];
    connectSuccess_ = [success copy];
    connectFailure_ = [failure copy];
    [self stopSearchTime];
    [manager_ scanForPeripheralsWithServices:scaneServices_ options:nil];
    searchTime_ = [NSTimer scheduledTimerWithTimeInterval:SEARCH_INTERVAL target:self selector:@selector(stopScan) userInfo:nil repeats:NO];
    
}

#pragma mark  连接已经绑定不同类型设备(手环、体质称)
-(void)connectBleWithBindingDeviceType:(DeviceType)type success:(CoreSuccess)success failure:(CoreFailure)failure
{
    connectSuccess_ = [success copy];
    connectFailure_ = [failure copy];
    
    CBPeripheral *per = [self retrieveConnectedPeripheralsWithServicesWithDeviceType:type];
    if (per) {
        [self stopConnectTime];
        tempPeripheral = per;
        [manager_ connectPeripheral:tempPeripheral options:nil];
        connectTime_ = [NSTimer scheduledTimerWithTimeInterval:CONNECT_INTERVAL target:self selector:@selector(connectTimeout) userInfo:nil repeats:NO];
    }else{
        [self stopSearchTime];
        [manager_ scanForPeripheralsWithServices:scaneServices_ options:nil];
        searchTime_ = [NSTimer scheduledTimerWithTimeInterval:SEARCH_INTERVAL target:self selector:@selector(stopScan) userInfo:nil repeats:NO];
    }
    
}

-(CBPeripheral*)retrieveConnectedPeripheralsWithServicesWithDeviceType:(DeviceType)type
{
    [self initializeSeviceWithDeviceType:type];
     NSArray *peripherals = [manager_ retrieveConnectedPeripheralsWithServices:discoveredServices_];
    for (CBPeripheral * peripheral in peripherals) {
        if ([[peripheral.identifier UUIDString] isEqualToString:[MNFirmwareModel sharestance].uuid]) {
            return peripheral;
        }
    }
    return nil;
}

-(void)connectWithPeriperal:(CBPeripheral *)periperal success:(CoreSuccess)success failure:(CoreFailure)failure
{
    connectSuccess_ = [success copy];
    connectFailure_ = [failure copy];
    isReConnct=YES;
    [self stopConnectTime];
    [manager_ connectPeripheral:periperal options:nil];
    connectTime_ = [NSTimer scheduledTimerWithTimeInterval:CONNECT_INTERVAL target:self selector:@selector(connectTimeout) userInfo:nil repeats:NO];
}

#pragma mark 初始化服务
-(void)initializeSeviceWithDeviceType:(DeviceType)type
{
    NSString *file = @"Bracelet";
    switch (type) {
        case Bracelet:
            file= @"Bracelet";
            break;
            
        default:
            break;
    }
    NSDictionary *plist= [NSMutableDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Bluetooth" ofType:@"plist"]];
    //搜索服务
    NSString *scaneServiceKey = [NSString stringWithFormat:@"%@ScanServices",file];
    [(NSArray *)plist[scaneServiceKey] enumerateObjectsUsingBlock:^(NSString *uuid, NSUInteger idx, BOOL *stop) {
        [scaneServices_ addObject:[CBUUID UUIDWithString:uuid]];
    }];
    
    //发现服务
    NSString *discoveredServiceKey = [NSString stringWithFormat:@"%@DiscoveredServices",file];
    [(NSArray *)plist[discoveredServiceKey] enumerateObjectsUsingBlock:^(NSString *uuid, NSUInteger idx, BOOL *stop) {
        [discoveredServices_ addObject:[CBUUID UUIDWithString:uuid]];
    }];
    [discoveredServices_ addObject:[CBUUID UUIDWithString:SPOTA_SERVICE_UUID]];
    
    //写特征
    NSString *writeCBCharacteristicKey = [NSString stringWithFormat:@"%@WriteCBCharacteristics",file];
    [(NSArray *)plist[writeCBCharacteristicKey] enumerateObjectsUsingBlock:^(NSString *uuid, NSUInteger idx, BOOL *stop) {
        [writeCBCharacteristics_ addObject:[CBUUID UUIDWithString:uuid]];
        [allCBCharacteristics_ addObject:[CBUUID UUIDWithString:uuid]];
    }];
    
    //读特征
    NSString *readCBCharacteristicKey = [NSString stringWithFormat:@"%@ReadCBCharacteristics",file];
    [(NSArray *)plist[readCBCharacteristicKey] enumerateObjectsUsingBlock:^(NSString *uuid, NSUInteger idx, BOOL *stop) {
        [readCBCharacteristics_ addObject:[CBUUID UUIDWithString:uuid]];
        [allCBCharacteristics_ addObject:[CBUUID UUIDWithString:uuid]];
    }];
    [allCBCharacteristics_ addObject:[CBUUID UUIDWithString:SPOTA_MEM_DEV_UUID]];
    [allCBCharacteristics_ addObject:[CBUUID UUIDWithString:SPOTA_GPIO_MAP_UUID]];
    [allCBCharacteristics_ addObject:[CBUUID UUIDWithString:SPOTA_MEM_INFO_UUID]];
    [allCBCharacteristics_ addObject:[CBUUID UUIDWithString:SPOTA_PATCH_LEN_UUID]];
    [allCBCharacteristics_ addObject:[CBUUID UUIDWithString:SPOTA_PATCH_DATA_UUID]];
    [allCBCharacteristics_ addObject:[CBUUID UUIDWithString:SPOTA_SERV_STATUS_UUID]];
    
}

#pragma mark 开始OTA升级
-(void)startOTAUpgrade
{
    isOTAUpgradeing=YES;
    [manager_ connectPeripheral:_periperal options:nil];
}

#pragma mark 停止OTA升级
-(void)stopOTAUpgrade
{
    isOTAUpgradeing=NO;
}

#pragma mark 手动断开蓝牙
-(void)manualDisconnectBle
{
    isManualDisconnect =YES;
    if (_periperal) {
        if (_periperal.state ==CBPeripheralStateConnected) {
            [manager_ cancelPeripheralConnection:_periperal];
        }
    }
}

#pragma mark 设置升级成功

-(void)setUpgradeFinish
{
    isManualDisconnect =YES;
}

-(void)sendData:(NSData *)data withFailure:(CoreFailure)failure
{
    if (_periperal) {
        if (_writeChar) {
            if (_periperal.state == CBPeripheralStateConnected) {
                DLog(@"发送数据:sendData:%@, len=%d\n",data,(int)data.length);
                [_periperal writeValue:data forCharacteristic:_writeChar type:CBCharacteristicWriteWithResponse];
            }else
            {
                failure(@"外设设备已经断开");
            }
            
        }else
        {
            failure(@"写特征不存在");
        }
        
    }else{
        failure(@"外设不存在");
    }
}

-(void)clearPeriperal{
    [self manualDisconnectBle];
    _periperal=nil;
    _writeChar=nil;
    _notifyChar=nil;
    _spota_mem_dev_ch=nil;
    _spota_gpio_map_ch=nil;
    _spota_mem_info_ch=nil;
    _spota_patch_len_ch=nil;
    _spota_patch_data_ch=nil;
    _spota_serv_statasus_ch=nil;
    [[MNFirmwareModel sharestance] clearCache];
}

-(void)cancelBinding
{
    isBinding=NO;
}
#pragma mark 停止搜索
-(void)stopScan
{
    [self stopSearchTime];
    if (tempPeripheral) {
        tempRSSI = -90;
        [self stopConnectTime];
        isConnecting=YES;
        connectTime_ = [NSTimer scheduledTimerWithTimeInterval:CONNECT_INTERVAL target:self selector:@selector(connectTimeout) userInfo:nil repeats:NO];
        DLog(@"tempPeripheral=%@",[tempPeripheral.identifier UUIDString]);
        [manager_ connectPeripheral:tempPeripheral options:nil];
    }else
    {
        connectFailure_(@"搜索超时");
    }
}

#pragma mark 连接超时
-(void)connectTimeout
{
    [self stopConnectTime];
    connectFailure_(@"连接蓝牙设备超时");
}


#pragma mark --------------------------停止定时器----------------------------------

#pragma mark 停止搜索服务定时器
-(void)stopSearchTime
{
    [manager_ stopScan];
    if(searchTime_)
    {
        [searchTime_ invalidate];
        searchTime_=nil;
    }
}

#pragma mark 停止连接设备定时器
-(void)stopConnectTime
{
    isConnecting =NO;
    if(connectTime_)
    {
        [connectTime_ invalidate];
        connectTime_=nil;
    }
}

#pragma mark 判断蓝牙状态

-(BOOL)isLECapableHardware
{
    BOOL isBool =NO;
    switch ([manager_ state]) {
        case CBCentralManagerStateUnknown:
            _state = Unknown;
            DLog(@"初始化中，请稍后……");
            isBool =YES;
            break;
        case CBCentralManagerStateResetting:
            DLog(@"设备不支持状态，过会请重试……");
            _state = Unsupported;
            isBool =NO;
            break;
        case CBCentralManagerStateUnsupported:
            DLog(@"设备未授权状态，过会请重试……");
            _state = Unsupported;
            isBool =NO;
            break;
        case CBCentralManagerStateUnauthorized:
            DLog(@"设备未授权状态，过会请重试……");
            _state = Unsupported;
            isBool =NO;
            break;
        case CBCentralManagerStatePoweredOff:
            DLog(@"尚未打开蓝牙，请在设置中打开……");
            _state = PoweredOff;
            isBool =NO;
            break;
        case CBCentralManagerStatePoweredOn:
            DLog(@"蓝牙已经成功开启，稍后……");
            _state = PoweredOn;
            isBool =YES;
            break;
        default:
            break;
    }
    return isBool;
}



#pragma mark --------------------------CBCentralManagerDelegate----------------------------------
#pragma mark  蓝牙状态改变代理
-(void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    [self isLECapableHardware];
    
    
}

#pragma mark  扫描
-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    
    
    if ([RSSI intValue] < -90 || [RSSI intValue] >90) {
        return;
    }
    
    DLog(@"advertisementData=%@,RSSI=%@,uuid=%@",advertisementData,RSSI,[peripheral.identifier UUIDString]);
    if ([MNFirmwareModel sharestance].uuid == nil || [[MNFirmwareModel sharestance].uuid isEqualToString:@""]) {
        //未绑定设备
        if ([RSSI intValue] >tempRSSI) {
            
            tempRSSI = [RSSI intValue];
            tempPeripheral =peripheral;
        }
        
    }else
    {
        //已经绑定设备
        if (peripheral.identifier && [peripheral.identifier.UUIDString isEqualToString:[MNFirmwareModel sharestance].uuid]) {
            [self stopSearchTime];
            tempPeripheral=peripheral;
            tempRSSI = -90;
            [self stopConnectTime];
            isConnecting=YES;
            connectTime_ = [NSTimer scheduledTimerWithTimeInterval:CONNECT_INTERVAL target:self selector:@selector(connectTimeout) userInfo:nil repeats:NO];
            DLog(@"tempPeripheral=%@",[tempPeripheral.identifier UUIDString]);
            [manager_ connectPeripheral:tempPeripheral options:nil];
            
        }
    }
    
}

#pragma mark 蓝牙连接成功代理
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    DLog(@"蓝牙连接成功");
    if (isOTAUpgradeing) {
        /*********************************************************************
         OTA升级部分
         *********************************************************************/
        [peripheral setDelegate : self];
        [peripheral discoverServices : nil];
        
        [_bleDidConnectionsDelegate bleDidConnectPeripheral : peripheral];
    }else if (isReConnct)
    {
        isReConnct=NO;
        connectSuccess_(@"重连成功");
    }
    else{
        peripheral.delegate =self;
        [peripheral discoverServices:discoveredServices_];
    }
}

#pragma mark  蓝牙连接失败代理
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    [self stopConnectTime];
    connectFailure_(@"蓝牙连接失败");
}

#pragma mark  断开蓝牙连接回调
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    if (isConnecting) {
        isConnecting=NO;
        connectFailure_(@"蓝牙设备不稳定,连接断开");
    }else if (isManualDisconnect)
    {
        isManualDisconnect=NO;
        return;
    }else if (isBinding)
    {
        isBinding=NO;
        return;
    }
    else
    {
        if (_bleDisConnectionsDelegate && [_bleDisConnectionsDelegate respondsToSelector:@selector(bleDisConnectPeripheral:)]) {
            [_bleDisConnectionsDelegate bleDisConnectPeripheral:peripheral];
        }
    }
}



#pragma mark --------------------------CBPeripheralDelegate----------------------------------




#pragma mark 发现服务代理
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    DLog(@"发现服务回调");
    if (isOTAUpgradeing) {
        
        /*********************************************************************
         OTA升级部分
         *********************************************************************/
        [_discoveredServices removeAllObjects];
        
        for (CBService *aService in peripheral.services)
        {
            [peripheral discoverCharacteristics : nil forService : aService];
            
            if( ![_discoveredServices containsObject : aService] )
            {
                [_discoveredServices addObject : aService];
            }
        }
    }else
    {
        
        for (CBService *service in peripheral.services)
        {
            [peripheral discoverCharacteristics:allCBCharacteristics_ forService:service];
        }
    }
    
}
#pragma mark  发现特征回调
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    NSLog(@"发现特征回调");
    DLog(@"services=%@",peripheral.services);
    if (isOTAUpgradeing) {
        /*********************************************************************
         OTA升级部分
         *********************************************************************/
        if(_bleUpdateForOtaDelegate)
        {
            [_bleUpdateForOtaDelegate bleDidUpdateCharForOtaService:peripheral withService:service error:error];
            [[NSNotificationCenter defaultCenter] postNotificationName : bleDiscoveredCharacteristicsNoti
                                                                object : nil
                                                              userInfo : nil];
        }
    }else
    {
        for (CBCharacteristic *car in service.characteristics) {
            if ([readCBCharacteristics_ containsObject:car.UUID]) {
                DLog(@"读通道");
                [peripheral setNotifyValue:YES forCharacteristic:car];
                _notifyChar=car;
                if (_notifyChar && _writeChar) {
                    connectSuccess_(@"蓝牙设备连接成功");
                }
            }
            if ([writeCBCharacteristics_ containsObject:car.UUID]) {
                DLog(@"写通道");
                [self stopConnectTime];
                _periperal =peripheral;
                _writeChar=car;
                [MNFirmwareModel sharestance].uuid = peripheral.identifier.UUIDString;
                if (_notifyChar && _writeChar) {
                    connectSuccess_(@"蓝牙设备连接成功");
                }
            }
            
            if ([car.UUID isEqual:[CBUUID UUIDWithString:SPOTA_MEM_DEV_UUID]]) {
                DLog(@"spota_mem_dev_ch");
                _spota_mem_dev_ch =car;
            }
            
            if ([car.UUID isEqual:[CBUUID UUIDWithString:SPOTA_GPIO_MAP_UUID]]) {
                DLog(@"spota_gpio_map_ch");
                _spota_gpio_map_ch =car;
            }
            
            if ([car.UUID isEqual:[CBUUID UUIDWithString:SPOTA_MEM_INFO_UUID]]) {
                DLog(@"spota_mem_info_ch");
                _spota_mem_info_ch =car;
            }
            
            if ([car.UUID isEqual:[CBUUID UUIDWithString:SPOTA_PATCH_LEN_UUID]]) {
                DLog(@"spota_patch_len_ch");
                _spota_patch_len_ch =car;
            }
            
            if ([car.UUID isEqual:[CBUUID UUIDWithString:SPOTA_PATCH_DATA_UUID]]) {
                DLog(@"spota_patch_data_ch");
                _spota_patch_data_ch = car;
            }
            
            if ([car.UUID isEqual:[CBUUID UUIDWithString:SPOTA_SERV_STATUS_UUID]]) {
                DLog(@"spota_serv_statasus_ch");
                _spota_serv_statasus_ch =car;
            }
        }
        
    }
}



- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
 
    if (_bleUpdateForDataDelegate && [_bleUpdateForDataDelegate respondsToSelector:@selector(bledidWriteValueForChar:error:)]) {
        [_bleUpdateForDataDelegate bledidWriteValueForChar:characteristic error:error];
    }
}


- (void) peripheral:(CBPeripheral *)aPeripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if(isOTAUpgradeing)
    {
        for (CBService *aService in aPeripheral.services)
        {
            [_bleUpdateForOtaDelegate bleDidUpdateValueForOtaChar : aService
                                                         withChar : characteristic
                                                            error : error];
        }
    }else
    {
        if (_bleUpdateForDataDelegate && [_bleUpdateForDataDelegate respondsToSelector:@selector(bleDidUpdateValueForChar:error:)]) {
            [_bleUpdateForDataDelegate bleDidUpdateValueForChar:characteristic error:error];
        }
    }
}
@end
