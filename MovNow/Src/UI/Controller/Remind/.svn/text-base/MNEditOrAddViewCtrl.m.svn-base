//
//  MNEditOrAddViewCtrl.m
//  Movnow
//
//  Created by L-Q on 15/4/27.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//

#import "MNEditOrAddViewCtrl.h"
#import "MNPickerView.h"
#import "MNAdaptAlertView.h"
#import "MNWeekPicker.h"
#import "MNRemindService.h"

@interface MNEditOrAddViewCtrl (){

    NSArray *_weekArr;
    UILabel *_label;
    
    MNPickerView *_hourPicker;
    MNPickerView *_minPicker;
    
    int hourValue;
    int minValue;
    
    NSMutableArray *_hourArr;
    NSMutableArray *_minArr;
    

    MNWeekPicker *_weekPicker;
    
}

@end

@implementation MNEditOrAddViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"保存", nil) style:UIBarButtonItemStylePlain target:self action:@selector(saveMind)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(datePickerValueChange) name:PICKERENDSCROLL object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pickerViewbeginScroll) name:PICKERBEGINSCROLL object:nil];
    
    _label = [[UILabel alloc] initWithFrame:CGRectMake(15, 330, 290, 120)];
    _label.numberOfLines = 0;
    _label.font = [UIFont systemFontOfSize:13.0];
    _label.textColor = [UIColor colorWithRed:135.0/255 green:135.0/255 blue:135.0/255 alpha:1.0];
    
    UILabel *_editTypeLabel;
    _editTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 80, 290, 20)];
    _editTypeLabel.textColor = [UIColor colorWithRed:98/255.0 green:118/255.0 blue:128/255.0 alpha:1.0];
    _editTypeLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:_editTypeLabel];
    
    
    //时
    _hourArr = [[NSMutableArray alloc] init];
    for (int i = 0; i <= 23; i++) {
        [_hourArr addObject:[NSString stringWithFormat:@"%02d",i]];
    }
    _hourPicker = [[MNPickerView alloc] initWithFrame:CGRectMake(50, 125, 110, 200) andDataArr:_hourArr];
   
    _hourPicker.value = [NSString stringWithFormat:@"%d",[NSDate getCurrentHour]];
//     hourValue = [NSDate getCurrentHour];
    
    //分
    _minArr = [[NSMutableArray alloc] init];
    for (int i = 0; i <= 59; i++) {
        [_minArr addObject:[NSString stringWithFormat:@"%02d",i]];
    }
    _minPicker = [[MNPickerView alloc] initWithFrame:CGRectMake(160, 125, 110, 200) andDataArr:_minArr];

    _minPicker.value = [NSString stringWithFormat:@"%d",[NSDate getCurrentMin]];
//    minValue = [NSDate getCurrentMin];
    
    
    [self.view addSubview:_hourPicker];
    [self.view addSubview:_minPicker];
    
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 110, 320, 1)];
    line1.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:line1];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 340, 320, 1)];
    line2.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:line2];
    

    
    //判断添加/编辑、喝水/起床，四种情况，对页面进行调整
    switch (_editType) {
        case EditRemindTime_Add:
        {
            if ([MNRemindService shareInstance].remindTpye == RemindTypeDrink) {
                _editTypeLabel.text = NSLocalizedString(@"添加一个喝水提醒",nil);
                [self.view addSubview:_label];
            } else {
                _editTypeLabel.text = NSLocalizedString(@"添加一个起床闹钟",nil);
                
                [self setBottomView];
            }
        }
            break;
        case EditRemindTime_Edit:
        {
            if ([MNRemindService shareInstance].remindTpye == RemindTypeDrink) {
                _editTypeLabel.text = NSLocalizedString(@"编辑喝水提醒",nil);
                
                [self.view addSubview:_label];
            } else {
                _editTypeLabel.text = NSLocalizedString(@"编辑起床闹钟",nil);
                [self setBottomView];
            }
        }
            break;
            
        default:
            break;
    }
    
    [self datePickerValueChange];

}


- (void)setBottomView{
    /*
     //自定义控件，重复周期选择器
     _weekPicker = [[WeekPicker alloc] initWithFrame:CGRectMake(15, 360, 290, 75)];
     [self.view addSubview:_weekPicker];
     
     UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 450, 320, 1)];
     line.backgroundColor = [UIColor lightGrayColor];
     [self.view addSubview:line];
     
     UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 450, 290, 88)];
     label.numberOfLines = 0;
     label.text = NSLocalizedString(@"一个人的睡眠质量是通过其深睡时长来决定的，当人进入深睡状态时，大脑皮层才能够得到充分的休息，深睡时长所以也叫黄金睡眠。",nil);
     label.font = [UIFont systemFontOfSize:13.0];
     label.textColor = [UIColor colorWithRed:135.0/255 green:135.0/255 blue:135.0/255 alpha:1.0];
     [self.view addSubview:label];
     
     if (SCREEN_HEIGHT < 568) {
     _weekPicker.frame = CGRectMake(15, 350, 290, 75);
     line.frame = CGRectMake(0, 430, 320, 1);
     label.frame = CGRectMake(15, 415, 290, 88);
     //        label.font = [UIFont systemFontOfSize:10];
     }
     */
}


