//
//  MNDeviceBindingViewCtrl.m
//  Movnow
//
//  Created by LiuX on 15/4/25.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//

#import "MNDeviceBindingViewCtrl.h"
#import "MNDeviceBindingAniView.h"
#import "MNDeviceBindingService.h"
#import "QBleClient.h"

@interface MNDeviceBindingViewCtrl ()

/**
 *  转动动画视图
 */
@property (nonatomic,strong) MNDeviceBindingAniView *DAnimationView;
/**
 *  提醒文字标签
 */
@property (nonatomic,strong) UILabel *DAlertLabel;
/**
 *  提醒文字标签(文字不变)
 */
@property (nonatomic,strong) UILabel *DConstantAlertLabel;
/**
 *  取消绑定按钮
 */
@property (nonatomic,strong) UIButton *DCancelBindingBtn;

@end

@implementation MNDeviceBindingViewCtrl

- (MNDeviceBindingAniView *)DAnimationView
{
    if (_DAnimationView == nil) {
        _DAnimationView = [[MNDeviceBindingAniView alloc]initWithXibFileWithClickBlock:^(MNDeviceBindingAniView *view){
            [self sendBlueToothRequest];
        }];
    }
    return _DAnimationView;
}

- (UILabel *)DAlertLabel
{
    if (_DAlertLabel == nil) {
        _DAlertLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 230, SCREEN_WIDTH, 100)];
        _DAlertLabel.textColor = CTRL_BG_COLOR;
        _DAlertLabel.font = TITLE_FONT;
        _DAlertLabel.textAlignment = NSTextAlignmentCenter;
        _DAlertLabel.numberOfLines = 0;
    }
    return _DAlertLabel;
}

- (UILabel *)DConstantAlertLabel
{
    if (_DConstantAlertLabel == nil) {
        _DConstantAlertLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, MAX_Y(self.DAlertLabel) + 20, SCREEN_WIDTH, 40)];
        _DConstantAlertLabel.text = NSLocalizedString(@"如果需要匹配您的设备\n请务必点击匹配，否则无法使用", nil);
        _DConstantAlertLabel.textColor = CTRL_BG_COLOR;
        _DConstantAlertLabel.font = TITLE_FONT;
        _DConstantAlertLabel.textAlignment = NSTextAlignmentCenter;
        _DConstantAlertLabel.numberOfLines = 0;
    }
    return _DConstantAlertLabel;
}

- (UIButton *)DCancelBindingBtn
{
    if (_DCancelBindingBtn == nil) {
        _DCancelBindingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _DCancelBindingBtn.frame = CGRectMake(0, SCREEN_HEIGHT - 80, SCREEN_WIDTH, 80);
        [_DCancelBindingBtn setTitle:(self.type == OperationTypeBinding)?NSLocalizedString(@"暂不绑定",nil):NSLocalizedString(@"暂不升级",nil) forState:UIControlStateNormal];
        _DCancelBindingBtn.titleLabel.font = TITLE_FONT;
        [_DCancelBindingBtn addTarget:self action:@selector(cancelBindingBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _DCancelBindingBtn;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWith8BitRed:87 green:130 blue:164];
    
    //添加控件
    [self.view addSubview:self.DAlertLabel];
    [self.view addSubview:self.DConstantAlertLabel];
    [self.view addSubview:self.DCancelBindingBtn];
    [self.view addSubview:self.DAnimationView];
    
    [self sendBlueToothRequest];
}

#pragma mark - 发出蓝牙请求
- (void)sendBlueToothRequest
{
    [self startBindingAnimation];
    
    if ([qBleClient sharedInstance].state != PoweredOn) {
        [self endBindingAnimation];
        self.DAlertLabel.text = NSLocalizedString(@"请打开蓝牙", nil);
        [self.view showHUDWithStr:NSLocalizedString(@"请打开蓝牙", nil) hideAfterDelay:kAlertWordsInterval];
        return;
    }
    
    switch (self.type) {
        case OperationTypeBinding: //绑定
        {
            self.DAlertLabel.text = NSLocalizedString(@"正在绑定\n\n该过程大概需要10-40秒\n\n请耐心等候", nil);
            
            [[MNDeviceBindingService shareInstance] startBindingDeviceWithSuccess:^{
                
                //发出通知 告诉主界面重新布局UI
                [[NSNotificationCenter defaultCenter] postNotificationName:MAINVC_NEED_BUILDUI_AGAIN object:nil];
                [self.navigationController popViewControllerAnimated:YES];
            } withFailure:^(NSString *messgae) {
                self.DAlertLabel.text = NSLocalizedString(@"无法绑定\n\n请确保身边存在手环，且手环电量充足\n\n点击屏幕中央重新绑定", nil);
                [self endBindingAnimation];
            } withWaitUserOperation:^{
                self.DAlertLabel.text = NSLocalizedString(@"已搜索到设备，\n请晃动设备或按键确认", nil);
            }];
        }
            break;
        case OperationTypeUpdateFirmware: //固件升级
        {
            self.DAlertLabel.text = NSLocalizedString(@"不用升级,已经是最新固件版本",nil);
            [self endBindingAnimation];
        }
            break;
        default:
            break;
    }
}

#pragma mark - 绑定开始和结束
- (void)startBindingAnimation
{
    [self.DAnimationView startAnimation];
    self.DCancelBindingBtn.enabled = NO;
    [self.DCancelBindingBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
}

- (void)endBindingAnimation
{
    [self.DAnimationView stop];
    self.DCancelBindingBtn.enabled = YES;
    [self.DCancelBindingBtn setTitleColor:CTRL_BG_COLOR forState:UIControlStateNormal];
}

#pragma mark - 取消绑定按钮点击事件
- (void)cancelBindingBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end