//
//  MNDeviceMainViewCtrl.m
//  Movnow
//
//  Created by LiuX on 15/4/21.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//

#import "MNDeviceMainViewCtrl.h"
#import "MNUserService.h"
#import "MNSettingListViewCtrl.h"
#import "MNUserKeyChain.h"
#import "MNDeviceBindingViewCtrl.h"
#import "QBleClient.h"
#import "MNDeviceBindingService.h"
#import "MNDrk_GetupViewCtrl.h"
#import "MNSedentaryViewCtrl.h"
#import "MNBMIViewCtrl.h"
#import "MNRemindService.h"
#import "MNMainMovementView.h"
#import "MNMainSleepView.h"
#import "MNMainRemindView.h"
#import "MJRefresh.h"
#import "MNMovementService.h"
#import "MNSleepService.h"
#import "MNUserInfoViewCtrl.h"
#import "NSDate+Expend.h"
#import "MNCalorieManageViewCtrl.h"
#import "MNHistoryRecordViewCtrl.h"
#import "MNStepViewModel.h"
#import "MNSleepViewModel.h"
#import "MNAdaptAlertView.h"
#import "WeiboSDK.h"
#import "WXApiObject.h"
#import "WXApi.h"
#import "UIImage+Util.h"
#import <Social/Social.h>
#import "MNMovementDetailPopView.h"
#import "MNSleepDetailPopView.h"

@interface MNDeviceMainViewCtrl ()<UIScrollViewDelegate,MNMovementServiceDelegate,bleDisConnectionsDelegate,MNSleepServiceDelegate>

/**
 *  首页模块数组
 */
@property (nonatomic,strong) NSMutableArray *MModuleArr;
/**
 *  上面的背景视图
 */
@property (weak, nonatomic) IBOutlet UIView *MTopBgView;
/**
 *  设置菜单按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *MSettingListBtn;
/**
 *  历史记录按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *MHistoryBtn;
/**
 *  运动按钮
 */
@property (nonatomic, strong) UIButton *MMovementBtn;
/**
 *  睡眠按钮
 */
@property (nonatomic, strong) UIButton *MSleepBtn;
/**
 *  心率按钮
 */
@property (nonatomic, strong) UIButton *MHeartRateBtn;
/**
 *  提醒按钮
 */
@property (nonatomic, strong) UIButton *MRemindBtn;
/**
 *  数据展示标签
 */
@property (weak, nonatomic) IBOutlet UILabel *MTimeShowLabel;
/**
 *  中间的背景滚动视图
 */
@property (weak, nonatomic) IBOutlet UIScrollView *MMediumBgScrollView;
/**
 *  底部的按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *MBottomBtn;
/**
 *  运动视图
 */
@property (nonatomic,strong) MNMainMovementView *MMovementView;
/**
 *  运动视图底部弹出视图
 */
@property (nonatomic,strong) MNMovementDetailPopView *MMovementPopView;
/**
 *  睡眠视图
 */
@property (nonatomic,strong) MNMainSleepView *MSleepView;
/**
 *  睡眠视图底部弹出视图
 */
@property (nonatomic,strong) MNSleepDetailPopView *MSleepPopView;
/**
 *  提醒视图
 */
@property (nonatomic,strong) MNMainRemindView *MRemindView;
/**
 *  当前的步数同步类型
 */
@property (nonatomic,assign) StepsSyncType MCurrentStepsSyncType;
/**
 *  底部按钮点击的操作类型
 */
@property (nonatomic,assign) BottomBtnClickType BottomBtnClickType;
/**
 *  返回按钮的文字
 */
@property (nonatomic,copy) NSString *backItemText;
/**
 *  分享弹出视图(中文环境)
 */
@property (nonatomic,strong) MNAdaptAlertView *MSharePopViewForChinese;
/**
 *  分享弹出视图(国外环境)
 */
@property (nonatomic,strong) MNAdaptAlertView *MSharePopViewForForeign;
/**
 *  运动数据模型
 */
@property (nonatomic,weak) MNStepViewModel *MStepsModel;
/**
 *  睡眠数据模型
 */
@property (nonatomic,weak) MNSleepViewModel *MSleepModel;

@end

@implementation MNDeviceMainViewCtrl

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MAINVC_NEED_BUILDUI_AGAIN object:nil];
}

