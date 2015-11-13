//
//  MNStepViewModel.h
//  Movnow
//
//  Created by baoyx on 15/5/8.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MNStepViewModel : NSObject
@property (nonatomic,strong,readonly) NSString *steps;     //总步数
@property (nonatomic,assign,readonly) NSInteger percent;  //百分比
@property (nonatomic,assign,readonly) CGFloat mileage;    //里程
@property (nonatomic,assign,readonly) CGFloat calorie;    //卡路里
@property (nonatomic,copy,readonly) NSArray *allDaystepDetails;  //步数详情 1~48
@property (nonatomic,assign,readonly) NSInteger allDayMaxStep;  //  1~48 最大值
@property (nonatomic,copy,readonly) NSArray *diurnalstepDetails;  //步数详情 7~43
@property (nonatomic,assign,readonly) NSInteger diurnalMaxStep; //  7~43 最大值
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
 *  当天模型更新目标步数
 *
 *  @param goalStep 目标步数
 */
-(void)updateWithGoalStep:(NSInteger)goalStep;
/**
 *  当天模型更新总步数
 */
-(void)updateTotalStep;

/**
 *  当天模型更新临时步数
 *
 *  @param temporaryStep 临时步数
 */
-(void)updateWithTemporaryStep:(NSInteger)temporaryStep;
@end
