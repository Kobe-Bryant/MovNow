//
//  MNHistoryForDayDetailViewCtrl.m
//  Movnow
//
//  Created by LiuX on 15/5/13.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//

#import "MNHistoryForDayDetailViewCtrl.h"
#import "MNMovementService.h"
#import "MNMainMovementView.h"
#import "MNMainSleepView.h"
#import "MNMainHeartRateView.h"
#import "MNAdaptAlertView.h"
#import "WeiboSDK.h"
#import "WXApiObject.h"
#import "WXApi.h"
#import "UIImage+Util.h"
#import <Social/Social.h>
#import "MNMovementDetailPopView.h"
#import "MNSleepDetailPopView.h"

@interface MNHistoryForDayDetailViewCtrl ()

/**
 *  顶部的日期标签
 */
@property (weak, nonatomic) IBOutlet UILabel *HTopDateLabel;
/**
 *  主体内容背景视图
 */
@property (weak, nonatomic) IBOutlet UIView *HContentBgView;
/**
 *  运动视图
 */
@property (nonatomic,strong) MNMainMovementView *HMovementView;
/**
 *  运动视图底部弹出视图
 */
@property (nonatomic,strong) MNMovementDetailPopView *HMovementPopView;
/**
 *  睡眠视图
 */
@property (nonatomic,strong) MNMainSleepView *HSleepView;
/**
 *  睡眠视图底部弹出视图
 */
@property (nonatomic,strong) MNSleepDetailPopView *HSleepPopView;
/**
 *  分享弹出视图(中文环境)
 */
@property (nonatomic,strong) MNAdaptAlertView *HSharePopViewForChinese;
/**
 *  分享弹出视图(国外环境)
 */
@property (nonatomic,strong) MNAdaptAlertView *HSharePopViewForForeign;

@end

@implementation MNHistoryForDayDetailViewCtrl

- (MNAdaptAlertView *)HSharePopViewForChinese
{
    if (_HSharePopViewForChinese == nil) {
        _HSharePopViewForChinese = [[MNAdaptAlertView alloc]initStyleShareMicroBlogAndWeiChatWithBlock:^(MNAdaptAlertView *alertView, int buttonIndex) {
            switch (buttonIndex) {
                case 0: //微博
                {
                    WBMessageObject *message = [WBMessageObject message];
                    message.imageObject = [WBImageObject object];
                    message.imageObject.imageData = UIImagePNGRepresentation([UIImage getCurrentScreen]);
                    message.text = [[MNMovementService shareInstance] getShareTextWithStepsModel:self.currentStepsModel];
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
                    message.title = [[MNMovementService shareInstance] getShareTextWithStepsModel:self.currentStepsModel];
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
    return _HSharePopViewForChinese;
}

- (MNAdaptAlertView *)HSharePopViewForForeign
{
    if (_HSharePopViewForForeign == nil) {
        _HSharePopViewForForeign = [[MNAdaptAlertView alloc]initStyleShareFacebookAndTwitterWithBlock:^(MNAdaptAlertView *alertView, int buttonIndex) {
            
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
            shareVC.initialText = [[MNMovementService shareInstance] getShareTextWithStepsModel:self.currentStepsModel];
            
            if (shareVC == nil) {
                [self.view showHUDWithStr:shareAlertWords hideAfterDelay:kAlertWordsInterval];
            }else{
                [self presentViewController:shareVC animated:YES completion:nil];
            }
        }];
    }
    return _HSharePopViewForForeign;
}

- (MNMainMovementView *)HMovementView
{
    if (_HMovementView == nil) {
        _HMovementView = [[MNMainMovementView alloc]initWithXibFileAndHeight:HEIGHT(self.HContentBgView) showType:MovementViewShowTypeDayDetailVC currentSelectedDate:_currentSelectedDate calorieClickBlock:^{
        } shareClickBlock:^{ //分享按钮点击事件
            if ([[MNLanguageService shareInstance] getCurrentLanguage] == CurrentLanguageTypeChineseSimple || [[MNLanguageService shareInstance] getCurrentLanguage] == CurrentLanguageTypeChineseTraditional) { //中文环境
                [self.HSharePopViewForChinese show];
            }else{ //国外环境
                [self.HSharePopViewForForeign show];
            }
        } bottomClickBlock:^{
            [self.HMovementPopView showSelf];
        }];
    }
    return _HMovementView;
}

- (MNMainSleepView *)HSleepView
{
    if (_HSleepView == nil) {
        _HSleepView = [[MNMainSleepView alloc]initWithXibFileAndHeight:HEIGHT(self.HContentBgView) showType:SleepViewShowTypeDayDetailVC currentSelectedDate:_currentSelectedDate bottomClickBlock:^{
            [self.HSleepPopView showSelf];
        }];
    }
    return _HSleepView;
}

- (MNMovementDetailPopView *)HMovementPopView
{
    if (_HMovementPopView == nil) {
        _HMovementPopView = [[MNMovementDetailPopView alloc]initWithXibFileAndShowType:MovementViewShowTypeDayDetailVC currentSelectedDate:_currentSelectedDate];
    }
    return _HMovementPopView;
}

- (MNSleepDetailPopView *)HSleepPopView
{
    if (_HSleepPopView == nil) {
        _HSleepPopView = [[MNSleepDetailPopView alloc]initWithXibFileAndShowType:SleepViewShowTypeDayDetailVC currentSelectedDate:_currentSelectedDate];
    }
    return _HSleepPopView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self executeDefaultSetting];
}

#pragma mark - 默认配置
- (void)executeDefaultSetting
{
    switch (self.historyDataType) {
        case HistoryDataTypeMovement: //运动
        {
            [self.HContentBgView addSubview:self.HMovementView];
            [self.view addSubview:self.HMovementPopView];
        }
            break;
        case HistoryDataTypeSleep: //睡眠
        {
            [self.HContentBgView addSubview:self.HSleepView];
            [self.view addSubview:self.HSleepPopView];
        }
            break;
        default:
            break;
    }
    
    self.HTopDateLabel.text = [NSDate getTimeInfoWithDate:_currentSelectedDate];
}

@end