- (UIButton *)MMovementBtn
{
    if (_MMovementBtn == nil) {
        _MMovementBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _MMovementBtn.tag = 100;
        [_MMovementBtn addTarget:self action:@selector(functionModuleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        //默认选中
        _MMovementBtn.selected = YES;
        
        [self.MTopBgView addSubview:_MMovementBtn];
    }
    return _MMovementBtn;
}

- (UIButton *)MSleepBtn
{
    if (_MSleepBtn == nil) {
        _MSleepBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _MSleepBtn.tag = 200;
        [_MSleepBtn addTarget:self action:@selector(functionModuleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.MTopBgView addSubview:_MSleepBtn];
    }
    return _MSleepBtn;
}

- (UIButton *)MHeartRateBtn
{
    if (_MHeartRateBtn == nil) {
        _MHeartRateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _MHeartRateBtn.tag = 300;
        [_MHeartRateBtn addTarget:self action:@selector(functionModuleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.MTopBgView addSubview:_MHeartRateBtn];
    }
    return _MHeartRateBtn;
}

- (UIButton *)MRemindBtn
{
    if (_MRemindBtn == nil) {
        _MRemindBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _MRemindBtn.tag = 400;
        [_MRemindBtn addTarget:self action:@selector(functionModuleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.MTopBgView addSubview:_MRemindBtn];
    }
    return _MRemindBtn;
}

- (NSMutableArray *)MModuleArr
{
    if (_MModuleArr == nil) {
        _MModuleArr = [NSMutableArray array];
    }
    return _MModuleArr;
}

- (MNMainMovementView *)MMovementView
{
    if (_MMovementView == nil) {
        _MMovementView = [[MNMainMovementView alloc]initWithXibFileAndHeight:HEIGHT(self.MMediumBgScrollView) showType:MovementViewShowTypeMainDeviceVC currentSelectedDate:[NSDate date] calorieClickBlock:^{ //卡路里管理按钮点击事件
            _backItemText = @"卡路里管理";
            [self setUpBackBarItem];
            MNCalorieManageViewCtrl *calorieVC = [[MNCalorieManageViewCtrl alloc]initWithNibName:@"MNCalorieManageViewCtrl" bundle:nil];
            calorieVC.consumeCalorieNumber = [NSNumber numberWithFloat:self.MStepsModel.calorie];
            [self.navigationController pushViewController:calorieVC animated:YES];
        } shareClickBlock:^{ //分享按钮点击事件
            if ([[MNLanguageService shareInstance] getCurrentLanguage] == CurrentLanguageTypeChineseSimple || [[MNLanguageService shareInstance] getCurrentLanguage] == CurrentLanguageTypeChineseTraditional) { //中文环境
                [self.MSharePopViewForChinese show];
            }else{ //国外环境
                [self.MSharePopViewForForeign show];
            }
        } bottomClickBlock:^{
            [self.MMovementPopView showSelf];
        }];
    }
    
    return _MMovementView;
}

- (MNMovementDetailPopView *)MMovementPopView
{
    if (_MMovementPopView == nil) {
        _MMovementPopView = [[MNMovementDetailPopView alloc]initWithXibFileAndShowType:MovementViewShowTypeMainDeviceVC currentSelectedDate:[NSDate date]];
    }
    return _MMovementPopView;
}

- (MNMainSleepView *)MSleepView
{
    if (_MSleepView == nil) {
        _MSleepView = [[MNMainSleepView alloc]initWithXibFileAndHeight:HEIGHT(self.MMediumBgScrollView) showType:SleepViewShowTypeMainDeviceVC currentSelectedDate:[NSDate date]  bottomClickBlock:^{
            [self.MSleepPopView showSelf];
        }];
    }
    return _MSleepView;
}

- (MNSleepDetailPopView *)MSleepPopView
{
    if (_MSleepPopView == nil) {
        _MSleepPopView = [[MNSleepDetailPopView alloc]initWithXibFileAndShowType:SleepViewShowTypeMainDeviceVC currentSelectedDate:[NSDate date]];
    }
    return _MSleepPopView;
}

- (MNMainRemindView *)MRemindView
{
    if (_MRemindView == nil) {
        _MRemindView = [[MNMainRemindView alloc]initWithXibFileAndHeight:HEIGHT(self.MMediumBgScrollView) clickBlock:^(MainRemindBtnClickType type) {
            switch (type) {
                case MainRemindBtnClickTypeDrink: //喝水
                {
                    _backItemText = @"喝水提醒";
                    [self setUpBackBarItem];
                    
                    [MNRemindService shareInstance].remindTpye = RemindTypeDrink;
                    MNDrk_GetupViewCtrl *drinkVC = [[MNDrk_GetupViewCtrl alloc] init];
                    [self.navigationController pushViewController:drinkVC animated:YES];
                }
                    break;
                case MainRemindBtnClickTypeGetUp: //起床
                {
                   _backItemText = @"起床提醒";
                    [self setUpBackBarItem];
                    
                    [MNRemindService shareInstance].remindTpye = RemindTypeClock;
                    MNDrk_GetupViewCtrl *getUpVC = [[MNDrk_GetupViewCtrl alloc] init];
                    [self.navigationController pushViewController:getUpVC animated:YES];
                }
                    break;
                case MainRemindBtnClickTypeBMI: //体质指数
                {
                    _backItemText = @"体质指数";
                    [self setUpBackBarItem];
                    
                    MNBMIViewCtrl *bmiVC = [[MNBMIViewCtrl alloc] init];
                    [self.navigationController pushViewController:bmiVC animated:YES];
                }
                    break;
                case MainRemindBtnClickTypeSitting: //久坐
                {
                    _backItemText = @"久坐提醒";
                     [self setUpBackBarItem];
                
                    MNSedentaryViewCtrl *sedentaryVC = [[MNSedentaryViewCtrl alloc] init];
                    [self.navigationController pushViewController:sedentaryVC animated:YES];
                }
                    break;
                default:
                    break;
            }
        }];
    }
    return _MRemindView;
}

- (MNAdaptAlertView *)MSharePopViewForChinese
{
    if (_MSharePopViewForChinese == nil) {
        _MSharePopViewForChinese = [[MNAdaptAlertView alloc]initStyleShareMicroBlogAndWeiChatWithBlock:^(MNAdaptAlertView *alertView, int buttonIndex) {
            switch (buttonIndex) {
                case 0: //微博
                {
                    WBMessageObject *message = [WBMessageObject message];
                    message.imageObject = [WBImageObject object];
                    message.imageObject.imageData = UIImagePNGRepresentation([UIImage getCurrentScreen]);
                    message.text = [[MNMovementService shareInstance] getShareTextWithStepsModel:self.MStepsModel];
                    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message];
                    
                    if ([WeiboSDK isWeiboAppInstalled]) { //已安装微博直接分享
                        [WeiboSDK sendRequest:request];
                    } else { //未安装微博提示安装
                        MNAdaptAlertView *weiboInstallAlert = [[MNAdaptAlertView alloc]initStyleWithMessage:NSLocalizedString(@"未安装微博客户端\n是否现在去下载?",nil) andBlock:^(MNAdaptAlertView *alertView, int buttonIndex) {
                            if (buttonIndex == 1) {
                                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[WeiboSDK getWeiboAppInstallUrl]]];
                            }
                        }];
                        [weiboInstallAlert show];
                    }
                }
                    break;
                case 1: //微信
                {
                    //网址超链接
                    WXWebpageObject *webObj = [WXWebpageObject object];
                    webObj.webpageUrl = [NSString stringWithFormat:@"https://itunes.apple.com/cn/app/zou-ba+/id917599587?mt=8"];
                    
                    WXMediaMessage *message = [WXMediaMessage message];
                    message.title = [[MNMovementService shareInstance] getShareTextWithStepsModel:self.MStepsModel];
                    //message.description = @"微信分享测试";
                    message.mediaObject = webObj;
                    [message setThumbImage:[UIImage imageNamed:IMAGE_NAME(@"icon_120")]];//图片
                    
                    //发送的目标场景 朋友圈
                    SendMessageToWXReq *request = [[SendMessageToWXReq alloc] init];
                    request.bText = NO;
                    request.message = message;
                    request.scene = WXSceneTimeline;
                    
                    if ([WXApi isWXAppInstalled]) { //已安装微信直接分享
                        [WXApi sendReq:request];
                    } else { //未安装微信提示安装
                        MNAdaptAlertView *weixinInstallAlert = [[MNAdaptAlertView alloc]initStyleWithMessage:NSLocalizedString(@"未安装微信客户端\n是否现在去下载？",nil) andBlock:^(MNAdaptAlertView *alertView, int buttonIndex) {
                            if (buttonIndex == 1) {
                                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[WXApi getWXAppInstallUrl]]];
                            }
                        }];
                        [weixinInstallAlert show];
                    }
                }
                    break;
                default:
                    break;
            }
        }];
    }
    return _MSharePopViewForChinese;
}

