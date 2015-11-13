//
//  MNSleepViewModel.h
//  Movnow
//
//  Created by baoyx on 15/5/8.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MNSleepViewModel : NSObject
@property (nonatomic,copy,readonly) NSString *sleepDuration;  // 睡眠时长(yyyy:MM:dd)
@property (nonatomic,copy,readonly) NSString *deepSleepDuration; //深睡时长(yyyy:MM:dd)
@property (nonatomic,copy,readonly) NSString *lightSleepDuration; //浅睡时长(yyyy:MM:dd)
@property (nonatomic,assign,readonly) NSInteger percent;        //百分比

/**
 *  历史模型
 *
 *  @param time 历史时间(yyyyMMdd)
 *
 *  @return 模型
 */
-(instancetype)initHistoryWithTime:(NSInteger)time;
/**
 *  当天模型
 *
 *  @return 模型
 */
-(instancetype)initToday;
/**
 *  更新当天睡眠数据
 */
-(void)updateTotalSleep;
@end
