//
//  MNSystemSettingViewCtrl.m
//  Movnow
//
//  Created by LiuX on 15/4/23.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//

#import "MNSystemSettingViewCtrl.h"
#import "MNBaseTableViewCell.h"
#import "MNUserService.h"
#import "MNAdaptAlertView.h"
#import "MNGuideViewCtrl.h"
#import "MNFunctionIntroduceViewCtrl.h"

#define CELL_INDENTIFIER @"CELL_INDENTIFIER"

@interface MNSystemSettingViewCtrl ()

/**
 *  英制开关
 */
@property (nonatomic,strong) UISwitch *SBritishSystemSwitch;
/**
 *  软件版本标签
 */
@property (nonatomic,strong) UILabel *SAppVersionsLabel;
/**
 *  表尾视图
 */
@property (nonatomic,strong) UIView *SSettingFooterView;
/**
 *  注销按钮
 */
@property (nonatomic,strong) UIButton *SLogoutBtn;

@end

@implementation MNSystemSettingViewCtrl

- (UISwitch *)SBritishSystemSwitch
{
    if (_SBritishSystemSwitch == nil) {
        _SBritishSystemSwitch = [[UISwitch alloc]init];
        _SBritishSystemSwitch.onTintColor = [UIColor orangeColor];
        if ([[U_DEFAULTS objectForKey:IS_BRITISH_SYSTEM] isEqualToString:@"1"]) {
            [_SBritishSystemSwitch setOn:YES animated:YES];
        }else{
            [_SBritishSystemSwitch setOn:NO animated:YES];
        }
        [_SBritishSystemSwitch addTarget:self action:@selector(britishSystemSwitchClick:) forControlEvents:UIControlEventValueChanged];
    }
    return _SBritishSystemSwitch;
}

- (UILabel *)SAppVersionsLabel
{
    if (_SAppVersionsLabel == nil) {
        _SAppVersionsLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 70, 30)];
        _SAppVersionsLabel.text = [@"V " stringByAppendingString:[[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
        _SAppVersionsLabel.textColor = NAV_TEXT_COLOR;
        _SAppVersionsLabel.textAlignment = NSTextAlignmentRight;
    }
    return _SAppVersionsLabel;
}

- (UIButton *)SLogoutBtn
{
    if (_SLogoutBtn == nil) {
        _SLogoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _SLogoutBtn.frame = CGRectMake(15, 15, SCREEN_WIDTH - 15*2, 50);
        [_SLogoutBtn setTitle:NSLocalizedString(@"注销", nil) forState:UIControlStateNormal];
        _SLogoutBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        [_SLogoutBtn setBackgroundImage:[UIImage imageNamed:IMAGE_NAME(@"btn_login")] forState:UIControlStateNormal];
        [_SLogoutBtn setBackgroundImage:[UIImage imageNamed:IMAGE_NAME(@"btn_login_press")] forState:UIControlStateNormal];
        [_SLogoutBtn addTarget:self action:@selector(logoutBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _SLogoutBtn;
}

- (UIView *)SSettingFooterView
{
    if (_SSettingFooterView == nil) {
        _SSettingFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 70)];
        _SSettingFooterView.backgroundColor = [UIColor clearColor];
        
        [_SSettingFooterView addSubview:self.SLogoutBtn];
    }
    return _SSettingFooterView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.tableFooterView = self.SSettingFooterView;
}

#pragma mark - 返回按钮文字
- (NSString *)backBarItemText
{
    return NSLocalizedString(@"功能介绍", nil);
}

#pragma mark - 英制开关点击事件
- (void)britishSystemSwitchClick:(UISwitch *)aSwitch
{    
    //保存开关状态
    if (aSwitch.isOn == NO) {
        [U_DEFAULTS setObject:@"0" forKey:IS_BRITISH_SYSTEM];
    }else{
        [U_DEFAULTS setObject:@"1" forKey:IS_BRITISH_SYSTEM];
    }
    [U_DEFAULTS synchronize];
    
    //发出通知 告诉主界面重新布局UI
    [[NSNotificationCenter defaultCenter] postNotificationName:MAINVC_NEED_BUILDUI_AGAIN object:nil];
}

#pragma mark - 注销按钮点击事件
- (void)logoutBtnClick
{
    //弹出确认框
    MNAdaptAlertView *msgAlert = [[MNAdaptAlertView alloc]initStyleWithMessage:NSLocalizedString(@"您确定注销当前账号吗?",nil) andBlock:^(MNAdaptAlertView *alertView, int buttonIndex) {
        if (buttonIndex == 1) {
            [[MNUserService shareInstance] logoutWithWithSuccess:^(id result) {
                
                [self.view.window showHUDWithStr:NSLocalizedString(result,nil) hideAfterDelay:kAlertWordsInterval];
                //返回主界面
                [self.navigationController popToRootViewControllerAnimated:YES];
            } failure:^(id reason) {
                [self.view showHUDWithStr:NSLocalizedString(reason,nil) hideAfterDelay:kAlertWordsInterval];
            }];
        }
    }];
    [msgAlert show];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 1: //引导页
        {
            MNGuideViewCtrl *guideVC = [[MNGuideViewCtrl alloc]init];
            guideVC.pushType = GuideVcDismissTypeSystemSetting;
            [self presentViewController:guideVC animated:YES completion:nil];
        }
            break;
        case 2: //功能介绍
        {
            [self.navigationController pushViewController:[[MNFunctionIntroduceViewCtrl alloc]init] animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MNBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_INDENTIFIER];
    
    if (!cell) {
        cell = [[MNBaseTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_INDENTIFIER];
    }
    
    switch (indexPath.row) {
        case 0:
        {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text = NSLocalizedString(@"英制", nil);
            cell.accessoryView = self.SBritishSystemSwitch;
        }
            break;
        case 1:
        {
            cell.textLabel.text = NSLocalizedString(@"引导页", nil);
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
            break;
        case 2:
        {
            cell.textLabel.text = NSLocalizedString(@"功能介绍", nil);
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
            break;
        case 3:
        {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text = NSLocalizedString(@"软件版本", nil);
            cell.accessoryView = self.SAppVersionsLabel;
        }
            break;
        default:
            break;
    }
    
    return cell;
}

@end