- (MNAdaptAlertView *)MSharePopViewForForeign
{
    if (_MSharePopViewForForeign == nil) {
        _MSharePopViewForForeign = [[MNAdaptAlertView alloc]initStyleShareFacebookAndTwitterWithBlock:^(MNAdaptAlertView *alertView, int buttonIndex) {
            
            NSString *shareType = nil;
            NSString *shareAlertWords = nil;
            
            switch (buttonIndex) {
                case 0: //Facebook
                {
                    shareType = SLServiceTypeFacebook;
                    shareAlertWords = NSLocalizedString(@"请前往系统设置界面设置Facebook账号", nil);
                }
                    break;
                case 1: //Twitter
                {
                    shareType = SLServiceTypeTwitter;
                    shareAlertWords = NSLocalizedString(@"请前往系统设置界面设置Twitter账号", nil);
                }
                    break;
                default:
                    break;
            }
            
            SLComposeViewController *shareVC = [SLComposeViewController composeViewControllerForServiceType:shareType];
            SLComposeViewControllerCompletionHandler myblock = ^(SLComposeViewControllerResult result){
                if(result == SLComposeViewControllerResultCancelled){
                    DLog(@"分享取消");
                }else{
                    DLog(@"分享成功");
                }
                [shareVC dismissViewControllerAnimated:YES completion:nil];
            };
            shareVC.completionHandler = myblock;
            shareVC.initialText = [[MNMovementService shareInstance] getShareTextWithStepsModel:self.MStepsModel];
            
            if (shareVC == nil) {
                [self.view showHUDWithStr:shareAlertWords hideAfterDelay:kAlertWordsInterval];
            }else{
                [self presentViewController:shareVC animated:YES completion:nil];
            }
        }];
    }
    return _MSharePopViewForForeign;
}