- (void)pickerViewbeginScroll
{
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

- (void)datePickerValueChange{
    
    if ([_hourPicker.value integerValue] == 6) {
        
        _label.text = NSLocalizedString(@"喝水起床后", nil);
    } else if ([_hourPicker.value intValue] == 8) {
        _label.text = NSLocalizedString(@"喝水上班前", nil);
    } else if ([_hourPicker.value intValue] == 10) {
        _label.text = NSLocalizedString(@"喝水上午上班时", nil);
    } else if ([_hourPicker.value intValue] == 11 && [_hourPicker.value intValue] >= 30) {
        _label.text = NSLocalizedString(@"喝水饭前半小时", nil);
    } else if ([_hourPicker.value intValue] == 15) {
        _label.text = NSLocalizedString(@"喝水下午上班时", nil);
    } else if (([_hourPicker.value intValue] == 17 && [_hourPicker.value intValue] >= 30) || ([_hourPicker.value intValue] == 18 && [_hourPicker.value intValue] <= 30) ) {
        _label.text = NSLocalizedString(@"喝水下班前或者吃饭前半小时", nil);
    } else if ([_hourPicker.value intValue] == 20) {
        _label.text = NSLocalizedString(@"喝水洗澡后", nil);
    } else if ([_hourPicker.value intValue] == 22) {
        _label.text = NSLocalizedString(@"喝水睡觉前半小时", nil);
    } else {
        _label.text = NSLocalizedString(@"喝水小知识", nil);
    }
    self.navigationItem.rightBarButtonItem.enabled = YES;
}


#pragma mark - 保存提醒操作
- (void)saveMind
{
    switch (_editType) {
        case EditRemindTime_Add: //新增提醒
        {
            if ([MNRemindService shareInstance].remindTpye == RemindTypeDrink) {
                for (NSString *str in [MNRemindService shareInstance].drinkReminds) {
                    NSString *time = [str substringToIndex:5];
                    if ([time isEqualToString:[NSString stringWithFormat:@"%@:%@",_hourPicker.value,_minPicker.value]]) {
                        MNAdaptAlertView *alert = [[MNAdaptAlertView alloc] initStyleZeroWithMessage:NSLocalizedString(@"提醒队列中以有该时间，请选择其他时间。",nil) andBlock:^(MNAdaptAlertView *alertView, int buttonIndex) {
                                                    }];
                        [alert show];
                        return;
                    }
                }
                
                hourValue = [_hourPicker.value intValue];
                minValue = [_minPicker.value intValue];
                
                MNRemindService *mind = [MNRemindService shareInstance];
                
                [mind addDrinkRemindWithHour:hourValue withMin:minValue withSuccess:^{
                
                    [self registrLocalNotification:[NSString stringWithFormat:@"%@:%@",_hourPicker.value,_minPicker.value]];
                    [self.navigationController popViewControllerAnimated:YES];
                
                } withFailure:^(NSString *failure){
                    
                    [self.view showHUDWithStr:NSLocalizedString(@"同步提醒失败",nil) hideAfterDelay:3.0];
                }];

                
//                [mind startWithRemindType:RemindTypeDrink withWarnEventType:WarnEventTypeOpen withHour:hourValue withMin:minValue withSuccess:^{
//                    
//                    [self registrLocalNotification:[NSString stringWithFormat:@"%@:%@",_hourPicker.value,_minPicker.value]];
//                    [_tempRemindArr addObject:[NSString stringWithFormat:@"%@:%@",_hourPicker.value,_minPicker.value]];
//                    
//
//                    [self.navigationController popViewControllerAnimated:YES];
//                
//                } withFailure:^(NSString *message){
//                
//                [self.view showHUDWithStr:NSLocalizedString(@"同步提醒失败",nil) hideAfterDelay:3.0];
//                
//                }];
                
                
            } else {
                
                for (NSString *str in [MNRemindService shareInstance].clockReminds) {
                    NSString *time = [str substringToIndex:5];
                    if ([time isEqualToString:[NSString stringWithFormat:@"%@:%@",_hourPicker.value,_minPicker.value]]) {
                        MNAdaptAlertView *alert = [[MNAdaptAlertView alloc] initStyleZeroWithMessage:NSLocalizedString(@"提醒队列中以有该时间，请选择其他时间。",nil) andBlock:^(MNAdaptAlertView *alertView, int buttonIndex) {
                            
                        }];
                        [alert show];
                        return;
                    }
                }
                
                hourValue = [_hourPicker.value intValue];
                minValue = [_minPicker.value intValue];
                
                MNRemindService *mind = [MNRemindService shareInstance];
                [mind addClockRemindWithHour:hourValue withMin:minValue withSuccess:^{
                
                    [self registrLocalNotification:[NSString stringWithFormat:@"%@:%@",_hourPicker.value,_minPicker.value]];
                    [self.navigationController popViewControllerAnimated:YES];
                    
                } withFailure:^(NSString *message){
                    
                    [self.view showHUDWithStr:NSLocalizedString(@"同步提醒失败",nil) hideAfterDelay:3.0];
                    
                }];
                
                
                
//                [mind startWithRemindType:RemindTypeClock withWarnEventType:WarnEventTypeOpen withHour:hourValue withMin:minValue withSuccess:^{
//                
//                     [self registrLocalNotification:[NSString stringWithFormat:@"%@:%@",_hourPicker.value,_minPicker.value]];
//        
//                    [_tempRemindArr addObject:[NSString stringWithFormat:@"%@:%@",_hourPicker.value,_minPicker.value]];
//
//                    [self.navigationController popViewControllerAnimated:YES];
//                
//                } withFailure:^(NSString *message){
//                
//                    [self.view showHUDWithStr:NSLocalizedString(@"同步提醒失败",nil) hideAfterDelay:3.0];
//                
//                }];
                
            }
        }
            break;
            
        case EditRemindTime_Edit: //编辑提醒
        {
//            if ([MNRemindService shareInstance].remindTpye == RemindTypeDrink) {
//                
//                for (int i = 0; i < _tempRemindArr.count;i++) {
//                    NSString *str = _tempRemindArr[i];
//                    NSString *time = [str substringToIndex:5];
//                    if ([time isEqualToString:[NSString stringWithFormat:@"%@:%@",_hourPicker.value,_minPicker.value]] && i != _index ) {
//                        MNAdaptAlertView *alert = [[MNAdaptAlertView alloc] initStyleZeroWithMessage:NSLocalizedString(@"提醒队列中以有该时间，请选择其他时间。",nil) andBlock:^(MNAdaptAlertView *alertView, int buttonIndex) {
//                            
//                        }];
//                        [alert show];
//                        return;
//                    }
//                }
//                NSArray *comp = [[_tempRemindArr[_index] substringToIndex:5] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@":"]];
//                
//                
//                int compValue1 = [comp[0] intValue];
//                int compValue2 = [comp[1] intValue];
//                
//                MNRemindService *mind = [MNRemindService shareInstance];
//            
//                
//                [mind startWithRemindType:RemindTypeDrink withWarnEventType:WarnEventTypeClose withHour:compValue1 withMin:compValue2 withSuccess:^{
//                
//                    [mind startWithRemindType:RemindTypeDrink withWarnEventType:WarnEventTypeOpen withHour:hourValue withMin:minValue withSuccess:^{
//                    
//                        [self deleteLocalNotification:[_tempRemindArr[_index] substringToIndex:5]];
//                    
//                        [_tempRemindArr removeObjectAtIndex:_index];
//                        
//                        [self registrLocalNotification:[NSString stringWithFormat:@"%@:%@",_hourPicker.value,_minPicker.value]];
//                        [_tempRemindArr insertObject:[NSString stringWithFormat:@"%@:%@",_hourPicker.value,_minPicker.value] atIndex:_index];
//                        
//                      
//                        [self.navigationController popViewControllerAnimated:YES];
            
                    
//                    } withFailure:^(NSString *message){
                        
//                          [self.view showHUDWithStr:NSLocalizedString(@"同步提醒失败",nil) hideAfterDelay:3.0];
                    
//                    }];
                    
                
//                } withFailure:^(NSString *message){
            
//                        [self.view showHUDWithStr:NSLocalizedString(@"同步提醒失败",nil) hideAfterDelay:3.0];
                
//                }];
                
                
                
//            } else {
//                
//                for (int i = 0; i < [[MNRemindService shareInstance].clockReminds count];i++) {
//                    NSString *str = [MNRemindService shareInstance].clockReminds[i];
//                    NSString *time = [str substringToIndex:5];
//                    if ([time isEqualToString:[NSString stringWithFormat:@"%@:%@",_hourPicker.value,_minPicker.value]] && i != _index ) {
//                        MNAdaptAlertView *alert = [[MNAdaptAlertView alloc] initStyleZeroWithMessage:NSLocalizedString(@"提醒队列中以有该时间，请选择其他时间。",nil) andBlock:^(MNAdaptAlertView *alertView, int buttonIndex) {
//                            
//                        }];
//                        [alert show];
//                        return;
//                    }
//                }
//                
//                NSArray *comp = [[[MNRemindService shareInstance].clockReminds[_index] substringToIndex:5] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@":"]];
//                int compValue1 = [comp[0] intValue];
//                int compValue2 = [comp[1] intValue];
//                
//                MNRemindService *mind = [MNRemindService shareInstance];
//            
//                
//                [mind startWithRemindType:RemindTypeClock withWarnEventType:WarnEventTypeClose withHour:compValue1 withMin:compValue2 withSuccess:^{
//                    
//                    [mind startWithRemindType:RemindTypeClock withWarnEventType:WarnEventTypeOpen withHour:hourValue withMin:minValue withSuccess:^{
//                        
//                        [self deleteLocalNotification:[[MNRemindService shareInstance].clockReminds[_index] substringToIndex:5]];
//                        [_tempRemindArr removeObjectAtIndex:_index];
//                        
//                        [self registrLocalNotification:[NSString stringWithFormat:@"%@:%@",_hourPicker.value,_minPicker.value]];
//                        
//                        [_tempRemindArr insertObject:[NSString stringWithFormat:@"%@:%@",_hourPicker.value,_minPicker.value] atIndex:_index];
//                        
//
//                        
//                        [self.navigationController popViewControllerAnimated:YES];
//                        
//                        
//                    } withFailure:^(NSString *message){
//                        
//                         [self.view showHUDWithStr:NSLocalizedString(@"同步提醒失败",nil) hideAfterDelay:3.0];
//                    }];
//                    
//                    
//                } withFailure:^(NSString *message){
//                    
//                    [self.view showHUDWithStr:NSLocalizedString(@"同步提醒失败",nil) hideAfterDelay:3.0];
//                }];

//            }
            
        }
            break;
        default:
            break;
    }
}

#pragma mark - 注册、删除本地通知
- (void)registrLocalNotification:(NSString *)time
{
    
    //    [self sendRemindCommdWithTime:time andSwitch:YES];
    
    //创建通知相关
    int hour = [NSDate getCurrentHour];
    int min = [NSDate getCurrentMin];
    int sec = [NSDate getCurrentSecond];
    
    NSArray *comp = [time componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@":"]];
    int setHour=[comp[0] intValue];
    int setMin=[comp[1] intValue];
    
    int hs=setHour-hour;
    int ms=setMin-min;
    
    if(ms<0)
    {
        ms=ms+60;
        hs--;
    }
    
    if(hs<0)
    {
        hs=hs+24;
    }
    
    //计算hm的值，hm为当前时间与通知时间的间隔秒数
    int hm=(hs*3600)+(ms*60)-sec;
    UILocalNotification *notification=[[UILocalNotification alloc] init];
    if (notification)
    {
        NSDate *now=[NSDate new];
        notification.userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@%ld",time,[MNRemindService shareInstance].remindTpye],@"date", nil];//将时间和循环周期作为唯一标识符，方便以后进行删除
        notification.fireDate=[now dateByAddingTimeInterval:hm];//hm秒后通知
        notification.timeZone=[NSTimeZone defaultTimeZone];
        notification.applicationIconBadgeNumber = 1; //APP角标
        notification.soundName= UILocalNotificationDefaultSoundName;//声音，可以换成notification.soundName = @"myMusic.caf"
        NSString *message;
        if ([MNRemindService shareInstance].remindTpye == RemindTypeDrink) {
            message = NSLocalizedString(@"该喝水了",nil);
        } else {
            message = NSLocalizedString(@"该起床了",nil);
        }
        //去掉下面2行就不会弹出提示框
        notification.alertBody=message;//提示信息 弹出提示框
        notification.alertAction = NSLocalizedString(@"打开",nil);  //提示框按钮
        notification.hasAction = YES; //是否显示额外的按钮，为no时alertAction消失
        
        notification.repeatInterval=kCFCalendarUnitDay;//循环次数，kCFCalendarUnitDay一天一次
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];//注册通知
    }
}

- (void)deleteLocalNotification:(NSString *)time
{
    NSString *delDate = [NSString stringWithFormat:@"%@%ld",time,[MNRemindService shareInstance].remindTpye];
    NSArray *notiArr = [[UIApplication sharedApplication] scheduledLocalNotifications];
    for (UILocalNotification *temp in notiArr) {
        if ([[temp.userInfo objectForKey:@"date"] isEqualToString:delDate]) {
            [[UIApplication sharedApplication] cancelLocalNotification:temp];
        }
    }
    //    [self sendRemindCommdWithTime:time andSwitch:NO];
}

@end