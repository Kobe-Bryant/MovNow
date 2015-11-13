//
//  MNRemindService.h
//  Movnow
//
//  Created by HelloWorld on 15/4/14.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//  所有与提醒相关的服务类

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,RemindType)
{
    RemindTypeDrink = 0,  //喝水提醒
    RemindTypeSedentary,  //久坐提醒
    RemindTypeClock,      //闹钟提醒
    RemindTypeOnce,      //事件提醒(单次提醒)
};

typedef NS_ENUM(NSInteger,WarnEventType)
{
    WarnEventTypeOpen = 0, //打开
    WarnEventTypeClose,    //关闭
};

typedef NS_ENUM(NSInteger,OnceType) {
    OnceTypeClose= 0,   //过期
    OnceTypeOpen
};

@interface MNRemindService : NSObject

@property (nonatomic,assign)RemindType remindTpye;// 提醒类型
@property (nonatomic,strong,readonly) NSMutableArray *drinkReminds;//  喝水提醒数组  HH:mm
@property (nonatomic,strong,readonly) NSMutableArray *clockReminds;//  闹钟提醒数组(起床提醒)HH:mm
@property (nonatomic,strong,readonly) NSMutableArray *eventReminds;//  事件提醒数组(单次提醒)(NSDictionary =>@"time"(格式:HH:mm),@"date"(格式:yyyyMMddHHmm),@"type"(OnceType))
@property (nonatomic,copy)NSString *bmi;// 测试BMI的值

@property (nonatomic,copy,readonly) NSString *sedentary;//久坐提醒下标文字
@property (nonatomic,assign,readonly) WarnEventType openType;
@property (nonatomic,copy,readonly) NSNumber *interval;//久坐提醒时间间隔

+ (MNRemindService *)shareInstance;

/**
 *  刷新事件提醒数组(获取事件提醒数组前更新一下)
 */
-(void)refreshEventReminds;
/**
 *  新增闹钟(起床)提醒
 *
 *  @param hour    生效小时
 *  @param min     生效分钟
 *  @param success 提醒成功
 *  @param failure 提醒失败
 */
-(void)addClockRemindWithHour:(int)hour withMin:(int)min  withSuccess:(void(^)(void))success withFailure:(void(^)(NSString *messgae))failure;

/**
 *  删除闹钟(起床)提醒
 *
 *  @param hour    失效小时
 *  @param min     失效分钟
 *  @param success 删除成功
 *  @param failure 删除失败
 */
-(void)deleteClockRemindWithHour:(int)hour withMin:(int)min  withSuccess:(void(^)(void))success withFailure:(void(^)(NSString *messgae))failure;

/**
 * 新增喝水提醒
 *
 *  @param hour    生效小时
 *  @param min     生效分钟
 *  @param success 提醒成功
 *  @param failure 提醒失败
 */
-(void)addDrinkRemindWithHour:(int)hour withMin:(int)min  withSuccess:(void(^)(void))success withFailure:(void(^)(NSString *messgae))failure;

/**
 *  删除喝水提醒
 *
 *  @param hour    失效时间
 *  @param min     失效分钟
 *  @param success 删除成功
 *  @param failure 删除失败
 */

-(void)deleteDrinkRemindWithHour:(int)hour withMin:(int)min  withSuccess:(void(^)(void))success withFailure:(void(^)(NSString *messgae))failure;
/**
 *  提醒设置(喝水、闹钟、单次(事件))
 *
 *  @param remindType 提醒类型
 *  @param eventType  事件类型(打开、关闭)
 *  @param hour       生效小时
 *  @param min        生效分钟
 *  @param success    提醒成功
 *  @param failure    提醒失败
 */
-(void)startWithRemindType:(RemindType)remindType withWarnEventType:(WarnEventType)eventType withHour:(int)hour withMin:(int)min  withSuccess:(void(^)(void))success withFailure:(void(^)(NSString *messgae))failure;

/**
 *  久坐提醒设置
 *
 *  @param eventType 事件类型(打开、关闭)
 *  @param duration  持续时间(分钟)
 *  @param startHour 开始小时
 *  @param startMin  开始分钟
 *  @param EndHour   结束小时
 *  @param EndMin    结束分钟
 *  @param success   久坐提醒设置成功
 *  @param failure   久坐提醒设置失败
 */
-(void)SedentaryWarnWithWarnEventType:(WarnEventType)eventType withDuration:(int)duration withStartHour:(int)startHour withStartMin:(int)startMin withEndHour:(int)EndHour withEndMin:(int)EndMin withSuccess:(void(^)(void))success withFailure:(void(^)(NSString *messgae))failure;

/**
 *保存闹钟、喝水提醒
 */
-(void)saveReminds;

@end