- (MNStepViewModel *)MStepsModel
{
    if (_MStepsModel == nil) {
        _MStepsModel = [MNMovementService shareInstance].stepViewModel;
    }
    return _MStepsModel;
}

- (MNSleepViewModel *)MSleepModel
{
    if (_MSleepModel == nil) {
        _MSleepModel = [MNSleepService shareInstance].sleepViewModel;
    }
    return _MSleepModel;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
    if ([MNUserService shareInstance].isLogin == NO&&![MNUserKeyChain readUserName]&&![MNUserKeyChain readPassWord]) { //没有缓存的账号 不需要自动登录
        JUMP_TO_LOGIN
    }else if ([MNUserService shareInstance].isLogin == NO&&[MNUserKeyChain readUserName]&&[MNUserKeyChain readPassWord]){ //有缓存的账号 需要自动登录
        [[MNUserService shareInstance] autoLoginWithSuccess:^(id result) {
            
            //有缓存的设备信息 自动开始同步运动数据
            if ([MNDeviceBindingService shareInstance].hadBindingDevice == YES) {
                
                self.MCurrentStepsSyncType = StepsSyncTypeLaunchJustNow;
                UIScrollView *movementScrollView = (UIScrollView *)[self.MMediumBgScrollView viewWithTag:1000];
                if (movementScrollView.header.isRefreshing == NO) {
                    [movementScrollView.header beginRefreshing];
                }
            }
        } failure:^(id reason) {
            JUMP_TO_LOGIN
        }];
    }else if ([MNUserService shareInstance].isLogin == YES&&[[U_DEFAULTS objectForKey:IS_REGISTER_JUSTNOW] isEqualToString:@"1"]){ //如果是刚刚注册的用户登陆 直接跳转到用户信息界面
        
        [U_DEFAULTS setObject:@"0" forKey:IS_REGISTER_JUSTNOW];
        [U_DEFAULTS synchronize];
        
        _backItemText = @"个人信息";
        [self setUpBackBarItem];
        [self.navigationController pushViewController:[[MNUserInfoViewCtrl alloc]initWithNibName:@"MNUserInfoViewCtrl" bundle:nil] animated:YES];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self buildUIAgain];
    
    [self resetImages];
    
    [self executeDefaultSetting];
}

