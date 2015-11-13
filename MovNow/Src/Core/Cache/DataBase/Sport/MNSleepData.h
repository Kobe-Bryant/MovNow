//
//  MNSleepData.h
//  Movnow
//
//  Created by baoyx on 15/4/16.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//
/**
 *  睡眠数据库
 userId 用户id,deviceId 设备id,dateTime 日期,startTime 开始时间(0~1440),sleepDuration 持续时间,sleepState 睡眠状态(0~5，0表示深睡，1~5表示浅睡)
 
 */

#import <Foundation/Foundation.h>

@interface MNSleepData : NSObject
/**
 *  睡眠数据修改
 *
 *  @param sleep MNSleepModel模型数组
 */
-(void)updateWithMNSleepModels:(NSArray *)MNSleepModels;
/**
 *  查询睡眠总时长、深睡时长和浅睡时长
 *
 *  @param time 时间(yyyyMMdd)
 *
 *  @return sleepDuration 总时长  deepSleepDuration 深睡时长  lightSleepDuration 浅睡时长
 */
-(NSDictionary *)selectSleepWithTime:(NSInteger)time;

/**
 *  查询计步所有时间数据
 *
 *  @return 所有时间数据
 */
-(NSSet *)selectFromSleepWithAllTime;

@end
