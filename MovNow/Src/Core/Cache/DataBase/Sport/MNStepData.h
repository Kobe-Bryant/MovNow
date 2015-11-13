//
//  MNStepData.h
//  Movnow
//
//  Created by baoyx on 15/4/16.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//

/**
 *  运动数据库
 */
#import <Foundation/Foundation.h>

@interface MNStepData : NSObject
/**
 *  运动数据修改
 *
 *  @param MNStepModels 运动模型数组
 */
-(void)updateWithMNStepModels:(NSArray *)MNStepModels;

/**
 *  查询总步数
 *
 *  @param sportTime 时间(yyyyMMdd)
 *
 *  @return 总步数
 */
-(int)selectTotoalStepWithTime:(NSInteger)sportTime;

/**
 *  查询计步所有时间数据
 *
 *  @return 所有时间数据
 */
-(NSSet *)selectFromStepWithAllTime;

/**
 *  查询计步详情(序号1~48和序号7~43)
 *
 *  @param date 时间(yyyyMMdd)
 *
 *  @return 计步详情
 */
-(NSDictionary *)selectStepDatailsWithDate:(NSInteger)date;


/**
 *  查询周运动详情
 *
 *  @param startDate 开始时间
 *  @param endDate   结束时间
 *
 *  @return 周运动详情
 */
-(NSDictionary *)selectWeekDatailsWithStartDate:(NSInteger)startDate withEndData:(NSInteger)endDate;

/**
 *  查询月运动详情
 *
 *  @param startDate 开始时间
 *  @param endDate   结束时间
 *
 *  @return 月运动详情
 */

-(NSDictionary *)selectMonthDatailsWithStartDate:(NSInteger)startDate withEndData:(NSInteger)endDate;
@end