#pragma mark - 默认配置
- (void)executeDefaultSetting
{
    //添加两个历史记录弹出视图
    [self.view addSubview:self.MMovementPopView];
    [self.view addSubview:self.MSleepPopView];
    
    //添加一个通知中心的观察者 当设备信息发生变化时 重新布局UI
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mainVCNeedRebuildUI) name:MAINVC_NEED_BUILDUI_AGAIN object:nil];
    
    //底部按钮默认操作类型为 绑定设备
    _BottomBtnClickType = BottomBtnClickTypeBindingDevice;
    
    //展示今天的日期
    self.MTimeShowLabel.text = [NSDate getTimeInfoWithDate:[NSDate date]];
    
    //设置代理
    [MNMovementService shareInstance].delegate = self;
    [MNSleepService shareInstance].delegate = self;
    [qBleClient sharedInstance].bleDisConnectionsDelegate = self;
    
    //默认的运动数据(未同步情况)
    self.MMovementView.movementCircleView.textLabel.text = self.MStepsModel.steps;
    [self.MMovementView.movementCircleView setPercent:self.MStepsModel.percent animated:YES];
    self.MMovementView.currentCalorieLabel.text = [NSString stringWithFormat:@"%.1f",self.MStepsModel.calorie];
    if ([[U_DEFAULTS objectForKey:IS_BRITISH_SYSTEM] isEqualToString:@"1"]) {
        self.MMovementView.currentKmLabel.text = [NSString stringWithFormat:@"%.1f",self.MStepsModel.mileage * 0.6213712];
    }else{
        self.MMovementView.currentKmLabel.text = [NSString stringWithFormat:@"%.1f",self.MStepsModel.mileage];
    }
    
    //默认的睡眠数据(未同步情况)
    self.MSleepView.sleepCircleView.textLabel.text = self.MSleepModel.sleepDuration;
    [self.MSleepView.sleepCircleView setPercent:self.MSleepModel.percent animated:YES];
    self.MSleepView.deepSleepTImeLabel.text = self.MSleepModel.deepSleepDuration;
    self.MSleepView.shallowSleepTImeLabel.text = self.MSleepModel.lightSleepDuration;
}

#pragma mark - 主界面需要重新布局
- (void)mainVCNeedRebuildUI
{
    [self buildUIAgain];
}

#pragma mark 返回文字
- (NSString *)backBarItemText
{
    return NSLocalizedString(_backItemText, nil);
}

#pragma mark - 重设图片
- (void)resetImages
{
    [self.MSettingListBtn setImage:[UIImage imageNamed:IMAGE_NAME(@"btn_menu")] forState:UIControlStateNormal];
    [self.MSettingListBtn setImage:[UIImage imageNamed:IMAGE_NAME(@"btn_menu_press")] forState:UIControlStateHighlighted];
    
    [self.MHistoryBtn setImage:[UIImage imageNamed:IMAGE_NAME(@"btn_calendar")] forState:UIControlStateNormal];
    [self.MHistoryBtn setImage:[UIImage imageNamed:IMAGE_NAME(@"btn_calendar_press")] forState:UIControlStateHighlighted];
    
    [self.MMovementBtn setBackgroundImage:[UIImage imageNamed:IMAGE_NAME(@"main_activity_btn")] forState:UIControlStateNormal];
    [self.MMovementBtn setBackgroundImage:[UIImage imageNamed:IMAGE_NAME(@"main_activity_btn_press")] forState:UIControlStateSelected];
    
    [self.MSleepBtn setBackgroundImage:[UIImage imageNamed:IMAGE_NAME(@"main_sleep_btn")] forState:UIControlStateNormal];
    [self.MSleepBtn setBackgroundImage:[UIImage imageNamed:IMAGE_NAME(@"main_sleep_btn_press")] forState:UIControlStateSelected];
    
    [self.MHeartRateBtn setBackgroundImage:[UIImage imageNamed:IMAGE_NAME(@"main_heartRate_btn")] forState:UIControlStateNormal];
    [self.MHeartRateBtn setBackgroundImage:[UIImage imageNamed:IMAGE_NAME(@"main_heartRate_btn_press")] forState:UIControlStateSelected];
    
    [self.MRemindBtn setBackgroundImage:[UIImage imageNamed:IMAGE_NAME(@"main_remind_btn")] forState:UIControlStateNormal];
    [self.MRemindBtn setBackgroundImage:[UIImage imageNamed:IMAGE_NAME(@"main_remind_btn_press")] forState:UIControlStateSelected];
}

