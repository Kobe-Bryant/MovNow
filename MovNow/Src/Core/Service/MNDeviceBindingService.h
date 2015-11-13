//
//  MNDeviceBindingService.h
//  Movnow
//
//  Created by LiuX on 15/4/17.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//  所有与设备绑定相关的服务类

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, MNDeviceType){ //所有的设备类型
    MNDeviceTypeW001A = 0,
    MNDeviceTypeW001B,
    MNDeviceTypeW001C,
    MNDeviceTypeW002A,
    MNDeviceTypeW002B,
    MNDeviceTypeW002C,
    MNDeviceTypeW002D,
    MNDeviceTypeW002E,
    MNDeviceTypeW002F,
    MNDeviceTypeW002G,
    MNDeviceTypeW079A,
    MNDeviceTypeW007A,
    MNDeviceTypeW007C,
    MNDeviceTypeW032A,
    MNDeviceTypeW027B,
    MNDeviceTypeW077A,
    MNDeviceTypeW034C,
    MNDeviceTypeUnknown //未知类型 不是本公司产品
};

@interface MNDeviceBindingService : NSObject

+ (MNDeviceBindingService *)shareInstance;
+(int)readLocalBLEVersionData:(Byte [])data;
/**
 *  当前是否有绑定的设备
 */
@property (nonatomic,assign,readonly) BOOL hadBindingDevice;
/**
 *  当前绑定的设备类型
 */
@property (nonatomic,assign,setter=resetCurrentDeviceType:) MNDeviceType currentDeviceType;
@property (nonatomic,assign,readonly) UpgradeType upgradeType;  //升级类型



/**
 *  绑定设备
 *
 *  @param success 绑定成功
 *  @param failure 绑定失败
 *  @param binding 等待绑定
 */
- (void)startBindingDeviceWithSuccess:(void(^)(void))success withFailure:(void(^)(NSString *messgae))failure withWaitUserOperation:(void(^)(void))operation;

/**
 *  解绑设备
 *
 *  @param success 解绑成功
 *  @param failure 解绑失败
 */
- (void)unbindWithSuccess:(void(^)(void))success withFailure:(void(^)(NSString *messgae))failure;
/**
 *  获取指定设备类型的所有功能
 *
 *  @param deviceType 设备类型
 *
 *  @return 功能数组 (运动 睡眠 绑定 解绑 固件升级为默认功能 所有设备都有)
 */
- (NSArray *)getDeviceFunctionWithDeviceType:(MNDeviceType)deviceType;

@end
