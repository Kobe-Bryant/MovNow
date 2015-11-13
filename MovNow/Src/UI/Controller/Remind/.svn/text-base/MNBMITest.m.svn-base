//
//  BMITest.m
//  Movnow
//
//  Created by L-Q on 15/4/29.
//  Copyright (c) 2015年 ___Veclink___. All rights reserved.
//

#import "MNBMITest.h"
#import "MNPickerView.h"
#import "MNRemindService.h"

@interface MNBMITest ()
{
    MNPickerView *_agePicker;
    MNPickerView *_heiPicker;
    MNPickerView *_weiPicker;
    
    IBOutlet UIView *_ageView;
    IBOutlet UIView *_heiView;
    IBOutlet UIView *_weiVIew;
    IBOutlet UIView *_sexView;
    
    __weak IBOutlet UIButton *backButton;
    __weak IBOutlet UIButton *nextButton;
    
    __weak IBOutlet UIButton *manButton;
    __weak IBOutlet UIButton *woManButton;
    
    UILabel *_titleLabel;
    
    __weak IBOutlet UIView *bgView;
    
    __weak IBOutlet UIImageView *BMIWeiImgView;// 体重底视图
    __weak IBOutlet UIImageView *BMIHeiImgView;// 身高底视图
    __weak IBOutlet UIImageView *BMIAgeImgView;// 年龄底视图
}

@end

@implementation MNBMITest

#pragma mark - 设置图片
- (void)resetImages{
    
    BMIWeiImgView.image = [UIImage imageNamed:@"MN_bg_weight.png"];
    BMIHeiImgView.image = [UIImage imageNamed:@"MN_bg_height.png"];
    BMIAgeImgView.image = [UIImage imageNamed:@"MN_bg_avg.png"];
    
    [manButton setImage:[UIImage imageNamed:@"MN_bmi_man"] forState:UIControlStateNormal];
    [manButton setImage:[UIImage imageNamed:@"MN_bmi_man_select"] forState:UIControlStateSelected];
    
    [woManButton setImage:[UIImage imageNamed:@"MN_bmi_women"] forState:UIControlStateNormal];
    [woManButton setImage:[UIImage imageNamed:@"MN_bmi_women_select"] forState:UIControlStateSelected];
    
    [backButton setImage:[UIImage imageNamed:@"MN_bmi_previous_page"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"MN_bmi_previous_page_press"] forState:UIControlStateHighlighted];
    
    [nextButton setImage:[UIImage imageNamed:@"MN_bmi_next_page"] forState:UIControlStateNormal];
    [nextButton setImage:[UIImage imageNamed:@"MN_bmi_next_page_press"] forState:UIControlStateHighlighted];
    
}




- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self resetImages];
    
    NSMutableArray *ageghtArr = [[NSMutableArray alloc] init];
    for (int i = 5; i <= 120; i++) {
        [ageghtArr addObject:[NSString stringWithFormat:@"%d",i]];
    }
    _agePicker = [[MNPickerView alloc] initWithFrame:CGRectMake(155, 70, 160, 280) andDataArr:ageghtArr];
    _agePicker.value = @"19";
    [_ageView addSubview:_agePicker];
    
    
    if ([[U_DEFAULTS objectForKey:IS_BRITISH_SYSTEM] isEqualToString:@"1"]) {
        
        NSMutableArray *heightArr = [[NSMutableArray alloc] init];
        for (int i = 30; i <= 99; i++) {
            [heightArr addObject:[NSString stringWithFormat:@"%.1f ft",i/10.0]];
        }
        _heiPicker = [[MNPickerView alloc] initWithFrame:CGRectMake(155, 70, 160, 280) andDataArr:heightArr];
        _heiPicker.value = @"27";
        
        
        NSMutableArray *weightArr = [[NSMutableArray alloc] init];
        for (int i = 88; i <= 670; i++) {
            [weightArr addObject:[NSString stringWithFormat:@"%d lb",i]];
        }
        _weiPicker = [[MNPickerView alloc] initWithFrame:CGRectMake(155, 70, 160, 280) andDataArr:weightArr];
        _weiPicker.value = @"52";

      } else {
          
          
           NSMutableArray *heightArr = [[NSMutableArray alloc] init];
           for (int i = 99; i <= 299; i++) {
           [heightArr addObject:[NSString stringWithFormat:@"%d cm",i]];
           }
           _heiPicker = [[MNPickerView alloc] initWithFrame:CGRectMake(155, 70, 160, 280) andDataArr:heightArr];
           _heiPicker.value = @"76";
           
           
           NSMutableArray *weightArr = [[NSMutableArray alloc] init];
           for (int i = 40; i <= 99; i++) {
           [weightArr addObject:[NSString stringWithFormat:@"%d kg",i]];
           }
           _weiPicker = [[MNPickerView alloc] initWithFrame:CGRectMake(155, 70, 160, 280) andDataArr:weightArr];
           _weiPicker.value = @"30";
          
      }

    [_heiView addSubview:_heiPicker];
    [_weiVIew addSubview:_weiPicker];
    
    nextButton.tag = 1;
    
    _ageView.alpha = 0;
    _heiView.alpha = 0;
    _weiVIew.alpha = 0;
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 84, 320, 20)];
    _titleLabel.font = [UIFont systemFontOfSize:18];
    _titleLabel.textColor = [UIColor lightGrayColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_titleLabel];
    
    _titleLabel.text = NSLocalizedString(@"你的性别？", nil);
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pickerBeginScroll) name:PICKERBEGINSCROLL object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pickerEndScroll) name:PICKERENDSCROLL object:nil];
    
    if (SCREEN_HEIGHT < 568) {
        backButton.center = CGPointMake(107, 455);
        nextButton.center = CGPointMake(215, 455);
    }

}

