//
//  MNHistoryForDayDetailViewCtrl.h
//  Movnow
//
//  Created by LiuX on 15/5/13.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//

#import "MNBaseViewCtrl.h"
#import "MNStepViewModel.h"
#import "MNSleepViewModel.h"

@interface MNHistoryForDayDetailViewCtrl : MNBaseViewCtrl

/**
 *  历史数据类型
 */
@property (nonatomic,assign) HistoryDataType historyDataType;
/**
 *  当前选中的日期
 */
@property (nonatomic,strong) NSDate *currentSelectedDate;

@property (nonatomic,strong) MNStepViewModel *currentStepsModel;
@property (nonatomic,strong) MNSleepViewModel *currentSleepModel;

@end
