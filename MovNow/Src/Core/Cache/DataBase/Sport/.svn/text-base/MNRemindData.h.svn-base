//
//  MNRemindData.h
//  Movnow
//
//  Created by baoyx on 15/4/28.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MNRemindData : NSObject
/**
 *  查询喝水提醒
 *
 *  @return 喝水提醒数组(HH:mm)
 */
-(NSArray *)selectDrinkRemind;


/**
 *  查询闹钟提醒
 *
 *  @return 闹钟提醒数组(HH:mm)
 */
-(NSArray *)selectClockReminds;

/**
 *  更新提醒功能
 *
 *  @param drinkReminds 喝水提醒(单次提醒)
 *  @param clockReminds 起床提醒(闹钟提醒)
 */
-(void)updateWithDrinkRemind:(NSArray *)drinkReminds withClockRemind:(NSArray *)clockReminds;

@end