- (IBAction)next:(UIButton *)sender {

    if (sender.tag == 1) {
        [UIView animateWithDuration:0.3 animations:^{
            backButton.alpha = 1;
            _sexView.alpha = 0;
            _ageView.alpha = 1;
            _titleLabel.text = NSLocalizedString(@"你几岁？", nil);
        }];
        sender.tag = 2;
    } else if (sender.tag == 2) {
        [UIView animateWithDuration:0.3 animations:^{
            _ageView.alpha = 0;
            _heiView.alpha = 1;
            _titleLabel.text = NSLocalizedString(@"你有多高？", nil);
        }];
        sender.tag = 3;
    } else if (sender.tag == 3) {
        [UIView animateWithDuration:0.3 animations:^{
            _heiView.alpha = 0;
            _weiVIew.alpha = 1;
            _titleLabel.text = NSLocalizedString(@"你有多重？", nil);
        }];
        sender.tag = 4;
    } else if (sender.tag == 4) {
        CGFloat bmi;
        if ([[U_DEFAULTS objectForKey:IS_BRITISH_SYSTEM] isEqualToString:@"1"]) {
            bmi = ([_weiPicker.value integerValue]/2.2046)/([_heiPicker.value floatValue]*(0.3048))/([_heiPicker.value floatValue]*(0.3048));
        } else {
            bmi = [_weiPicker.value integerValue]/([_heiPicker.value integerValue]/100.0)/([_heiPicker.value integerValue]/100.0);
        }
        NSLog(@"bmi = %f",bmi);
        [MNRemindService shareInstance].bmi = [NSString stringWithFormat:@"%f",bmi];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)back:(UIButton *)sender {
    if (nextButton.tag == 4) {
        [UIView animateWithDuration:0.3 animations:^{
            _heiView.alpha = 1;
            _weiVIew.alpha = 0;
            _titleLabel.text = NSLocalizedString(@"你有多高？", nil);
        }];
        nextButton.tag = 3;
    } else if (nextButton.tag == 3) {
        [UIView animateWithDuration:0.3 animations:^{
            _ageView.alpha = 1;
            _heiView.alpha = 0;
            _titleLabel.text = NSLocalizedString(@"你几岁？", nil);
        }];
        nextButton.tag = 2;
    } else if (nextButton.tag == 2) {
        [UIView animateWithDuration:0.3 animations:^{
            _sexView.alpha = 1;
            _ageView.alpha = 0;
            sender.alpha = 0;
            _titleLabel.text = NSLocalizedString(@"你的性别？", nil);
        }];
        nextButton.tag = 1;
    }
    
}

- (IBAction)selectSex:(UIButton *)sender {
    if (sender.tag == 51 && !sender.selected) {
        sender.selected = YES;
        woManButton.selected = NO;
    } else if (sender.tag == 52 && !sender.selected) {
        sender.selected = YES;
        manButton.selected = NO;
    }
}

- (void)pickerBeginScroll{
    backButton.enabled = NO;
    nextButton.enabled = NO;
}

- (void)pickerEndScroll{
    backButton.enabled = YES;
    nextButton.enabled = YES;
}


@end
