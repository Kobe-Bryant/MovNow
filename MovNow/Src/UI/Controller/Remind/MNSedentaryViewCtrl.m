//
//  Sedentary_ViewController.m
//  Q2
//
//  Created by L-Q on 15/4/29.
//  Copyright (c) 2015年 ___Veclink___. All rights reserved.
//


#import "MNSedentaryViewCtrl.h"
#import "MNPickerView.h"
#import "NSDate+Expend.h"
#import "AppDelegate.h"
#import "MNSelectedTimeSectionVC.h"
#import "MNRemindService.h"

@interface MNSedentaryViewCtrl () <SelectedSectionOfTimeDelagate>
{
    __weak IBOutlet UILabel *sectionOfTimeLabel;// 提醒时间段
    __weak IBOutlet UISwitch *setSwitch; // 提醒开关
    

    __weak IBOutlet UIButton *selectButton;// 时长设置按钮
    __weak IBOutlet UIButton *setTimeButton;// 久坐时间段设置按钮
    
    IBOutlet UIView *BGPickView;
    IBOutlet UIView *greyView;
    __weak IBOutlet UIButton *saveButton;// 时长选择确认按钮
    
    MNPickerView *_picker;
    NSMutableArray *_pickerArr;
    
    int temp; // 久坐提醒时间间隔
    NSNumber *openType; // 开关状态
    NSString *sed;// 起身时间段
    

}

@end

@implementation MNSedentaryViewCtrl

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


// 设置图片
- (void)resetImages{
    
    [selectButton setBackgroundImage:[UIImage imageNamed:@"MN_list"] forState:UIControlStateNormal];
    [selectButton setBackgroundImage:[UIImage imageNamed:@"MN_list_press"] forState:UIControlStateHighlighted];
    
    [setTimeButton setBackgroundImage:[UIImage imageNamed:@"MN_list"] forState:UIControlStateNormal];
    [setTimeButton setBackgroundImage:[UIImage imageNamed:@"MN_list_press"] forState:UIControlStateHighlighted];
    
    
    [saveButton setImage:[UIImage imageNamed:@"MN_sure"] forState:UIControlStateNormal];
    [saveButton setImage:[UIImage imageNamed:@"MMN_sure_press"] forState:UIControlStateHighlighted];

}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self resetImages];
    
    // 提醒时间段
    sed = [MNRemindService shareInstance].sedentary;
    sectionOfTimeLabel.text = sed;
    DLog(@"-----------------------%@",sed);
    
    
    if ([MNRemindService shareInstance].openType) {
        
        if([MNRemindService shareInstance].openType == WarnEventTypeOpen){
            setSwitch.on = YES;
            openType = [NSNumber numberWithInt:0];
        }else{
            setSwitch.on = NO;
            openType = [NSNumber numberWithInt:1];
        }
    }else{
        
        setSwitch.on = NO;// 默认
        openType = [NSNumber numberWithInt:1];
    }
    
    
    if([MNRemindService shareInstance].interval){
        temp = [[MNRemindService shareInstance].interval intValue];
    }else{
        
        temp = 25;//默认
    }
        NSString *str = [NSString stringWithFormat:NSLocalizedString(@"%@分钟起身", nil),[NSString stringWithFormat:@"%d",temp]];
    
    [selectButton setTitle:str forState:UIControlStateNormal];
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        _pickerArr = [[NSMutableArray alloc] init];
        [_pickerArr addObject:@"25"];
        [_pickerArr addObject:@"50"];
        [_pickerArr addObject:@"75"];
        [_pickerArr addObject:@"100"];
        [_pickerArr addObject:@"125"];
        _picker = [[MNPickerView alloc] initWithFrame:CGRectMake(0, 45, 320, 200) andDataArr:_pickerArr];
        _picker.value = @"1";
        [BGPickView addSubview:_picker];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pickerBeginScroll) name:PICKERBEGINSCROLL object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pickerEndScroll) name:PICKERENDSCROLL object:nil];
    });
}



- (IBAction)selectButtonPressed:(UIButton *)sender {
    greyView.frame = CGRectMake(0, 0, 320, 568);
    greyView.alpha = 0;
    BGPickView.frame = CGRectMake(0, SCREEN_HEIGHT, 320, 260);
    [self.view addSubview:greyView];
    [self.view addSubview:BGPickView];
    [self animation];
}

