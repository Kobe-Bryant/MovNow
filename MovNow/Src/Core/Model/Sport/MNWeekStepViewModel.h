//
//  MNWeekMonthViewModel.h
//  Movnow
//
//  Created by baoyx on 15/5/18.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MNWeekStepViewModel : NSObject
@property (nonatomic,readonly,copy) NSArray *steps;  //计步数组
@property (nonatomic,readonly,assign)NSInteger maxStep; //最大计步
@property (nonatomic,readonly,assign)NSInteger sumStep; //总计步
@property (nonatomic,readonly,copy) NSArray *mileages; //里程数组
@property (nonatomic,readonly,assign) NSInteger maxMileage; //最大里程
@property (nonatomic,readonly,assign) NSInteger sumMileage; //总里程
@property (nonatomic,readonly,copy) NSArray *calories; //卡路里数组;
@property (nonatomic,readonly,assign)NSInteger maxCalorie; //最大卡路里
@property (nonatomic,readonly,assign)NSInteger sumCalorie; //总卡路里
@property (nonatomic,readonly,copy) NSArray *movementDetails; //运动详情数组
@property (nonatomic,readonly,copy) NSArray *maxMovementDetailsStep; //运动详情每天的最大值
/**
 *  周记录模型
 *
 *  @param startDate 开始时间
 *  @param endDate   结束时间
 *
 *  @return 周模型
 */
-(instancetype)initWeekWithStartDate:(NSDate *)startDate withEndDate:(NSDate *)endDate;
@end
