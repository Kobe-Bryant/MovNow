//
//  AppDelegate.m
//  Movnow
//
//  Created by HelloWorld on 15/4/13.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//

#import "AppDelegate.h"
#import "MNGuideViewCtrl.h"
#import "MNDeviceMainViewCtrl.h"
#import "MNUserService.h"
#import "QBleClient.h"
#import "MNFirmwareModel.h"
#import "MNUserModel.h"
#import "MNMovementService.h"
#import "MNRemindService.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    //启动APP直接设置蓝牙代理
    [[qBleClient sharedInstance] startBle];
    
    //注册分享平台
    [WXApi registerApp:@"wx42f9925e5e059959"];
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:@"4018092013"];
    
    //改变状态栏颜色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //默认为正常登陆
    [U_DEFAULTS setObject:@"0" forKey:IS_REGISTER_JUSTNOW];
    
    //判断是否第一次启动
    if (![U_DEFAULTS objectForKey:IS_FIRST]) {
        
        [U_DEFAULTS setObject:IS_FIRST forKey:IS_FIRST];
        //进入引导页
        MNGuideViewCtrl *guideVC = [[MNGuideViewCtrl alloc]init];
        guideVC.pushType = GuideVcDismissTypeFirstLaunch;
        self.window.rootViewController = guideVC;
        
        //判断当前的语言环境 确定是否显示英制
        if ([[MNLanguageService shareInstance] getCurrentLanguage] == CurrentLanguageTypeChineseSimple || [[MNLanguageService shareInstance] getCurrentLanguage] == CurrentLanguageTypeChineseTraditional) {
            [U_DEFAULTS setObject:@"0" forKey:IS_BRITISH_SYSTEM];
        }else{
            [U_DEFAULTS setObject:@"1" forKey:IS_BRITISH_SYSTEM];
        }
        
    }else{
        //进入主页
        self.window.rootViewController = [[MNBaseNavigationCtrl alloc]initWithRootViewController:[[MNDeviceMainViewCtrl alloc]initWithNibName:@"MNDeviceMainViewCtrl" bundle:nil]];
    }
    
    [U_DEFAULTS synchronize];
    
    return YES;
}

#pragma mark - APP的生命周期
- (void)applicationWillResignActive:(UIApplication *)application
{
    DLog(@"APP即将变的不活跃");
    
    [[MNFirmwareModel sharestance] saveCache];
    [[MNUserModel shareInstance] saveCache];
    [[MNMovementService shareInstance] saveTemporaryStep];
    [[MNRemindService shareInstance] saveReminds];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    DLog(@"APP已经退出到后台");
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    DLog(@"APP即将恢复到前台");
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    DLog(@"APP已经变的活跃");
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    DLog(@"APP即将被销毁");
    
    [[MNFirmwareModel sharestance] saveCache];
    [[MNUserModel shareInstance] saveCache];
    [[MNMovementService shareInstance] saveTemporaryStep];
    [[MNRemindService shareInstance] saveReminds];
}

#pragma mark - 分享平台代理
-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [WeiboSDK handleOpenURL:url delegate:self];
    return [WXApi handleOpenURL:url delegate:self];
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [WeiboSDK handleOpenURL:url delegate:self];
    return [WXApi handleOpenURL:url delegate:self];
}

#pragma mark WeiboSDKDelegate
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    DLog(@"新浪微博请求回调 is %@",request.userInfo);
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    DLog(@"新浪微博响应回调 is %@",response.userInfo);
}

#pragma mark WXApiDelegate
-(void) onReq:(BaseReq*)req
{
    DLog(@"微信请求回调的请求类型 is %d",req.type);
}

-(void) onResp:(BaseResp*)resp
{
    DLog(@"微信响应回调的错误提示 is %@",resp.errStr);
}

@end