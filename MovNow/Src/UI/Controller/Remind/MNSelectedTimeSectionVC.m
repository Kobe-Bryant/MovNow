//
//  SelectedTimeSection_ViewController.m
//  Q2
//
//  Created by MYBrother on 14-8-14.
//  Copyright (c) 2014年 MYBrother. All rights reserved.
//

#import "MNSelectedTimeSectionVC.h"
#import "MNAdaptAlertView.h"
#import "AppDelegate.h"
#import "MNPickerView.h"
#import "NSDate+Expend.h"
#import "MNRemindService.h"


@interface MNSelectedTimeSectionVC ()
{
    __weak IBOutlet UIButton *startButton;// 开始时间设置按钮
    __weak IBOutlet UIButton *stopButton;// 结束时间设置按钮
    
    __weak IBOutlet UIButton *saveButton; // 确认按钮
    
    
    NSMutableArray *_hourArr;
    NSMutableArray *_minArr;
    
    MNPickerView *_hourPicker;
    MNPickerView *_minPicker;
    
}

@end

@implementation MNSelectedTimeSectionVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void)resetImages{

    [startButton setBackgroundImage:[UIImage imageNamed:@"MN_list"] forState:UIControlStateNormal];
    [startButton setBackgroundImage:[UIImage imageNamed:@"MN_list_press"] forState:UIControlStateSelected];
    
    [stopButton setBackgroundImage:[UIImage imageNamed:@"MN_list"] forState:UIControlStateNormal];
    [stopButton setBackgroundImage:[UIImage imageNamed:@"MN_list_press"] forState:UIControlStateSelected];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self resetImages];
    //时
    _hourArr = [[NSMutableArray alloc] init];
    for (int i = 0; i <= 23; i++) {
        [_hourArr addObject:[NSString stringWithFormat:@"%02d",i]];
    }
    _hourPicker = [[MNPickerView alloc] initWithFrame:CGRectMake(50, SCREEN_HEIGHT-250, 110, 190) andDataArr:_hourArr];
    _hourPicker.value = [NSString stringWithFormat:@"%d",[NSDate getCurrentHour]];
    
    //分
    _minArr = [[NSMutableArray alloc] init];
    for (int i = 0; i <= 59; i++) {
        [_minArr addObject:[NSString stringWithFormat:@"%02d",i]];
    }
    _minPicker = [[MNPickerView alloc] initWithFrame:CGRectMake(160, SCREEN_HEIGHT-250, 110, 190) andDataArr:_minArr];
    _minPicker.value = [NSString stringWithFormat:@"%d",[NSDate getCurrentMin]];
    
    
    [self.view addSubview:_hourPicker];
    [self.view addSubview:_minPicker];
    
    if (SCREEN_HEIGHT < 568) {
        saveButton.frame = CGRectMake(220, 280, 100, 50);
    }
    
    [self.view bringSubviewToFront:saveButton];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"保存", nil)  style:UIBarButtonItemStylePlain target:self action:@selector(saveTime)];
    
    //默认展示的是当前时间-18:00
    [startButton setTitle:[NSString stringWithFormat:@"%@:%@",_hourPicker.value,_minPicker.value] forState:UIControlStateNormal];
    [stopButton setTitle:@"18:00" forState:UIControlStateNormal];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pickerBeginScroll) name:PICKERBEGINSCROLL object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pickerEndScroll) name:PICKERENDSCROLL object:nil];

}

- (IBAction)saveStartAndStopTime:(UIButton *)button{
    
    if (startButton.selected) {
        [startButton setTitle:[NSString stringWithFormat:@"%@:%@",_hourPicker.value,_minPicker.value] forState:UIControlStateNormal];
        startButton.selected = !startButton.selected;
        stopButton.selected = !stopButton.selected;
        return;
    }
    
    if (stopButton.selected) {
        [stopButton setTitle:[NSString stringWithFormat:@"%@:%@",_hourPicker.value,_minPicker.value] forState:UIControlStateNormal];
        startButton.selected = !startButton.selected;
        stopButton.selected = !stopButton.selected;
        return;
    }
    
}

- (void)saveTime
{
    NSString *startTime = startButton.titleLabel.text;
    NSString *stopTime = stopButton.titleLabel.text;
    NSArray *startArr = [startTime componentsSeparatedByString:@":"];
    NSArray *stopArr = [stopTime componentsSeparatedByString:@":"];
    
    if ([startTime isEqualToString:stopTime]) {
        MNAdaptAlertView *aler = [[MNAdaptAlertView alloc] initStyleZeroWithMessage:NSLocalizedString(@"开始时间与结束时间一致，请重新选择。",nil) andBlock:^(MNAdaptAlertView *alertView, int buttonIndex) {
            
        }];
        
        [aler show];
        return;
    }
    if ([startArr[0] integerValue] > [stopArr[0] integerValue]) {
        MNAdaptAlertView *aler =[[MNAdaptAlertView alloc] initStyleZeroWithMessage:NSLocalizedString(@"开始时间在结束时间之后，请重新选择。",nil) andBlock:^(MNAdaptAlertView *alertView, int buttonIndex) {
            
        }];
        
        [aler show];
        return;
        
    } else if ([startArr[0] integerValue] == [stopArr[0] integerValue] && [startArr[1] integerValue] > [stopArr[1] integerValue]){
        MNAdaptAlertView *aler = [[MNAdaptAlertView alloc] initStyleZeroWithMessage:NSLocalizedString(@"开始时间在结束时间之后，请重新选择。",nil) andBlock:^(MNAdaptAlertView *alertView, int buttonIndex) {
            
        }];
        
        [aler show];
        return;
    }
    
    //删除以前注册的通知
    NSArray *notiArr = [[UIApplication sharedApplication] scheduledLocalNotifications];
    for (UILocalNotification *temp in notiArr) {
        if ([[temp.userInfo objectForKey:@"Sedentary"] isEqualToString:@"Sedentary"]) {
            [[UIApplication sharedApplication] cancelLocalNotification:temp];
        }
    }
    
    [self.delegate setSectionOfTimeLabelText:[NSString stringWithFormat:@"%@-%@",startTime,stopTime]];
    
    
    
    [self.navigationController popViewControllerAnimated:YES];
//    NSLog(@"保存久坐提醒成功");

}

- (void)pickerBeginScroll{
    saveButton.enabled = NO;
}

- (void)pickerEndScroll{
    saveButton.enabled = YES;
}


//切换两个按钮的选择状态
- (IBAction)selectedSedentaryTime:(UIButton *)sender {
    if (sender.tag == 1 && !sender.selected) {
        sender.selected = !sender.selected;
        stopButton.selected = !sender.selected;
    } else if (sender.tag == 2 && !sender.selected){
        sender.selected = !sender.selected;
        startButton.selected = !sender.selected;
    }
   
}


@end
