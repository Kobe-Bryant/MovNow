//
//  MNMyDeviceViewCtrl.m
//  Movnow
//
//  Created by LiuX on 15/4/27.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//

#import "MNMyDeviceViewCtrl.h"
#import "MNBaseTableViewCell.h"
#import "MNDeviceBindingService.h"
#import "MNFirmwareModel.h"
#import "MNAdaptAlertView.h"
#import "MNDeviceBindingViewCtrl.h"
#import "MNLightColorPopView.h"
#import "MNBleBaseService.h"
#import "MNPhotoGraphViewCtrl.h"
#import "MJRefresh.h"

#define CELL_INDENTIFIER @"CELL_INDENTIFIER"

@interface MNMyDeviceViewCtrl ()

/**
 *  设备功能分组1
 */
@property (nonatomic,strong) NSMutableArray *DFunctionArr1;
/**
 *  设备功能分组2
 */
@property (nonatomic,strong) NSMutableArray *DFunctionArr2;
/**
 *  设备功能分组3
 */
@property (nonatomic,strong) NSMutableArray *DFunctionArr3;
/**
 *  当前固件版本标签
 */
@property (nonatomic,strong) UILabel *DFirmwareVersionLabel;
/**
 *  解除绑定按钮
 */
@property (nonatomic,strong) UIButton *DRemoveBindingBtn;
/**
 *  右侧电量视图
 */
@property (nonatomic,strong) UIView *DElectricView;
/**
 *  来电提醒开关
 */
@property (nonatomic,strong) UISwitch *DPhoneCallSwitch;
/**
 *  防丢开关
 */
@property (nonatomic,strong) UISwitch *DLostSwitch;
/**
 *  右侧指示灯颜色视图
 */
@property (nonatomic,strong) UIView *DLightColorView;
/**
 *  指示灯弹出视图
 */
@property (nonatomic,strong) MNLightColorPopView *DLightColorPopView;

@end

@implementation MNMyDeviceViewCtrl

- (NSMutableArray *)DFunctionArr1
{
    if (_DFunctionArr1 == nil) {
        _DFunctionArr1 = [NSMutableArray array];
    }
    return _DFunctionArr1;
}

- (NSMutableArray *)DFunctionArr2
{
    if (_DFunctionArr2 == nil) {
        //默认功能
        _DFunctionArr2 = [NSMutableArray arrayWithObjects:FIRMWARE,UNBINDING,nil];
    }
    return _DFunctionArr2;
}

- (NSMutableArray *)DFunctionArr3
{
    if (_DFunctionArr3 == nil) {
        _DFunctionArr3 = [NSMutableArray array];
    }
    return _DFunctionArr3;
}

- (UILabel *)DFirmwareVersionLabel
{
    if (_DFirmwareVersionLabel == nil) {
        _DFirmwareVersionLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 57, 7, 30, 30)];
        _DFirmwareVersionLabel.text = [MNFirmwareModel sharestance].firmwareVersion.stringValue;
        _DFirmwareVersionLabel.textColor = NAV_TEXT_COLOR;
    }
    return _DFirmwareVersionLabel;
}

- (UIButton *)DRemoveBindingBtn
{
    if (_DRemoveBindingBtn == nil) {
        _DRemoveBindingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _DRemoveBindingBtn.frame = CGRectMake(0, 0, 30, 30);
        [_DRemoveBindingBtn setTitle:NSLocalizedString(@"解绑", nil) forState:UIControlStateNormal];
        _DRemoveBindingBtn.titleLabel.font = TITLE_FONT;
        [_DRemoveBindingBtn setTitleColor:NAV_TEXT_COLOR forState:UIControlStateNormal];
        [_DRemoveBindingBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [_DRemoveBindingBtn addTarget:self action:@selector(removeBindingBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _DRemoveBindingBtn;
}

- (UIView *)DElectricView
{
    if (_DElectricView == nil) {
        _DElectricView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 70, 30)];
        
        UILabel *electricLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 35, 30)];
        electricLabel.textAlignment = NSTextAlignmentRight;
        electricLabel.font = TITLE_FONT;
        electricLabel.textColor = NAV_TEXT_COLOR;
        electricLabel.tag = 100;
        [_DElectricView addSubview:electricLabel];
        
        UIImageView *electricImageView = [[UIImageView alloc]initWithFrame:CGRectMake(MAX_X(electricLabel) + 5, 7, 30, 16)];
        electricImageView.image = [UIImage imageNamed:IMAGE_NAME(@"battery-iOS")];
        [_DElectricView addSubview:electricImageView];
    }
    return _DElectricView;
}