#pragma mark - 重新初始化UI界面
- (void)buildUIAgain
{
    //先重置界面
    [self.MModuleArr removeAllObjects];
    self.MMovementBtn.frame = CGRectZero;
    self.MSleepBtn.frame = CGRectZero;
    self.MHeartRateBtn.frame = CGRectZero;
    self.MRemindBtn.frame = CGRectZero;
    for (UIScrollView *tempScrollView in self.MMediumBgScrollView.subviews) {
        [tempScrollView removeFromSuperview];
    }
    self.MMediumBgScrollView.contentSize = CGSizeZero;
    
    //判断当前是否为英制
    if ([[U_DEFAULTS objectForKey:IS_BRITISH_SYSTEM] isEqualToString:@"1"]) {
        self.MMovementView.kmLabel.text = @"mi";
        self.MMovementView.currentKmLabel.text = [NSString stringWithFormat:@"%.1f",self.MStepsModel.mileage * 0.6213712];
    }else{
        self.MMovementView.kmLabel.text = @"km";
        self.MMovementView.currentKmLabel.text = [NSString stringWithFormat:@"%.1f",self.MStepsModel.mileage];
    }
    
    //重设底部按钮的文字以及是否隐藏
    if ([MNDeviceBindingService shareInstance].hadBindingDevice == NO) {
        self.MBottomBtn.hidden = NO;
        self.MBottomBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _BottomBtnClickType = BottomBtnClickTypeBindingDevice;
        [self.MBottomBtn setTitle:NSLocalizedString(@"您还没绑定设备", nil) forState:UIControlStateNormal];
    }else{
        self.MBottomBtn.hidden = YES;
    }
    
    //默认功能 运动 睡眠
    [self.MModuleArr addObject:MOVEMENT];
    [self.MModuleArr addObject:SLEEP];
    
    //判断是否具有心率功能
    if ([[[MNDeviceBindingService shareInstance] getDeviceFunctionWithDeviceType:[MNDeviceBindingService shareInstance].currentDeviceType] containsObject:@"HEARTRATE"]) {
        [self.MModuleArr addObject:@"HEARTRATE"];
    }
    
    //判断是否具有提醒功能
    if ([[[MNDeviceBindingService shareInstance] getDeviceFunctionWithDeviceType:[MNDeviceBindingService shareInstance].currentDeviceType] containsObject:@"WARN"]) {
        [self.MModuleArr addObject:@"WARN"];
    }
    
    NSInteger moduleCount = self.MModuleArr.count;
    
    //重新调整模块按钮的frame
    switch (moduleCount) {
        case 2:
        {
            self.MMovementBtn.frame = CGRectMake(BothSidesSpaceWithCount(2), 25, 50, 50);
            self.MSleepBtn.frame = CGRectMake(MAX_X(self.MMovementBtn) + BtnSpace, 25, 50, 50);
        }
            break;
        case 3:
        {
            self.MMovementBtn.frame = CGRectMake(BothSidesSpaceWithCount(3), 25, 50, 50);
            self.MSleepBtn.frame = CGRectMake(MAX_X(self.MMovementBtn) + BtnSpace, 25, 50, 50);
            if ([self.MModuleArr containsObject:@"HEARTRATE"]) {
                self.MHeartRateBtn.frame = CGRectMake(MAX_X(self.MSleepBtn) + BtnSpace, 25, 50, 50);
            }else if ([self.MModuleArr containsObject:@"WARN"]){
                self.MRemindBtn.frame = CGRectMake(MAX_X(self.MSleepBtn) + BtnSpace, 25, 50, 50);
            }
        }
            break;
        case 4:
        {
            self.MMovementBtn.frame = CGRectMake(BothSidesSpaceWithCount(4), 25, 50, 50);
            self.MSleepBtn.frame = CGRectMake(MAX_X(self.MMovementBtn) + BtnSpace, 25, 50, 50);
            self.MHeartRateBtn.frame = CGRectMake(MAX_X(self.MSleepBtn) + BtnSpace, 25, 50, 50);
            self.MRemindBtn.frame = CGRectMake(MAX_X(self.MHeartRateBtn) + BtnSpace, 25, 50, 50);
        }
            break;
        default:
            break;
    }
    
    //重新设置滚动视图的滚动区域
    self.MMediumBgScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * moduleCount, HEIGHT(self.MMediumBgScrollView));
    self.MMediumBgScrollView.delegate = self;
    
    //添加背景视图
    for (NSInteger i = 0; i < moduleCount; i ++) {
        
        UIScrollView *funcScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH * i, 0, SCREEN_WIDTH, HEIGHT(self.MMediumBgScrollView))];
        funcScrollView.showsHorizontalScrollIndicator = NO;
        funcScrollView.showsVerticalScrollIndicator = NO;
        funcScrollView.tag = (i + 1) * 1000;
        
        //如果未绑定设备 则无法下拉同步
        if ([MNDeviceBindingService shareInstance].hadBindingDevice == NO) {
            funcScrollView.scrollEnabled = NO;
        }else{
            funcScrollView.scrollEnabled = YES;
        }
        
        switch (i) {
            case 0: //运动背景视图
            {
                [funcScrollView addSubview:self.MMovementView];
                
                __weak UIScrollView *weakMovementScrollView = funcScrollView;
                [funcScrollView addLegendHeaderWithRefreshingBlock:^{
                    
                    switch (self.MCurrentStepsSyncType) {
                        case StepsSyncTypePullDown: //主动下拉同步
                        {
                            [[MNMovementService shareInstance] startSyncStepDataWithSuccess:^{
                                [weakMovementScrollView.header endRefreshing];
                            } withProgress:^(int progress) {
                                [self.MMovementView.movementCircleView setPercent:progress animated:NO];
                            } withFailure:^(NSString *reason) {
                                [weakMovementScrollView.header endRefreshing];
                            }];
                        }
                            break;
                        case StepsSyncTypeLaunchJustNow: //刚刚启动同步
                        {
                            [[MNMovementService shareInstance] startDisconnectSyncStepDataWithSuccess:^{
                                [weakMovementScrollView.header endRefreshing];
                                self.MCurrentStepsSyncType = StepsSyncTypePullDown;
                            } withProgress:^(int progress) {
                                [self.MMovementView.movementCircleView setPercent:progress animated:NO];
                            } withFailure:^(NSString *reason) {
                                [weakMovementScrollView.header endRefreshing];
                                //展示蓝牙断开的样式
                                [self blueToothConnectionIsBroken];
                            }];
                        }
                            break;
                        default:
                            break;
                    }
                }];
            }
                break;
            case 1: //睡眠背景视图
            {
                [funcScrollView addSubview:self.MSleepView];
                
                __weak UIScrollView *weakSleepScrollView = funcScrollView;
                [funcScrollView addLegendHeaderWithRefreshingBlock:^{
                    [[MNSleepService shareInstance] startSyncSleepDataWithSuccess:^{ //同步睡眠数据
                        [weakSleepScrollView.header endRefreshing];
                    } withProgress:^(int progress) {
                        [self.MMovementView.movementCircleView setPercent:progress animated:NO];
                    } withFailure:^(NSString *reason) {
                        [weakSleepScrollView.header endRefreshing];
                    }];
                }];
            }
                break;
            case 2: //心率或提醒背景视图
            {
                if (moduleCount == 3){
                    if ([self.MModuleArr containsObject:@"HEARTRATE"]) {
                        funcScrollView.backgroundColor = [UIColor grayColor];
                    }else if ([self.MModuleArr containsObject:@"WARN"]){
                        [funcScrollView addSubview:self.MRemindView];
                    }
                }else if(moduleCount == 4){
                    funcScrollView.backgroundColor = [UIColor grayColor];
                }
            }
                break;
            case 3: //提醒背景视图
            {
                [funcScrollView addSubview:self.MRemindView];
            }
                break;
            default:
                break;
        }
        [self.MMediumBgScrollView addSubview:funcScrollView];
    }
}

