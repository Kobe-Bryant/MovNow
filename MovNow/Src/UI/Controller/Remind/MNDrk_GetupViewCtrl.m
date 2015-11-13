//
//  MNDrk_GetupViewCtrl.m
//  Movnow
//
//  Created by L-Q on 15/4/24.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//

#import "MNDrk_GetupViewCtrl.h"
#import "MNEditOrAddViewCtrl.h"
#import "MNRemindService.h"
#import "MNRemindTableViewCell.h"
#import "MNAdaptAlertView.h"




@interface MNDrk_GetupViewCtrl (){


    __weak IBOutlet UITableView *_tableView;

    NSInteger _selectRow;
    NSMutableArray *_tempWeekArr;
    
    
//    NSMutableArray *RemindsArr;// 提醒数组
    
}

@end

@implementation MNDrk_GetupViewCtrl


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    if ([MNRemindService shareInstance].remindTpye == RemindTypeDrink) {
         DLog(@"------------RemindsArr is %@",[MNRemindService shareInstance].drinkReminds);
    }else{

        DLog(@"------------RemindsArr is %@",[MNRemindService shareInstance].clockReminds);
    }
    

}

- (void)viewDidLoad {
    [super viewDidLoad];
   
   //  RemindsArr = [NSMutableArray array];// 初始化要接收保存数据的提醒事件数组
//    
//    if ([MNRemindService shareInstance].remindTpye == RemindTypeDrink) {
//        
//        RemindsArr = [NSMutableArray arrayWithArray:[MNRemindService shareInstance].drinkReminds];
//        
//    }else{
//    
//        RemindsArr = [NSMutableArray arrayWithArray:[MNRemindService shareInstance].clockReminds];
//    }
    
    _tableView.separatorStyle = UITableViewCellEditingStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    
    

    [self setUpRightBarItem];
    
    
}

- (NSString *)backBarItemText
{
    return NSLocalizedString(@"返回", nil);
}

- (void)setUpRightBarItem{
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem  alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addRemind)];
}

- (void)addRemind{

    MNEditOrAddViewCtrl *edit = [[MNEditOrAddViewCtrl alloc] init];
    
//    edit.remindsBlock = ^(NSArray *remindsArr){
//        RemindsArr = [NSMutableArray arrayWithArray:remindsArr];
//    };
//    edit.tempRemindArr = [NSMutableArray arrayWithArray:RemindsArr];
    edit.editType = EditRemindTime_Add;
    [self.navigationController pushViewController:edit animated:YES];
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 57;
    } else {
        return 52;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    MNRemindService *mind = [MNRemindService shareInstance];
    if (mind.remindTpye == RemindTypeDrink) {
        if ([mind.drinkReminds count] >= 5) {
            self.navigationItem.rightBarButtonItem.enabled = NO;
        }else{
            
            self.navigationItem.rightBarButtonItem.enabled = YES;
        }
        
        return [mind.drinkReminds count];

    }else{
    
    
        if ([mind.clockReminds count] >= 5) {
            self.navigationItem.rightBarButtonItem.enabled = NO;
        }else{
            
            self.navigationItem.rightBarButtonItem.enabled = YES;
        }
        
        return [mind.clockReminds count];
    }
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MNRemindTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@" MNRemindTableViewCell"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"MNRemindTableViewCell" owner:self options:nil][0];
    }
    if ([MNRemindService shareInstance].remindTpye == RemindTypeDrink ) {
        
        cell.drinkWaterTimeLabel.text = [MNRemindService shareInstance].drinkReminds[indexPath.row];

    }else{
    
        cell.drinkWaterTimeLabel.text = [MNRemindService shareInstance].clockReminds[indexPath.row];
    }

    
    
    [cell setOnEditButtonPress:^{
        // 禁用了点击cell的提醒事件
     //   [self onEditButtonPressedWithIndex:indexPath];
    }];
    
    [cell setOnDeleteButtonPress:^{
        [self onDeleteButtonPressedWithIndex:indexPath];
    }];
    
    return cell;
}

