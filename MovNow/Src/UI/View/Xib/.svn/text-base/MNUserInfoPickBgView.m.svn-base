//
//  MNUserInfoPickBgView.m
//  Movnow
//
//  Created by LiuX on 15/4/22.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//

#import "MNUserInfoPickBgView.h"
#import "MNPickerView.h"

@interface MNUserInfoPickBgView ()

@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSpace;
@property (nonatomic,assign) BOOL isShowed;
@property (nonatomic,copy) BgViewDismissBlock dismissBlock;
@property (weak, nonatomic) IBOutlet UIView *popBgView;
@property (nonatomic,weak) UIView *currentContentView;

@end

@implementation MNUserInfoPickBgView

- (void)setContentView:(UIView *)contentView
{
    //此顺序不能更改
    if ([_currentContentView isEqual:contentView]) return;
    [_currentContentView removeFromSuperview];
    _currentContentView = contentView;
    [self.popBgView addSubview:contentView];
}

- (MNUserInfoPickBgView *)initWithXibFileAndDismissBlock:(BgViewDismissBlock)dismissBlock
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"MNUserInfoPickBgView" owner:self options:nil] firstObject];
    
    if (self) {
        self.dismissBlock = dismissBlock;
        [self.confirmBtn setBackgroundImage:[UIImage imageNamed:IMAGE_NAME(@"btn_goal")] forState:UIControlStateNormal];
        [self.confirmBtn setBackgroundImage:[UIImage imageNamed:IMAGE_NAME(@"btn_goal_press")] forState:UIControlStateHighlighted];
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

- (IBAction)confirmBtnClick:(UIButton *)sender
{
    if (self.dismissBlock) {
        self.dismissBlock(_currentContentView);
    }
    
    [self hideSelf];
}

- (IBAction)clickToBgView:(UITapGestureRecognizer *)sender
{
    [self hideSelf];
}

- (void)hideSelf
{
    self.isShowed = NO;
    
    self.bottomSpace.constant = - 236;
    [UIView animateWithDuration:kAnimationInterval animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
