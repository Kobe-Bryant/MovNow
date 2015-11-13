//
//  MNMovementService.h
//  Movnow
//
//  Created by HelloWorld on 15/4/14.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//  所有运动数据操作相关的服务类

#import <Foundation/Foundation.h>
@class MNStepViewModel;

@protocol MNMovementServiceDelegate<NSObject>
-(void)changeStepViewmodel:(MNStepViewModel *)model;
@end
@interface MNMovementService : NSObject
@property (nonatomic,assign) id<MNMovementServiceDelegate>delegate;
@property (nonatomic,copy,readonly) NSDate *stepLastSyncTime;
@property (nonatomic,strong,readonly) MNStepViewModel *stepViewModel;
@property (nonatomic,assign,readonly) NSInteger goalStep;
+ (MNMovementService *)shareInstance;
/**
 *  同步计步数据(蓝牙连接状态)
 *
 *  @param success  同步计步成功
 *  @param progress 同步计步进度
 *  @param failure  同步计步失败
 */
-(void)startSyncStepDataWithSuccess:(void(^)(void))success withProgress:(void(^)(int progress))progress withFailure:(void(^)(NSString *reason))failure;

/**
 * 同步计步数据(已经绑定,打开APP)
 *
 *  @param success  同步计步成功
 *  @param progress 同步计步进度
 *  @param failure  同步计步失败
 */
-(void)startDisconnectSyncStepDataWithSuccess:(void(^)(void))success withProgress:(void(^)(int progress))progress withFailure:(void(^)(NSString *reason))failure;
/**
 *  存储临时计步数据  APP退出的时候
 */
-(void)saveTemporaryStep;

/**
 *  用户设置运动目标接口
 *
 *  @param steps   步数
 *  @param success 成功回调
 *  @param failure 失败回调
 */
- (void)setMovementTargetWithSteps:(NSInteger)steps success:(CoreSuccess)success failure:(CoreFailure)failure;
/**
 *  下载网络计步数据(目前时间最大跨度为30天)
 *
 *  @param startData 开始时间  yyyyMMdd
 *  @param endData   结束时间  yyyyMMdd
 *  @param success   下载成功
 */
- (void)downNetMovementDateWithStartData:(NSString *)startData withEndData:(NSString *)endData withSuccess:(CoreSuccess)success;
/**
 *  下载最近一个月的计步数据
 *
 *  @param success 下载成功
 */
-(void)downLastMonthMovementDateWithSuccess:(CoreSuccess)success;
/**
 *  根据运动数据模型的内容获取分享的文字
 */
-(NSString *)getShareTextWithStepsModel:(MNStepViewModel *)model;

-(void)unBindingSyncTime;
/**
 *  获取行走里程
 *
 *  @param steps 步数
 *
 *  @return 行走里程
 */
+(CGFloat)getMileageWithSteps:(NSInteger)steps;
/**
 *  获取卡路里
 *
 *  @param steps 步数
 *
 *  @return 卡路里
 */
+(CGFloat)getCalorieWithSteps:(NSInteger)steps;

@end
