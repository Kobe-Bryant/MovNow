//
//  MovnowHeader.h
//  Movnow
//
//  Created by HelloWorld on 15/4/13.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//

#ifndef Movnow_MovnowHeader_h
#define Movnow_MovnowHeader_h

#import "UIColor+Util.h"

//是否第一次启动APP
#define IS_FIRST @"is_First"
//是否是刚刚注册
#define IS_REGISTER_JUSTNOW @"is_Register_JustNow"
//当前是否是英制
#define IS_BRITISH_SYSTEM @"_is_British_System"
//当前是否开启防丢
#define IS_LOST_SWITCH_ON @"is_lost_switch_on"
//当前是否开启来电提醒
#define IS_PHONECALL_SWITCH_ON @"is_phoneCall_switch_on"

//设备信息已经发生改变
#define MAINVC_NEED_BUILDUI_AGAIN @"mainVC_need_buildUI_again"
//食物数组
#define CALORIE_ARRAY_DATA @"calorie_array_data"

// 核心层的回调处理
typedef void(^CoreSuccess)(id result);
typedef void(^CoreFailure)(id reason);
typedef void(^CoreEmptyCallBack)();

typedef NS_ENUM(NSInteger, BottomBtnClickType){ //主页面底部按钮的点击类型
    BottomBtnClickTypeBindingDevice,
    BottomBtnClickTypeConnectBlueToothAgain
};

typedef NS_ENUM(NSInteger, MovementViewShowType){
    MovementViewShowTypeMainDeviceVC = 0, //主界面
    MovementViewShowTypeDayDetailVC //日记录详情页
};

typedef NS_ENUM(NSInteger, SleepViewShowType){
    SleepViewShowTypeMainDeviceVC = 0, //主界面
    SleepViewShowTypeDayDetailVC //日记录详情页
};

typedef  NS_ENUM(NSInteger,UpgradeType){
    UpgradeTypeNo = 0,//不支持升级
    UpgradeTypeOld,   //Q1升级
    UpgradeTypeNew,  //Q2升级
    UpgradeTypeLibOta, //昆电科OTA升级
    UpgradeTypeDialogOta, //dialogOTA升级
};

typedef NS_ENUM(NSInteger, StepsSyncType){ //同步步数的类型
    StepsSyncTypeLaunchJustNow, //刚刚启动的类型
    StepsSyncTypePullDown //主动下拉的类型
};

typedef NS_ENUM(NSInteger, HistoryDataType){
    HistoryDataTypeMovement = 0, //运动历史数据
    HistoryDataTypeSleep, //睡眠历史数据
    HistoryDataTypeHeartRate //心率历史数据
};

//拼接图片路径
#define _Image_Guide_Prefix @"MN_GUIDE_"
#define _Image_Prefix @"MN_"

#define IMAGE_NAME(name) [_Image_Prefix stringByAppendingString:name]

#define _App_Key @"q2_ios"
#define _App_Secret @"wkl521456988992"
#define _Version @"2.0.0"

#ifdef DEBUG // 调试
#define _Web_Site @"http://113.108.103.150:8985/rest"
#define _UploadPicUrl @"http://113.108.103.150:8095/upload/file.do?method=file.upload"
#define _API_BRACELET_PATH @"http://113.108.103.150:8985/Bracelet"

//#define _Web_Site @"http://192.168.0.6:8985/rest"
//#define _UploadPicUrl @"http://113.108.103.150:8095/upload/file.do?method=file.upload"
//#define _API_BRACELET_PATH @"http://113.108.103.150:8985/Bracelet"
#else       // 发布打包
#define _Web_Site @"http://q.movnow.com/rest"  //基础数据地址
#define _UploadPicUrl @"http://upload.movnow.com/upload/file.do?method=file.upload" //头像上传地址
#define _API_BRACELET_PATH @"http://dataq.movnow.com/Bracelet"  // 文件数据地址
#endif

#define USER_EMAIL @"User_Email"
#define USER_PWD @"User_pwd"

#define SEARCH_INTERVAL 10               // 搜索设备时长
#define CONNECT_INTERVAL 30               //连接蓝牙设备超时
#define SEND_INTERVAL    5                //发送命令超时
#define MAXSENDTIMES 2                      //重发次数

