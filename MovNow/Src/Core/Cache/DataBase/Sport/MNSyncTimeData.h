//
//  MNSyncTimeData.h
//  Movnow
//
//  Created by baoyx on 15/4/23.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, SyncType){
    syncTypeStep= 0, //同步计步
    syncTypeSleep //同步睡眠
};
@interface MNSyncTimeData : NSObject
/**
 *  更新同步不同类型活动的时间
 *
 *  @param type 活动类型
 */
-(void)updateSyncTimeWithSyncType:(SyncType)type withSyncTime:(NSDate *)timeDate;
/**
 *  查询不同类型活动最近更新时间
 *
 *  @param type 活动类型
 *
 *  @return 活动最近更新时间
 */
-(NSDate *)selectSyncTimeWithyncType:(SyncType)type;

-(void)deleteAll;

@end