- (NSString *)arrayToString:(NSArray *)arr{
    NSMutableString *mstr = [[NSMutableString alloc] init];
    for (int i = 0; i < arr.count; i++) {
        if ([arr[i] boolValue]){
            switch (i) {
                case 0:
                    [mstr appendString:[NSString stringWithFormat:@"%@ ",NSLocalizedString(@"日",nil)]];
                    break;
                case 1:
                    [mstr appendString:[NSString stringWithFormat:@"%@ ",NSLocalizedString(@"一",nil)]];
                    break;
                case 2:
                    [mstr appendString:[NSString stringWithFormat:@"%@ ",NSLocalizedString(@"二",nil)]];
                    break;
                case 3:
                    [mstr appendString:[NSString stringWithFormat:@"%@ ",NSLocalizedString(@"三",nil)]];
                    break;
                case 4:
                    [mstr appendString:[NSString stringWithFormat:@"%@ ",NSLocalizedString(@"四",nil)]];
                    break;
                case 5:
                    [mstr appendString:[NSString stringWithFormat:@"%@ ",NSLocalizedString(@"五",nil)]];
                    break;
                case 6:
                    [mstr appendString:[NSString stringWithFormat:@"%@ ",NSLocalizedString(@"六",nil)]];
                    break;
                default:
                    break;
            }
        }
    }
    return mstr;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}


//push到提醒编辑页面
- (void)onEditButtonPressedWithIndex:(NSIndexPath *)indexPath{
    MNEditOrAddViewCtrl *edit = [[MNEditOrAddViewCtrl alloc] init];
    edit.editType = EditRemindTime_Edit;
    edit.index = indexPath.row;
  //  edit.tempRemindArr = [NSMutableArray arrayWithArray:RemindsArr];
    [self.navigationController pushViewController:edit animated:YES];
    _selectRow = indexPath.row;
}



//删除一条提醒记录
- (void)onDeleteButtonPressedWithIndex:(NSIndexPath *)indexPath{
    NSString *message;
    if ([MNRemindService shareInstance].remindTpye == RemindTypeDrink) {
        message = NSLocalizedString(@"您确定删除该喝水提醒吗？",nil);
    } else {
        message = NSLocalizedString(@"您确定删除该起床提醒吗？",nil);
    }
    
    
    MNAdaptAlertView *alertView = [[MNAdaptAlertView alloc] initStyleWithMessage:message andBlock:^(MNAdaptAlertView *alertView, int buttonIndex) {
        if (buttonIndex) {
            if ([MNRemindService shareInstance].remindTpye == RemindTypeDrink) {
                
                NSArray *comp = [[[MNRemindService shareInstance].drinkReminds[indexPath.row] substringToIndex:5] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@":"]];
                int hour = [comp[0] intValue];
                int min = [comp[1] intValue];
                
                MNRemindService *mind = [MNRemindService shareInstance];
                
                [mind deleteDrinkRemindWithHour:hour withMin:min withSuccess:^{
                
                    DLog(@"........%@",[MNRemindService shareInstance].drinkReminds);
                    [_tableView reloadData];
                    [self deleteLocalNotification:[[MNRemindService shareInstance].drinkReminds[indexPath.row] substringToIndex:5]];
                    
                    
                } withFailure:^(NSString *failure){
                
                    [self.view showHUDWithStr:NSLocalizedString(@"同步提醒失败",nil) hideAfterDelay:3.0];
                
                }];
                
            } else {
                
                NSArray *comp = [[[MNRemindService shareInstance].clockReminds[indexPath.row] substringToIndex:5] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@":"]];
                int hour = [comp[0] intValue];
                int min = [comp[1] intValue];
                
                MNRemindService *mind = [MNRemindService shareInstance];
                
                [mind deleteClockRemindWithHour:hour withMin:min withSuccess:^{
                
                    
                    DLog(@".........%@",[MNRemindService shareInstance].clockReminds);
                    [_tableView reloadData];
                   [ self deleteLocalNotification:[[MNRemindService shareInstance].clockReminds[indexPath.row] substringToIndex:5]];
                    
                
                } withFailure:^(NSString *failure){
                    
                    [self.view showHUDWithStr:NSLocalizedString(@"同步提醒失败",nil) hideAfterDelay:3.0];
                
                }];
    
            }
        }
    }];
    
    [alertView show];
}

- (void)deleteLocalNotification:(NSString *)time // “删除”的本地通知
{
    NSString *delDate = [NSString stringWithFormat:@"%@%ld",time,[MNRemindService shareInstance].remindTpye];
    NSArray *notiArr = [[UIApplication sharedApplication] scheduledLocalNotifications];
    for (UILocalNotification *temp in notiArr) {
        if ([[temp.userInfo objectForKey:@"date"] isEqualToString:delDate]) {
            [[UIApplication sharedApplication] cancelLocalNotification:temp];
        }
    }
}

@end