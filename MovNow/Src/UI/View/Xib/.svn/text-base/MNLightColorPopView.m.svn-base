//
//  MNLightColorPopView.m
//  Movnow
//
//  Created by LiuX on 15/4/27.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//

#import "MNLightColorPopView.h"
#import "MNBleBaseService.h"

@interface MNLightColorPopView ()

@property (weak, nonatomic) IBOutlet UIButton *blueColorBtn;
@property (weak, nonatomic) IBOutlet UIImageView *blueColorIconView;
@property (weak, nonatomic) IBOutlet UIButton *orangeColorBtn;
@property (weak, nonatomic) IBOutlet UIImageView *orangeColorIconView;
@property (weak, nonatomic) IBOutlet UIButton *greenColorBtn;
@property (weak, nonatomic) IBOutlet UIImageView *greenColorIconView;
@property (weak, nonatomic) IBOutlet UIButton *redColorBtn;
@property (weak, nonatomic) IBOutlet UIImageView *redColorIconView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSpace;

@property (nonatomic,assign) BOOL isShowed;
@property (nonatomic,copy) void (^dismissBlock)(LightColorType type);

@end

@implementation MNLightColorPopView

- (MNLightColorPopView *)initWithXibFileAndDismissBlock:(void(^)(LightColorType type))dismissBlock
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"MNLightColorPopView" owner:self options:nil] firstObject];
    
    if (self) {
        [self.blueColorBtn setImage:[UIImage imageNamed:IMAGE_NAME(@"setting_arrow_press")] forState:UIControlStateHighlighted];
        [self.orangeColorBtn setImage:[UIImage imageNamed:IMAGE_NAME(@"setting_arrow_press")] forState:UIControlStateHighlighted];
        [self.greenColorBtn setImage:[UIImage imageNamed:IMAGE_NAME(@"setting_arrow_press")] forState:UIControlStateHighlighted];
        [self.redColorBtn setImage:[UIImage imageNamed:IMAGE_NAME(@"setting_arrow_press")] forState:UIControlStateHighlighted];
        
        [self.blueColorIconView setImage:[UIImage imageNamed:IMAGE_NAME(@"lightColor_blue")]];
        [self.orangeColorIconView setImage:[UIImage imageNamed:IMAGE_NAME(@"lightColor_orange")]];
        [self.greenColorIconView setImage:[UIImage imageNamed:IMAGE_NAME(@"lightColor_green")]];
        [self.redColorIconView setImage:[UIImage imageNamed:IMAGE_NAME(@"lightColor_red")]];
        
        self.dismissBlock = [dismissBlock copy];
    }
    return self;
}

- (void)showInView:(UIView *)view
{
    if (self.isShowed == YES) return;
    self.isShowed = YES;
    
    [view addSubview:self];
    
    self.bottomSpace.constant = 64;
    [UIView animateWithDuration:kAnimationInterval animations:^{
        [self layoutIfNeeded];
    }];
}

#pragma mark - 颜色按钮点击事件
- (IBAction)colorBtnClick:(UIButton *)sender
{
    [self hideSelf];
    
    switch (sender.tag) {
        case 10: //蓝色
        {
            if (self.dismissBlock) {
                self.dismissBlock(LightColorTypeBlue);
            }
        }
            break;
        case 20: //橙色
        {
            if (self.dismissBlock) {
                self.dismissBlock(LightColorTypeOrange);
            }
        }
            break;
        case 30: //绿色
        {
            if (self.dismissBlock) {
                self.dismissBlock(LightColorTypeGreen);
            }
        }
            break;
        case 40: //红色
        {
            if (self.dismissBlock) {
                self.dismissBlock(LightColorTypeRed);
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - 点击背景view
- (IBAction)clickToBgView:(UITapGestureRecognizer *)sender
{
    [self hideSelf];
}

- (void)hideSelf
{
    self.isShowed = NO;
    
    self.bottomSpace.constant = - 206;
    [UIView animateWithDuration:kAnimationInterval animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