- (UISwitch *)DPhoneCallSwitch
{
    if (_DPhoneCallSwitch == nil) {
        _DPhoneCallSwitch = [[UISwitch alloc]init];
        [_DPhoneCallSwitch setOn:[[U_DEFAULTS objectForKey:IS_PHONECALL_SWITCH_ON] isEqualToString:@"1"]?YES:NO];
        [_DPhoneCallSwitch addTarget:self action:@selector(phoneCallSwitchClick:) forControlEvents:UIControlEventValueChanged];
    }
    return _DPhoneCallSwitch;
}

- (UISwitch *)DLostSwitch
{
    if (_DLostSwitch == nil) {
        _DLostSwitch = [[UISwitch alloc]init];
        [_DLostSwitch setOn:[[U_DEFAULTS objectForKey:IS_LOST_SWITCH_ON] isEqualToString:@"1"]?YES:NO];
        [_DLostSwitch addTarget:self action:@selector(lostSwitchClick:) forControlEvents:UIControlEventValueChanged];
    }
    return _DLostSwitch;
}

- (UIView *)DLightColorView
{
    if (_DLightColorView == nil) {
        _DLightColorView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 70, 30)];
        
        UILabel *lightColorLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 0, 30, 30)];
        lightColorLabel.text = NSLocalizedString(@"蓝色", nil);
        lightColorLabel.textAlignment = NSTextAlignmentRight;
        lightColorLabel.font = TITLE_FONT;
        lightColorLabel.textColor = NAV_TEXT_COLOR;
        lightColorLabel.tag = 200;
        [_DLightColorView addSubview:lightColorLabel];
        
        UIImageView *lightColorImageView = [[UIImageView alloc]initWithFrame:CGRectMake(MAX_X(lightColorLabel) + 13, 8, 14, 14)];
        lightColorImageView.image = [UIImage imageNamed:IMAGE_NAME(@"lightColor_blue")];
        lightColorImageView.tag = 300;
        [_DLightColorView addSubview:lightColorImageView];
    }
    return _DLightColorView;
}

- (MNLightColorPopView *)DLightColorPopView
{
    if (_DLightColorPopView == nil) {
        _DLightColorPopView = [[MNLightColorPopView alloc]initWithXibFileAndDismissBlock:^(LightColorType type) {
            switch (type) {
                case LightColorTypeBlue: //蓝色
                {
                    [[MNBleBaseService shareInstance] lightWithLightColorType:LightColorTypeBlue withSuccess:^(id result) {
                        ((UILabel *)[self.DLightColorView viewWithTag:200]).text = NSLocalizedString(@"蓝色", nil);
                        ((UIImageView *)[self.DLightColorView viewWithTag:300]).image = [UIImage imageNamed:IMAGE_NAME(@"lightColor_blue")];
                    } withFailure:^(id reason) {
                        [self.view showHUDWithStr:NSLocalizedString(reason, nil) hideAfterDelay:kAlertWordsInterval];
                    }];
                }
                    break;
                case LightColorTypeOrange: //橙色
                {
                    [[MNBleBaseService shareInstance] lightWithLightColorType:LightColorTypeOrange withSuccess:^(id result) {
                        ((UILabel *)[self.DLightColorView viewWithTag:200]).text = NSLocalizedString(@"橙色", nil);
                        ((UIImageView *)[self.DLightColorView viewWithTag:300]).image = [UIImage imageNamed:IMAGE_NAME(@"lightColor_orange")];
                    } withFailure:^(id reason) {
                        [self.view showHUDWithStr:NSLocalizedString(reason, nil) hideAfterDelay:kAlertWordsInterval];
                    }];
                }
                    break;
                case LightColorTypeGreen: //绿色
                {
                    [[MNBleBaseService shareInstance] lightWithLightColorType:LightColorTypeGreen withSuccess:^(id result) {
                        ((UILabel *)[self.DLightColorView viewWithTag:200]).text = NSLocalizedString(@"绿色", nil);
                        ((UIImageView *)[self.DLightColorView viewWithTag:300]).image = [UIImage imageNamed:IMAGE_NAME(@"lightColor_green")];
                    } withFailure:^(id reason) {
                        [self.view showHUDWithStr:NSLocalizedString(reason, nil) hideAfterDelay:kAlertWordsInterval];
                    }];
                }
                    break;
                case LightColorTypeRed: //红色
                {
                    [[MNBleBaseService shareInstance] lightWithLightColorType:LightColorTypeRed withSuccess:^(id result) {
                        ((UILabel *)[self.DLightColorView viewWithTag:200]).text = NSLocalizedString(@"红色", nil);
                        ((UIImageView *)[self.DLightColorView viewWithTag:300]).image = [UIImage imageNamed:IMAGE_NAME(@"lightColor_red")];
                    } withFailure:^(id reason) {
                        [self.view showHUDWithStr:NSLocalizedString(reason, nil) hideAfterDelay:kAlertWordsInterval];
                    }];
                }
                    break;
                default:
                    break;
            }
            
        }];
    }
    return _DLightColorPopView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self dealDeviceFunctionArrFromService];
    
    [self getElectricityQuantity];
}

