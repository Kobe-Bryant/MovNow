//
//  MNForgetPwdViewCtrl.m
//  Movnow
//
//  Created by LiuX on 15/4/15.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//

#import "MNForgetPwdViewCtrl.h"
#import "MNUserService.h"
#import "MNPwdResetSuccessViewCtrl.h"

@interface MNForgetPwdViewCtrl ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *FEmailIconView;
/**
 *  邮箱背景视图
 */
@property (weak, nonatomic) IBOutlet UIImageView *FEmailBgView;
/**
 *  邮箱输入框
 */
@property (weak, nonatomic) IBOutlet UITextField *FEmailTF;

@end

@implementation MNForgetPwdViewCtrl

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loaclOperation];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //延时0.5秒弹出键盘
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.FEmailTF becomeFirstResponder];
    });
    
    [self setUpRightBarItem];
    
    [self resetImages];
}

#pragma mark - 本地化操作
- (void)loaclOperation
{
    self.FEmailTF.attributedPlaceholder = [[NSAttributedString alloc]initWithString:NSLocalizedString(@"邮箱",nil) attributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
}

#pragma mark - 重设图片
- (void)resetImages
{
    [self.FEmailIconView setImage:[UIImage imageNamed:IMAGE_NAME(@"icon_user")]];
    [self.FEmailBgView setImage:[UIImage imageNamed:IMAGE_NAME(@"input")]];
}

#pragma mark - 返回按钮文字
- (NSString *)backBarItemText
{
    return NSLocalizedString(@"登陆",nil);
}

#pragma mark - 提交按钮
- (NSString *)rightBarItemText
{
    return NSLocalizedString(@"提交",nil);
}

- (void)rightBarItemPress:(UIButton *)sender
{
    [[MNUserService shareInstance] resetPasswordWithEmail:self.FEmailTF.text success:^(id result) {
        [self.navigationController pushViewController:[[MNPwdResetSuccessViewCtrl alloc]initWithNibName:@"MNPwdResetSuccessViewCtrl" bundle:nil] animated:YES];
    } failure:^(id reason) {
        [self.view showHUDWithStr:NSLocalizedString(reason,nil) hideAfterDelay:kAlertWordsInterval];
    }];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.FEmailBgView setImage:[UIImage imageNamed:IMAGE_NAME(@"input_signup_s")]];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.FEmailBgView setImage:[UIImage imageNamed:IMAGE_NAME(@"input")]];
}

- (IBAction)clickToBgView:(UITapGestureRecognizer *)sender
{
    [self.view endEditing:YES];
}

@end