- (void)animation{
    [UIView animateWithDuration:0.3 animations:^{
        greyView.alpha = 0.4;
        BGPickView.frame = CGRectMake(0, SCREEN_HEIGHT-260, 320, 260);
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UIView *view = [[touches anyObject] view];
    if (view == greyView) {
        [self removePicker];
    }
}

- (void)removePicker{
    [UIView animateWithDuration:0.3 animations:^{
        BGPickView.frame = CGRectMake(0, SCREEN_HEIGHT, 320, 260);
        greyView.alpha = 0;
    } completion:^(BOOL finished) {
        [BGPickView removeFromSuperview];
        [greyView removeFromSuperview];
    }];
}

- (IBAction)saveButtonClick:(UIButton *)sender {
    
    
    [self removePicker];
    
    NSArray *time = [sectionOfTimeLabel.text componentsSeparatedByString:@"-"];
    NSArray *startTime = [time[0] componentsSeparatedByString:@":"];
    NSArray *endTime = [time[1] componentsSeparatedByString:@":"];
    
    int S_Hour = [startTime[0] intValue];
    int S_Min = [startTime[1] intValue];
    
    int E_Hour = [endTime[0] intValue];
    int E_Min = [endTime[1] intValue];

    MNRemindService *mind = [MNRemindService shareInstance];
    
    if ((temp != [_picker.value intValue]) && (openType == [NSNumber numberWithInt:0])) {
        
        // 先关闭以前的提醒事件再开启新的提醒事件
        int interval = temp;
        [mind SedentaryWarnWithWarnEventType:WarnEventTypeClose withDuration:interval withStartHour:S_Hour withStartMin:S_Min withEndHour:E_Hour withEndMin:E_Min withSuccess:^{
        
            NSString *str = [NSString stringWithFormat:NSLocalizedString(@"%@分钟起身", nil),_picker.value];
            [selectButton setTitle:str forState:UIControlStateNormal];
            int interval = [_picker.value intValue];//改变的时间间隔
            
            [mind SedentaryWarnWithWarnEventType:WarnEventTypeOpen withDuration:interval withStartHour:S_Hour withStartMin:S_Min withEndHour:E_Hour withEndMin:E_Min withSuccess:^{
                
                DLog(@"——————————————————同步久坐提醒成功");

                
            } withFailure:^(NSString *failure){
                
                [self.view showHUDWithStr:NSLocalizedString(@"同步久坐提醒失败",nil) hideAfterDelay:3.0];
            }];
            
        } withFailure:^(NSString *failure){
            
             [self.view showHUDWithStr:NSLocalizedString(@"同步久坐提醒失败",nil) hideAfterDelay:3.0];
        }];
    }

}



- (IBAction)onSelectedTimeButtonPressed:(UIButton *)sender {
    MNSelectedTimeSectionVC *selectTime = [[MNSelectedTimeSectionVC alloc] init];
    selectTime.delegate = self;
    [self.navigationController pushViewController:selectTime animated:YES];
}

// 起身时间开关
- (IBAction)switchAction:(UISwitch *)sender {
    
    UISwitch *switchBtn = (UISwitch *)sender;
    BOOL isBtnOn = [switchBtn isOn];// 开启状态
    
    
    NSArray *time = [sectionOfTimeLabel.text componentsSeparatedByString:@"-"];
    NSArray *startTime = [time[0] componentsSeparatedByString:@":"];
    NSArray *endTime = [time[1] componentsSeparatedByString:@":"];
    
    int S_Hour = [startTime[0] intValue];
    int S_Min = [startTime[1] intValue];
    
    int E_Hour = [endTime[0] intValue];
    int E_Min = [endTime[1] intValue];
    int interval = temp;
     MNRemindService *mind = [MNRemindService shareInstance];
    
    
    if (isBtnOn) {
        
        NSNumber *interVal = [NSNumber numberWithInt:interval];
        openType = [NSNumber numberWithInt:0];
        
        [mind SedentaryWarnWithWarnEventType:WarnEventTypeOpen withDuration:interval withStartHour:S_Hour withStartMin:S_Min withEndHour:E_Hour withEndMin:E_Min withSuccess:^{
            
              DLog(@"--------同步提醒数据成功");
          //  [mind updateWithSedentary:sed withInterval:interVal withRemindType:openType];// 保存更改开关状态后的数据
            
        } withFailure:^(NSString *message){
            
              [self.view showHUDWithStr:NSLocalizedString(@"同步久坐提醒失败",nil) hideAfterDelay:3.0];
            
        }];
        
    }else{
        
        NSNumber *interVal = [NSNumber numberWithInt:interval];
        openType = [NSNumber numberWithInt:1];
        
        [mind SedentaryWarnWithWarnEventType:WarnEventTypeClose withDuration:interval withStartHour:S_Hour withStartMin:S_Min withEndHour:E_Hour withEndMin:E_Min withSuccess:^{
            
          //  [mind updateWithSedentary:sed withInterval:interVal withRemindType:openType]; // 保存更改开关状态后的数据
            DLog(@"--------同步提醒数据成功");

        } withFailure:^(NSString *message){
        
             [self.view showHUDWithStr:NSLocalizedString(@"同步久坐提醒失败",nil) hideAfterDelay:3.0];
            
        }];
    
    }

    
}

#pragma mark - SelectedSectionOfTimeDelagate // 代理改变提醒时间段

- (void)setSectionOfTimeLabelText:(NSString *)text{
    
     sectionOfTimeLabel.text = text;
    
    if (openType == [NSNumber numberWithInt:0]) {
        
        NSArray *time = [text componentsSeparatedByString:@"-"];
        
        NSArray *startTime = [time[0] componentsSeparatedByString:@":"];
        NSArray *endTime = [time[1] componentsSeparatedByString:@":"];
        
        int S_Hour = [startTime[0] intValue];
        int S_Min = [startTime[1] intValue];
        
        int E_Hour = [endTime[0] intValue];
        int E_Min = [endTime[1] intValue];
        if (time.count == 2) {
            int interval = temp;
            
        
            MNRemindService *mind = [MNRemindService shareInstance];
            [mind SedentaryWarnWithWarnEventType:WarnEventTypeOpen withDuration:interval withStartHour:S_Hour withStartMin:S_Min withEndHour:E_Hour withEndMin:E_Min withSuccess:^{
                
                sectionOfTimeLabel.text = text;
            
            } withFailure:^(NSString *message){
            
                [self.view showHUDWithStr:NSLocalizedString(@"同步久坐提醒失败",nil)];
            }];
            
        }
    }
}

- (void)pickerBeginScroll{
    saveButton.enabled = NO;
}

- (void)pickerEndScroll{
    saveButton.enabled = YES;
}

#pragma mark - 返回文字
- (NSString *)backBarItemText
{
    return NSLocalizedString(@"返回", nil);
}

- (void)viewWillDisappear:(BOOL)animated
{
    sed = sectionOfTimeLabel.text;
}

@end