#pragma mark - 主动查询电量
- (void)getElectricityQuantity
{
    if (self.DFunctionArr1.count > 0) {
        [[MNBleBaseService shareInstance] electricityWithSuccess:^(id result) {
            ((UILabel *)[self.DElectricView viewWithTag:100]).text = [NSString stringWithFormat:@"%@%%",[result[@"electricity"] stringValue]];
        } withFailure:^(id reason) {
            [self.view showHUDWithStr:NSLocalizedString(reason, nil) hideAfterDelay:kAlertWordsInterval];
        }];
    }
}

#pragma mark - 处理服务类中的设备功能数组
- (void)dealDeviceFunctionArrFromService
{
    if (self.DFunctionArr1.count > 0) {
        [self.DFunctionArr1 removeAllObjects];
    }
    
    if (self.DFunctionArr3.count > 0) {
        [self.DFunctionArr3 removeAllObjects];
    }
    
    NSArray *tempArr = [NSArray arrayWithArray:[[MNDeviceBindingService shareInstance] getDeviceFunctionWithDeviceType:[MNDeviceBindingService shareInstance].currentDeviceType]];
    
    //判断是否支持显示电量
    if ([tempArr containsObject:@"ELECTRICITY"]) {
        [self.DFunctionArr1 addObject:@"ELECTRICITY"];
        self.tableView.contentInset = UIEdgeInsetsZero;
    }else{
        self.tableView.contentInset = UIEdgeInsetsMake(-35, 0, 0, 0);
    }
    
    //判断是否具有下列功能
    if ([tempArr containsObject:@"LIGHT"]) {
        [self.DFunctionArr3 addObject:@"LIGHT"];
    }
    if ([tempArr containsObject:@"LOST"]) {
        [self.DFunctionArr3 addObject:@"LOST"];
    }
    if ([tempArr containsObject:@"NOTICE"]) {
        [self.DFunctionArr3 addObject:@"NOTICE"];
    }
    if ([tempArr containsObject:@"PHOTOGRAPH"]) {
        [self.DFunctionArr3 addObject:@"PHOTOGRAPH"];
    }
    if ([tempArr containsObject:@"FINDEQ"]) {
        [self.DFunctionArr3 addObject:@"FINDEQ"];
    }
    
    [self.tableView reloadData];
}

#pragma mark - 解绑按钮点击事件
- (void)removeBindingBtnClick
{
    //弹出确认框
    MNAdaptAlertView *msgAlert = [[MNAdaptAlertView alloc]initStyleWithMessage:NSLocalizedString(@"您确定解绑该设备吗?",nil) andBlock:^(MNAdaptAlertView *alertView, int buttonIndex) {
        if (buttonIndex == 1) {
            [[MNDeviceBindingService shareInstance] unbindWithSuccess:^{
                
                //发出通知 告诉主界面重新布局UI
                [[NSNotificationCenter defaultCenter] postNotificationName:MAINVC_NEED_BUILDUI_AGAIN object:nil];
                
                //清除最后更新的时间 开关的状态
                [U_DEFAULTS removeObjectForKey:MJRefreshHeaderUpdatedTimeKey];
                [U_DEFAULTS removeObjectForKey:IS_LOST_SWITCH_ON];
                [U_DEFAULTS removeObjectForKey:IS_PHONECALL_SWITCH_ON];
                [U_DEFAULTS synchronize];
                
                [self.navigationController popViewControllerAnimated:YES];
            } withFailure:^(NSString *messgae) {
                [self.view showHUDWithStr:NSLocalizedString(messgae, nil) hideAfterDelay:kAlertWordsInterval];
            }];
        }
    }];
    [msgAlert show];
}

