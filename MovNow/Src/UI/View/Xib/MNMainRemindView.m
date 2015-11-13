//
//  MNMainRemindView.m
//  Movnow
//
//  Created by LiuX on 15/4/25.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//

#import "MNMainRemindView.h"

@interface MNMainRemindView ()

@property (weak, nonatomic) IBOutlet UIButton *drinkRemindBtn;
@property (weak, nonatomic) IBOutlet UIButton *getUpRemindBtn;
@property (weak, nonatomic) IBOutlet UIButton *BMIBtn;
@property (weak, nonatomic) IBOutlet UIButton *sittingRemindBtn;
@property (weak, nonatomic) IBOutlet UILabel *drinkRemindLabel;
@property (weak, nonatomic) IBOutlet UILabel *getUpRemindLabel;
@property (weak, nonatomic) IBOutlet UILabel *BMILabel;
@property (weak, nonatomic) IBOutlet UILabel *sittingRemindLabel;

@property (nonatomic,copy) MainRemindBtnClickBlock clickBlock;

@end

@implementation MNMainRemindView

- (MNMainRemindView *)initWithXibFileAndHeight:(CGFloat)height clickBlock:(MainRemindBtnClickBlock)clickBlock
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"MNMainRemindView" owner:self options:nil] firstObject];
    if (self) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, height);
        
        self.drinkRemindLabel.text = NSLocalizedString(@"喝水提醒", nil);
        self.getUpRemindLabel.text = NSLocalizedString(@"起床提醒", nil);
        self.BMILabel.text = NSLocalizedString(@"体质指数", nil);
        self.sittingRemindLabel.text = NSLocalizedString(@"久坐提醒", nil);
        
        [self.drinkRemindBtn setBackgroundImage:[UIImage imageNamed:IMAGE_NAME(@"main_drink_btn")] forState:UIControlStateNormal];
        [self.drinkRemindBtn setBackgroundImage:[UIImage imageNamed:IMAGE_NAME(@"main_drink_btn_press")] forState:UIControlStateHighlighted];
        
        [self.getUpRemindBtn setBackgroundImage:[UIImage imageNamed:IMAGE_NAME(@"main_getup_btn")] forState:UIControlStateNormal];
        [self.getUpRemindBtn setBackgroundImage:[UIImage imageNamed:IMAGE_NAME(@"main_getup_btn_press")] forState:UIControlStateHighlighted];
        
        [self.BMIBtn setBackgroundImage:[UIImage imageNamed:IMAGE_NAME(@"main_BMI_btn")] forState:UIControlStateNormal];
        [self.BMIBtn setBackgroundImage:[UIImage imageNamed:IMAGE_NAME(@"main_BMI_btn_press")] forState:UIControlStateHighlighted];
        
        [self.sittingRemindBtn setBackgroundImage:[UIImage imageNamed:IMAGE_NAME(@"main_sitting_btn")] forState:UIControlStateNormal];
        [self.sittingRemindBtn setBackgroundImage:[UIImage imageNamed:IMAGE_NAME(@"main_sitting_btn_press")] forState:UIControlStateHighlighted];
        
        self.clickBlock = [clickBlock copy];
    }
    
    return self;
}

- (IBAction)remindBtnClick:(UIButton *)sender
{
    switch (sender.tag) {
        case 10: //喝水
        {
            self.clickBlock(MainRemindBtnClickTypeDrink);
        }
            break;
        case 20: //起床
        {
            self.clickBlock(MainRemindBtnClickTypeGetUp);
        }
            break;
        case 30: //体质指数
        {
            self.clickBlock(MainRemindBtnClickTypeBMI);
        }
            break;
        case 40: //久坐
        {
            self.clickBlock(MainRemindBtnClickTypeSitting);
        }
            break;
        default:
            break;
    }
}


@end
