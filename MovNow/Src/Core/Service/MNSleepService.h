//
//  MNSleepService.h
//  Movnow
//
//  Created by HelloWorld on 15/4/14.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//  所有与睡眠相关的服务类

#import <Foundation/Foundation.h>
@class MNSleepViewModel;
@protocol MNSleepServiceDelegate<NSObject>
-(void)changeSleepViewModel:(MNSleepViewModel *)model;
@end
@interface MNSleepService : NSObject
@property (nonatomic,copy,readonly) NSDate *sleepLastSyncTime;
@property (nonatomic,strong,readonly) MNSleepViewModel *sleepViewModel;
@property (nonatomic,assign) id<MNSleepServiceDelegate>delegate;
+ (MNSleepService *)shareInstance;
-(void)startSyncSleepDataWithSuccess:(void(^)(void))success withProgress:(void(^)(int progress))progress withFailure:(void(^)(NSString *reason))failure;
/**
 *  下载网络睡眠数据(目前时间最大跨度为30天)
 *
 *  @param startData 开始时间  yyyyMMdd
 *  @param endData   结束时间  yyyyMMdd
 *  @param success   下载成功
 */
- (void)downNetSleepDateWithStartData:(NSString *)startData withEndData:(NSString *)endData withSuccess:(CoreSuccess)success;

/**
 *  下载最近一个月的计步数据
 *
 *  @param success 下载成功
 */
-(void)downLastMonthSleepDateWithSuccess:(CoreSuccess)success;
@end
