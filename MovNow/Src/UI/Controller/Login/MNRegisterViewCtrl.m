//
//  MNRegisterViewCtrl.m
//  Movnow
//
//  Created by LiuX on 15/4/15.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//

#import "MNRegisterViewCtrl.h"
#import "MNUserService.h"
#import "MNProtocolViewCtrl.h"

@interface MNRegisterViewCtrl ()<UITextFieldDelegate>

/**
 *  邮箱背景视图
 */
@property (weak, nonatomic) IBOutlet UIImageView *REmailBgView;
/**
 *  密码背景视图
 */
@property (weak, nonatomic) IBOutlet UIImageView *RPwdBgView;
/**
 *  邮箱图标
 */
@property (weak, nonatomic) IBOutlet UIImageView *REmailIconView;
/**
 *  密码图标
 */
@property (weak, nonatomic) IBOutlet UIImageView *RPwdIconView;
/**
 *  邮箱输入框
 */
@property (weak, nonatomic) IBOutlet UITextField *REmailTF;
/**
 *  密码输入框
 */
@property (weak, nonatomic) IBOutlet UITextField *RPwdTF;
/**
 *  用户协议按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *RProcotolBtn;

@end

@implementation MNRegisterViewCtrl

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
        [self.REmailTF becomeFirstResponder];
    });
    
    [self setUpRightBarItem];
    
    [self resetImages];
}

#pragma mark - 本地化操作
- (void)loaclOperation
{
    self.REmailTF.attributedPlaceholder = [[NSAttributedString alloc]initWithString:NSLocalizedString(@"邮箱",nil) attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    self.RPwdTF.attributedPlaceholder = [[NSAttributedString alloc]initWithString:NSLocalizedString(@"密码", nil) attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    [self.RProcotolBtn setTitle:NSLocalizedString(@"点击提交即表示同意我们的用户协议", nil) forState:UIControlStateNormal];
    if ([[MNLanguageService shareInstance] getCurrentLanguage] == CurrentLanguageTypeEnglish) {
        self.RProcotolBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    }
}

#pragma mark - 重设图片
- (void)resetImages
{
    [self.REmailBgView setImage:[UIImage imageNamed:IMAGE_NAME(@"input")]];
    [self.RPwdBgView setImage:[UIImage imageNamed:IMAGE_NAME(@"input")]];
    [self.REmailIconView setImage:[UIImage imageNamed:IMAGE_NAME(@"icon_user")]];
    [self.RPwdIconView setImage:[UIImage imageNamed:IMAGE_NAME(@"icon_password")]];
}

#pragma mark - 返回按钮文字
- (NSString *)backBarItemText
{
    return NSLocalizedString(@"服务协议", nil);
}

#pragma mark - 提交按钮
- (NSString *)rightBarItemText
{
    return NSLocalizedString(@"提交",nil);
}

- (void)rightBarItemPress:(UIButton *)sender
{
    [[MNUserService shareInstance] registerWithEmail:self.REmailTF.text passWord:self.RPwdTF.text success:^(id result){
        
        //将账号信息回调给登陆界面
        if (_getAccount) {
            
            _getAccount(self.REmailTF.text,self.RPwdTF.text);
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } failure:^(id reason) {
        [self.view showHUDWithStr:NSLocalizedString(reason,nil) hideAfterDelay:kAlertWordsInterval];
    }];
}

#pragma mark - 用户协议按钮点击事件
- (IBAction)procotolBtnClick:(UIButton *)sender
{
    [self.navigationController pushViewController:[[MNProtocolViewCtrl alloc]initWithNibName:@"MNProtocolViewCtrl" bundle:nil] animated:YES];
}

#pragma mark - 点击空白处消除键盘
- (IBAction)clickToBgView:(UITapGestureRecognizer *)sender
{
    [self.view endEditing:YES];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.REmailTF) {
        [self.REmailBgView setImage:[UIImage imageNamed:IMAGE_NAME(@"input_signup_s")]];
    }else if (textField == self.RPwdTF){
        [self.RPwdBgView setImage:[UIImage imageNamed:IMAGE_NAME(@"input_signup_s")]];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.REmailTF) {
        [self.REmailBgView setImage:[UIImage imageNamed:IMAGE_NAME(@"input")]];
    }else if (textField == self.RPwdTF){
        [self.RPwdBgView setImage:[UIImage imageNamed:IMAGE_NAME(@"input")]];
    }
}
@end
