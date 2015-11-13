//
//  MNActivityTypeViewCtrl.m
//  Movnow
//
//  Created by LiuX on 15/4/23.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//

#import "MNActivityTypeViewCtrl.h"
#import "MNBaseTableViewCell.h"

#define CELL_INDENTIFIER @"CELL_INDENTIFIER"

@interface MNActivityTypeViewCtrl ()

@end

@implementation MNActivityTypeViewCtrl

- (void)viewDidLoad {
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 0;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MNBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_INDENTIFIER];
    
    if (!cell) {
        cell = [[MNBaseTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_INDENTIFIER];
        cell.textLabel.textColor = [UIColor lightGrayColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                {
                    cell.textLabel.text = NSLocalizedString(@"默认", nil);
                    if (self.activityType == CurrentActivityTypeDefault) {
                        cell.textLabel.textColor = NAV_TEXT_COLOR;
                        cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    }
                }
                    break;
                case 1:
                {
                    cell.textLabel.text = NSLocalizedString(@"步行", nil);
                    if (self.activityType == CurrentActivityTypeWalk) {
                        cell.textLabel.textColor = NAV_TEXT_COLOR;
                        cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    }
                }
                    break;
                case 2:
                {
                    cell.textLabel.text = NSLocalizedString(@"睡眠", nil);
                    if (self.activityType == CurrentActivityTypeSleep) {
                        cell.textLabel.textColor = NAV_TEXT_COLOR;
                        cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    }
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 1:
        {
            cell.textLabel.text = NSLocalizedString(@"骑车(自动切回活动模式)", nil);
            cell.textLabel.font = SUBTITLE_FONT;
        }
        default:
            break;
    }
    
    return cell;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    if (section == 0) {
//        return NSLocalizedString(@"自动切换", nil);
//    }
//    return NSLocalizedString(@"敲击三下设备或按击两下设备", nil);
//}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, SCREEN_WIDTH-15*2, 25)];
    if (section == 0) {
        lb.text = NSLocalizedString(@"自动切换", nil);
        lb.font = SUBTITLE_FONT;
    }else{
        lb.text = NSLocalizedString(@"敲击三下设备或按击两下设备", nil);
        lb.font = [UIFont systemFontOfSize:12];
    }
    [headerView addSubview:lb];
    return headerView;
}

@end
