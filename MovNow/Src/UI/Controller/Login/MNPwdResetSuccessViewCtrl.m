//
//  MNPwdResetSuccessViewCtrl.m
//  Movnow
//
//  Created by LiuX on 15/4/17.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//

#import "MNPwdResetSuccessViewCtrl.h"

@interface MNPwdResetSuccessViewCtrl ()

@property (weak, nonatomic) IBOutlet UILabel *PPromptLabel1;
@property (weak, nonatomic) IBOutlet UILabel *PPromptLabel2;
@property (weak, nonatomic) IBOutlet UILabel *PPromptLabel3;

@end

@implementation MNPwdResetSuccessViewCtrl

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loaclOperation];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController popToRootViewControllerAnimated:NO];
}

#pragma mark - 本地化操作
- (void)loaclOperation
{
    self.PPromptLabel1.text = NSLocalizedString(@"我们已经给您的邮箱发送了一份重置密码的邮件", nil);
    self.PPromptLabel2.text = NSLocalizedString(@"1.24小时有效", nil);
    self.PPromptLabel3.text = NSLocalizedString(@"2.如果您没有收到，请检查您的垃圾邮箱或者是过滤器", nil);
}

@end