#pragma mark - 底部按钮点击事件
- (IBAction)bottomBtnClick:(UIButton *)sender
{
    if (_BottomBtnClickType == BottomBtnClickTypeBindingDevice) {
        
        MNDeviceBindingViewCtrl *bindingVC = [[MNDeviceBindingViewCtrl alloc]init];
        bindingVC.type = OperationTypeBinding;
        [self.navigationController pushViewController:bindingVC animated:YES];
        
    }else if (_BottomBtnClickType == BottomBtnClickTypeConnectBlueToothAgain){
        
        self.MBottomBtn.hidden = YES;
        [[qBleClient sharedInstance] connectWithPeriperal:[qBleClient sharedInstance].periperal success:^(id result) {
            for (NSInteger i = 1; i <= 4; i ++ ) {
                UIScrollView *tempScrollView = (UIScrollView *)[self.MMediumBgScrollView viewWithTag:i * 1000];
                tempScrollView.scrollEnabled = YES;
            }
        } failure:^(id reason) {
            self.MBottomBtn.hidden = NO;
        }];
    }
}

#pragma mark 设置列表按钮点击事件
- (IBAction)settingListBtnClick:(UIButton *)sender
{
    [self.navigationController pushViewController:[[MNSettingListViewCtrl alloc]init] animated:YES];
}

#pragma mark 历史记录按钮点击事件
- (IBAction)historyBtnClick:(UIButton *)sender
{
    _backItemText = @"历史记录";
    [self setUpBackBarItem];
    
    MNHistoryRecordViewCtrl *historyVC = [[MNHistoryRecordViewCtrl alloc]init];
    if (self.MMovementBtn.selected == YES) {
        historyVC.historyDataType = HistoryDataTypeMovement;
    }else if (self.MSleepBtn.selected == YES){
        historyVC.historyDataType = HistoryDataTypeSleep;
    }else if (self.MHeartRateBtn.selected == YES){
        historyVC.historyDataType = HistoryDataTypeHeartRate;
    }
    [self.navigationController pushViewController:historyVC animated:YES];
}