#pragma mark - 来电提醒按钮点击事件
- (void)phoneCallSwitchClick:(UISwitch *)aSwitch
{
    [[MNBleBaseService shareInstance] callWarnWithOpen:aSwitch.isOn withSuccess:^(id result) {
        [U_DEFAULTS setObject:(aSwitch.isOn == YES)?@"1":@"0" forKey:IS_PHONECALL_SWITCH_ON];
        [U_DEFAULTS synchronize];
    } withFailure:^(id reason) {
        [aSwitch setOn:!aSwitch.isOn animated:YES];
    }];
}

#pragma mark - 防丢按钮点击事件
- (void)lostSwitchClick:(UISwitch *)aSwitch
{
    [[MNBleBaseService shareInstance] lostWithOpen:aSwitch.isOn withSuccess:^(id result) {
        [U_DEFAULTS setObject:(aSwitch.isOn == YES)?@"1":@"0" forKey:IS_LOST_SWITCH_ON];
        [U_DEFAULTS synchronize];
    } withFailure:^(id reason) {
        [aSwitch setOn:!aSwitch.isOn animated:YES];
    }];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 1:
        {
            if (indexPath.row == 0) { //跳到固件升级界面
                MNDeviceBindingViewCtrl *bindingVC = [[MNDeviceBindingViewCtrl alloc]init];
                bindingVC.type = OperationTypeUpdateFirmware;
                [self.navigationController pushViewController:bindingVC animated:YES];
            }
        }
            break;
        case 2:
        {
            switch ([tableView cellForRowAtIndexPath:indexPath].tag) {
                case 400: //指示灯颜色设置
                {
                    [self.DLightColorPopView showInView:self.view.window];
                }
                    break;
                case 500: //跳到拍照界面
                {
                    [self presentViewController:[[MNPhotoGraphViewCtrl alloc]initWithNibName:@"MNPhotoGraphViewCtrl" bundle:nil] animated:YES completion:nil];
                }
                    break;
                case 600: //查找设备
                {
                    [[MNBleBaseService shareInstance] findDeviceWithSuccess:^(id result) {
                    } withFailure:^(id reason) {
                        [self.view showHUDWithStr:NSLocalizedString(reason, nil) hideAfterDelay:kAlertWordsInterval];
                    }];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.DFunctionArr1.count;
    }else if (section == 1){
        return self.DFunctionArr2.count;
    }
    return self.DFunctionArr3.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MNBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_INDENTIFIER];
    
    if (!cell) {
        cell = [[MNBaseTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_INDENTIFIER];
    }
    
    //先重置右侧样式
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.accessoryView = nil;
    
    switch (indexPath.section) {
        case 0: //电量
        {
            cell.textLabel.text = NSLocalizedString(@"电量", nil);
            cell.accessoryView = self.DElectricView;
        }
            break;
        case 1:
        {
            switch (indexPath.row) {
                case 0: //固件升级
                {
                    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                    cell.textLabel.text = NSLocalizedString(@"固件升级", nil);
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    [cell.contentView addSubview:self.DFirmwareVersionLabel];
                }
                    break;
                case 1: //解绑
                {
                    cell.textLabel.text = [MNFirmwareModel sharestance].number;
                    cell.accessoryView = self.DRemoveBindingBtn;
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 2:
        {
           if ([self.DFunctionArr3[indexPath.row] isEqualToString:@"LIGHT"]){ //指示灯设定
                cell.textLabel.text = NSLocalizedString(@"指示灯颜色", nil);
                cell.accessoryView = self.DLightColorView;
                cell.tag = 400;
            }else if ([self.DFunctionArr3[indexPath.row] isEqualToString:@"LOST"]){ //防丢
                cell.textLabel.text = NSLocalizedString(@"防丢", nil);
                cell.accessoryView = self.DLostSwitch;
            }else if ([self.DFunctionArr3[indexPath.row] isEqualToString:@"NOTICE"]){ //来电提醒
                cell.textLabel.text = NSLocalizedString(@"来电提醒", nil);
                cell.accessoryView = self.DPhoneCallSwitch;
            }else if ([self.DFunctionArr3[indexPath.row] isEqualToString:@"PHOTOGRAPH"]) { //拍照
                cell.textLabel.text = NSLocalizedString(@"咔擦拍拍拍", nil);
                cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.tag = 500;
            }else if([self.DFunctionArr3[indexPath.row] isEqualToString:@"FINDEQ"]) { //查找设备
                cell.textLabel.text = NSLocalizedString(@"查找设备", nil);
                cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.tag = 600;
            }
        }
            break;
        default:
            break;
    }
    
    return cell;
}

@end