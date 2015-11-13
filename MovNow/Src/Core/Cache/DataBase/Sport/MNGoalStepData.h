//
//  MNGoalStepsData.h
//  Movnow
//
//  Created by baoyx on 15/4/22.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MNGoalStepData : NSObject
/**
 *  更新目标步数
 *
 *  @param goalStep 目标步数
 */
-(void)updateWithGoalStep:(NSInteger)goalStep;
/**
 *  查询目标步数
 *
 *  @param dataTime 时间(yyyyMMdd)
 *
 *  @return 目标步数
 */
-(NSInteger)selectGoalStep:(NSInteger)dataTime;
@end