#define BLE_VERSION_DATA_PACKET_LENGTH 1024 // ble设备固件升级 大包长度
#define BLE_VERSION_TIME_OUT           3    // ble的超时判断时间3秒 app设置ble设备参数
#define BLE_VERSION_RESEND_TIMES       5    // ble的超时最大次数 app设置ble设备参数
#define LOCK_DURATION  30        //单位 s  锁定持续时间
#define LOST_DURATION  1000      //单位 ms  防丢持续时间

//跳转到登陆界面
#define JUMP_TO_LOGIN   [self presentViewController:[[MNBaseNavigationCtrl alloc]initWithRootViewController: [[MNLoginViewCtrl alloc]initWithNibName:@"MNLoginViewCtrl" bundle:nil]] animated:YES completion:nil];

//主界面四个按钮排版相关
#define BtnSpace 7
#define BothSidesSpaceWithCount(count) (SCREEN_WIDTH - count * 50 - BtnSpace *(count - 1))/2

//检查是否为NULL
#define CHECK_NULL(object) ([object isEqual:[NSNull null]]?nil:object)

#ifdef DEBUG // 调试
#define DLog(fmt, ...) {NSLog((@"%s [Line %d] DEBUG:--->" fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);}
#else       // 发布打包
#define DLog(...)
#endif

//所有设备的默认功能
#define MOVEMENT @"MOVEMENT"
#define SLEEP @"SLEEP"
#define FIRMWARE @"FIRMWARE"
#define BINDING @"BINDING"
#define UNBINDING @"UNBINDING"

#define bleDiscoveredCharacteristicsNoti           @"ble-DiscoveredCharasNoti"
//NSUserDefaults
#define U_DEFAULTS [NSUserDefaults standardUserDefaults]

//统一的cell背景色
#define CELL_BG_COLOR [UIColor whiteColor]
//统一的分割线颜色
#define SEPARATOR_BG_COLOR [UIColor colorWith8BitRed:1.f green:1.f blue:1.f]
//统一的控制器背景色
#define CTRL_BG_COLOR [UIColor colorWith8BitRed:240 green:240 blue:240]
//统一的导航栏背景色
#define NAV_BG_COLOR [UIColor colorWith8BitRed:101 green:145 blue:182]
//统一的导航栏文字颜色
#define NAV_TEXT_COLOR [UIColor colorWith8BitRed:23 green:61 blue:90]

//统一的圆角
#define COMMON_CORNER 5.f

//统一的标题文字大小
#define TITLE_FONT [UIFont systemFontOfSize:15]
//统一的副标题文字大小
#define SUBTITLE_FONT [UIFont systemFontOfSize:13]

//统一的动画时长
#define kAnimationInterval 0.3

//统一的提示语时长
#define kAlertWordsInterval 1.5

//屏幕宽高
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width

// View 坐标(x,y)和宽高(width,height)
#define X(v)                    (v).frame.origin.x
#define Y(v)                    (v).frame.origin.y
#define WIDTH(v)                (v).frame.size.width
#define HEIGHT(v)               (v).frame.size.height

#define MIN_X(v)                 CGRectGetMinX((v).frame)
#define MIN_Y(v)                 CGRectGetMinY((v).frame)

#define MID_X(v)                 CGRectGetMidX((v).frame)
#define MID_Y(v)                 CGRectGetMidY((v).frame)

#define MAX_X(v)                 CGRectGetMaxX((v).frame)
#define MAX_Y(v)                 CGRectGetMaxY((v).frame)

// 当前系统版本
#define CURRENT_VERSIONS  ([[[UIDevice currentDevice] systemVersion] floatValue])

// 当前语言
#define CURRENT_LANGUAGE  ([[NSLocale preferredLanguages] objectAtIndex:0])

// 断点Assert
#define MOV_ASSERT(condition, ...)\
                                                        \
                                                    do {\
                                                        if (!(condition))\
                                                            {\
                                                                [[NSAssertionHandler currentHandler]\
                                                                handleFailureInFunction:[NSString stringWithFormat:@"< %s >", __PRETTY_FUNCTION__]\
                                                                file:[[NSString stringWithUTF8String:__FILE__] lastPathComponent]\
                                                                lineNumber:__LINE__\
                                                                description:__VA_ARGS__];\
                                                            }\
                                                    } while(0)


#endif
