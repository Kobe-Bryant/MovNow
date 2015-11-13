//
//  MNCameraSettingView.m
//  Movnow
//
//  Created by LiuX on 15/4/28.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//

#import "MNCameraSettingView.h"

@interface MNCameraSettingView ()

@property (weak, nonatomic) IBOutlet UILabel *countTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *intervalTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *countThreeBtn;
@property (weak, nonatomic) IBOutlet UIButton *countFiveBtn;
@property (weak, nonatomic) IBOutlet UIButton *countTenBtn;
@property (weak, nonatomic) IBOutlet UIButton *intervalTwoBtn;
@property (weak, nonatomic) IBOutlet UIButton *intervalThreeBtn;
@property (weak, nonatomic) IBOutlet UIButton *intervalFourBtn;

@property (nonatomic,copy) CameraCountBlock countBlock;
@property (nonatomic,copy) CameraIntervalBlock intervalBlock;

@end

@implementation MNCameraSettingView

- (MNCameraSettingView *)initWithXibFileAndFrame:(CGRect)frame countBlock:(CameraCountBlock)countBlock intervalBlock:(CameraIntervalBlock)intervalBlock
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"MNCameraSettingView" owner:self options:nil] firstObject];
    
    if (self) {
        self.frame = frame;
        
        self.countTitleLabel.text = NSLocalizedString(@"连拍次数", nil);
        self.intervalTitleLabel.text = NSLocalizedString(@"连拍间隔", nil);
        
        [self.countThreeBtn setBackgroundImage:[UIImage imageNamed:IMAGE_NAME(@"camera_setting_bg")] forState:UIControlStateNormal];
        [self.countThreeBtn setBackgroundImage:[UIImage imageNamed:IMAGE_NAME(@"camera_setting_bg_press")] forState:UIControlStateSelected];
        [self.countFiveBtn setBackgroundImage:[UIImage imageNamed:IMAGE_NAME(@"camera_setting_bg")] forState:UIControlStateNormal];
        [self.countFiveBtn setBackgroundImage:[UIImage imageNamed:IMAGE_NAME(@"camera_setting_bg_press")] forState:UIControlStateSelected];
        [self.countTenBtn setBackgroundImage:[UIImage imageNamed:IMAGE_NAME(@"camera_setting_bg")] forState:UIControlStateNormal];
        [self.countTenBtn setBackgroundImage:[UIImage imageNamed:IMAGE_NAME(@"camera_setting_bg_press")] forState:UIControlStateSelected];
        [self.intervalTwoBtn setBackgroundImage:[UIImage imageNamed:IMAGE_NAME(@"camera_setting_bg")] forState:UIControlStateNormal];
        [self.intervalTwoBtn setBackgroundImage:[UIImage imageNamed:IMAGE_NAME(@"camera_setting_bg_press")] forState:UIControlStateSelected];
        [self.intervalThreeBtn setBackgroundImage:[UIImage imageNamed:IMAGE_NAME(@"camera_setting_bg")] forState:UIControlStateNormal];
        [self.intervalThreeBtn setBackgroundImage:[UIImage imageNamed:IMAGE_NAME(@"camera_setting_bg_press")] forState:UIControlStateSelected];
        [self.intervalFourBtn setBackgroundImage:[UIImage imageNamed:IMAGE_NAME(@"camera_setting_bg")] forState:UIControlStateNormal];
        [self.intervalFourBtn setBackgroundImage:[UIImage imageNamed:IMAGE_NAME(@"camera_setting_bg_press")] forState:UIControlStateSelected];
        
        self.countBlock = [countBlock copy];
        self.intervalBlock = [intervalBlock copy];
    }
    return self;
}

- (IBAction)countBtnClick:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    switch (sender.tag) {
        case 10: //三次
        {
            if (sender.selected) {
                self.countFiveBtn.selected = NO;
                self.countTenBtn.selected = NO;
                self.countBlock(3);
            }else{
                self.countBlock(0);
            }
        }
            break;
        case 20: //五次
        {
            if (sender.selected) {
                self.countThreeBtn.selected = NO;
                self.countTenBtn.selected = NO;
                self.countBlock(5);
            }else{
                self.countBlock(0);
            }
        }
            break;
        case 30: //十次
        {
            if (sender.selected) {
                self.countThreeBtn.selected = NO;
                self.countFiveBtn.selected = NO;
                self.countBlock(10);
            }else{
                self.countBlock(0);
            }
        }
            break;
        default:
            break;
    }
}

- (IBAction)intervalBtnClick:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    switch (sender.tag) {
        case 40: //两秒
        {
            if (sender.selected) {
                self.intervalThreeBtn.selected = NO;
                self.intervalFourBtn.selected = NO;
                self.intervalBlock(2);
            }else{
                self.intervalBlock(0);
            }
        }
            break;
        case 50: //三秒
        {
            if (sender.selected) {
                self.intervalTwoBtn.selected = NO;
                self.intervalFourBtn.selected = NO;
                self.intervalBlock(3);
            }else{
                self.intervalBlock(0);
            }
        }
            break;
        case 60: //四秒
        {
            if (sender.selected) {
                self.intervalTwoBtn.selected = NO;
                self.intervalThreeBtn.selected = NO;
                self.intervalBlock(4);
            }else{
                self.intervalBlock(0);
            }
        }
            break;
        default:
            break;
    }
}


@end
