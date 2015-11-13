//
//  MNFirmwareService.h
//  Movnow
//
//  Created by baoyx on 15/5/4.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//   所有与设备固件升级的服务类

#import <Foundation/Foundation.h>

@interface MNFirmwareService : NSObject
+(MNFirmwareService*)shareInstance;
/**
 *  检查是否有最新固件版本
 *
 *  @return 是否有最新固件版本
 */
-(BOOL)isLatestFirmware;


/**
 *  开始固件升级
 *
 *  @param no         不用升级(最新固件)
 *  @param progress   升级进度
 *  @param initialize 初始化中
 *  @param success    升级成功
 *  @param failure    升级失败
 */
-(void)startUpgradeWithNo:(void(^)(void))no withProgress:(void (^)(int progress))progress withInitialize:(void(^)(void))initialize withSuccess:(CoreFailure)success withFailure:(CoreFailure)failure;
@end
