//
//  MNSleepModel.h
//  Movnow
//
//  Created by baoyx on 15/4/16.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
@interface MNSleepModel : JSONModel
@property (nonatomic,readonly,copy) NSNumber *userId;  //用户id
@property (nonatomic,readonly,copy) NSString *deviceId; //手环设备唯一识别码
@property (nonatomic,copy) NSString *dateTime; //睡眠日期  yyyyMMdd
@property (nonatomic,copy) NSNumber *startTime;  //睡眠开始时间 0~1440
@property (nonatomic,copy) NSNumber *sleepDuration;//持续时间
@property (nonatomic,copy) NSNumber *sleepState;//睡眠状态  (0~5，0表示深睡，1~5表示浅睡)
@property (nonatomic,readonly,copy)NSString *deviceType; // 设备类型
@end
