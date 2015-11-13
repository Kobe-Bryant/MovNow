//
//  MNSettingListViewCtrl.m
//  Movnow
//
//  Created by LiuX on 15/4/20.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//

#import "MNSettingListViewCtrl.h"
#import "MNUserInfoViewCtrl.h"
#import "MNBaseTableViewCell.h"
#import "MNSystemSettingViewCtrl.h"
#import "MNActivityTypeViewCtrl.h"
#import "MNMovementTargetViewCtrl.h"
#import "MNMyDeviceViewCtrl.h"
#import "MNDeviceBindingService.h"

#define CELL_INDENTIFIER @"CELL_INDENTIFIER"

@interface MNSettingListViewCtrl ()

/**
 *  返回按钮的文字
 */
@property (nonatomic,copy) NSString *backItemText;

@end

@implementation MNSettingListViewCtrl

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setLeftNavItem];
}

#pragma mark - 左侧按钮
- (void)setLeftNavItem
{
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 30, 30);
    [leftButton setImage:[UIImage imageNamed:IMAGE_NAME(@"btn_menu")] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:IMAGE_NAME(@"btn_menu_press")] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(leftBarButtonItemClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
}

- (void)leftBarButtonItemClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *desVC = nil;
    
    switch (indexPath.row) {
        case 0: //我的设备
        {
            if ([MNDeviceBindingService shareInstance].hadBindingDevice == YES) {
                _backItemText = @"我的设备";
                desVC = [[MNMyDeviceViewCtrl alloc]init];
            }else{
                [self.view showHUDWithStr:NSLocalizedString(@"当前无绑定的设备", nil) hideAfterDelay:kAlertWordsInterval];
            }
        }
            break;
        case 1: //我的目标
        {
            _backItemText = @"我的目标";
            desVC = [[MNMovementTargetViewCtrl alloc]initWithNibName:@"MNMovementTargetViewCtrl" bundle:nil];
        }
            break;
        case 2: //活动类型
        {
            _backItemText = @"活动类型";
            
            MNActivityTypeViewCtrl *activityTypeVC = [[MNActivityTypeViewCtrl alloc]init];
            activityTypeVC.activityType = CurrentActivityTypeDefault;
            desVC = activityTypeVC;
        }
            break;
        case 3: //设置
        {
            _backItemText = @"设置";
            desVC = [[MNSystemSettingViewCtrl alloc]init];
        }
            break;
        case 4: //个人信息
        {
            _backItemText = @"个人信息";
            desVC = [[MNUserInfoViewCtrl alloc]initWithNibName:@"MNUserInfoViewCtrl" bundle:nil];
        }
            break;
        default:
            break;
    }
    
    if (desVC != nil) {
        [self setUpBackBarItem];
        [self.navigationController pushViewController:desVC animated:YES];
    }
}

#pragma mark - 返回按钮文字
- (NSString *)backBarItemText
{
    return NSLocalizedString(_backItemText, nil);
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MNBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_INDENTIFIER];
    
    if (!cell) {
        cell = [[MNBaseTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_INDENTIFIER];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSString *cellTitle = nil;
    UIImage *cellIcon = nil;
    
    switch (indexPath.row) {
        case 0:
        {
            cellTitle = NSLocalizedString(@"我的设备", nil);
            cellIcon = [UIImage imageNamed:IMAGE_NAME(@"device_icon")];
        }
            break;
        case 1:
        {
            cellTitle = NSLocalizedString(@"我的目标", nil);
            cellIcon = [UIImage imageNamed:IMAGE_NAME(@"goal_icon")];
        }
            break;
        case 2:
        {
            cellTitle = NSLocalizedString(@"活动类型", nil);
            cellIcon = [UIImage imageNamed:IMAGE_NAME(@"sportType_icon")];
        }
            break;
        case 3:
        {
            cellTitle = NSLocalizedString(@"设置", nil);
            cellIcon = [UIImage imageNamed:IMAGE_NAME(@"set_icon")];
        }
            break;
        case 4:
        {
            cellTitle = NSLocalizedString(@"个人信息", nil);
            cellIcon = [UIImage imageNamed:IMAGE_NAME(@"profiles_icon")];
        }
            break;
        default:
            break;
    }
    
    cell.imageView.image = cellIcon;
    cell.textLabel.text = cellTitle;
    
    return cell;
}

@end