//
//  MNPutService.h
//  Movnow
//
//  Created by baoyx on 15/4/16.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MNPutService : NSObject
+(MNPutService *)shareInstance;
/**
 *  绑定网络日志
 */
-(void)bindingLog;
/**
 *  解绑网络日志
 */
-(void)unBindingLog;
/**
 *  固件升级日志
 */
-(void)updateFirmwareLog;
/**
 *  固件下载日志
 */
-(void)downloadFirmwareLog;
/**
 *  同步睡眠日志
 *
 *  @param sleeps 睡眠数据数组
 */
-(void)synchronousSleepLog:(NSArray *)sleeps;
/**
 *  同步运动日志
 *
 *  @param step 运动数据数组
 */
-(void)synchronousStepLog:(NSArray *)steps;
@end