#pragma mark 功能模块按钮点击事件
- (void)functionModuleBtnClick:(UIButton *)sender
{
    [self resetAllFunctionModuleBtn];
    sender.selected = YES;
    
    CGFloat contentOffsetX = SCREEN_WIDTH * ((sender.tag/100) - 1);
    
    if (self.MModuleArr.count == 3&&(sender.tag == 300 || sender.tag == 400)) {
        contentOffsetX = SCREEN_WIDTH *2;
    }
    
    if (sender.tag == 400) {
        self.MHistoryBtn.hidden = YES;
    }else{
        self.MHistoryBtn.hidden = NO;
    }
    
    [self.MMediumBgScrollView setContentOffset:CGPointMake(contentOffsetX, 0) animated:YES];
}

#pragma mark 将所有的功能按钮设为未选中
- (void)resetAllFunctionModuleBtn
{
    self.MMovementBtn.selected = NO;
    self.MSleepBtn.selected = NO;
    self.MHeartRateBtn.selected = NO;
    self.MRemindBtn.selected = NO;
}

#pragma mark - 蓝牙连接已断开的情况
- (void)blueToothConnectionIsBroken
{
    for (NSInteger i = 1; i <= 4; i ++ ) {
        UIScrollView *tempScrollView = (UIScrollView *)[self.MMediumBgScrollView viewWithTag:i * 1000];
        tempScrollView.scrollEnabled = NO;
    }
    
    self.MBottomBtn.hidden = NO;
    _BottomBtnClickType = BottomBtnClickTypeConnectBlueToothAgain;
    [self.MBottomBtn setTitle:NSLocalizedString(@"蓝牙连接已断开", nil) forState:UIControlStateNormal];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.MMediumBgScrollView) {
        [self resetAllFunctionModuleBtn];
        
        NSInteger selectedTag = (scrollView.contentOffset.x/SCREEN_WIDTH + 1)*100;
        
        if (self.MModuleArr.count == 3&&scrollView.contentOffset.x/SCREEN_WIDTH == 2){
            if ([self.MModuleArr containsObject:@"HEARTRATE"]) {
                selectedTag = 300;
            }else if ([self.MModuleArr containsObject:@"WARN"]){
                selectedTag = 400;
            }
        }
        
        if (selectedTag == 400) {
            self.MHistoryBtn.hidden = YES;
        }else{
            self.MHistoryBtn.hidden = NO;
        }
        
        ((UIButton *)[self.MTopBgView viewWithTag:selectedTag]).selected = YES;
    }
}

#pragma mark - MNMovementServiceDelegate
-(void)changeStepViewmodel:(MNStepViewModel *)model
{
    //不断刷新运动数据模型
    self.MStepsModel = model;
    
    self.MMovementView.movementCircleView.textLabel.text =self.MStepsModel.steps;
    [self.MMovementView.movementCircleView setPercent:self.MStepsModel.percent animated:YES];
    self.MMovementView.currentCalorieLabel.text = [NSString stringWithFormat:@"%.1f",self.MStepsModel.calorie];
    if ([[U_DEFAULTS objectForKey:IS_BRITISH_SYSTEM] isEqualToString:@"1"]) {
        self.MMovementView.currentKmLabel.text = [NSString stringWithFormat:@"%.1f",self.MStepsModel.mileage * 0.6213712];
    }else{
        self.MMovementView.currentKmLabel.text = [NSString stringWithFormat:@"%.1f",self.MStepsModel.mileage];
    }
}

#pragma mark - MNSleepServiceDelegate
-(void)changeSleepViewModel:(MNSleepViewModel *)model
{
    //不断刷新睡眠数据模型
    self.MSleepModel = model;
    
    self.MSleepView.sleepCircleView.textLabel.text = self.MSleepModel.sleepDuration;
    [self.MSleepView.sleepCircleView setPercent:self.MSleepModel.percent animated:YES];
    self.MSleepView.deepSleepTImeLabel.text = self.MSleepModel.deepSleepDuration;
    self.MSleepView.shallowSleepTImeLabel.text = self.MSleepModel.lightSleepDuration;
}

#pragma mark - bleDisConnectionsDelegate
-(void)bleDisConnectPeripheral : (CBPeripheral *)aPeripheral
{
    [self blueToothConnectionIsBroken];
}

@end