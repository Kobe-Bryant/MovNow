//
//  MNUserService.m
//  Movnow
//
//  Created by LiuX on 15/4/16.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//

#import "MNUserService.h"
#import "MNUserNetManager.h"
#import "NSString+MD5.h"
#import "MNUserKeyChain.h"
#import "MNUserModel.h"
#import "NSString+RegexAddition.h"
#import "MNBleBaseService.h"
#import "NSDate+Expend.h"

@implementation MNUserService

- (id)init
{
    self = [super init];
    if (self) {
        //默认是未登录状态
        [self setLogin:NO];
    }
    return self;
}
+ (MNUserService *)shareInstance
{
    static dispatch_once_t onceToken;
    static MNUserService *_mnUser = nil;
    dispatch_once(&onceToken, ^{
        _mnUser = [[self alloc]init];
    });
    return _mnUser;
}

-(void)loginWithEmail:(NSString *)email passWord:(NSString *)passWord success:(CoreSuccess)success failure:(CoreFailure)failure
{
    if ([email isEqualToString:@""]) {
        DLog(@"邮箱为空");
        failure(NSLocalizedString(@"邮箱或密码没输入，请重试", nil));
        return;
    }
    
    if (![email isValidateEmail]) {
        DLog(@"无效邮箱");
        failure(NSLocalizedString(@"邮箱无效，请重新输入", nil));
        return;
    }
    
    if ([passWord isEqualToString:@""]) {
        DLog(@"密码为空");
        failure(NSLocalizedString(@"邮箱或密码没输入，请重试", nil));
        return;
    }
    
    [[[MNUserNetManager alloc] init] loginWithEmail:email withPassword:[passWord getMd5Str] success:^(id result) {
        if ([result[@"error"] isEqualToString:@"0"]) {
            
            [self setLogin:YES];
            
            [MNUserKeyChain savePassWord:[passWord getMd5Str] withUserName:email withSession:result[@"sessionId"] withUserID:result[@"userId"]];
            [[MNUserModel shareInstance] gainUser:result];
            
            DLog(@"登陆成功");
            success(NSLocalizedString(@"登陆成功", nil));
        }else{
            DLog(@"登陆失败——错误原因:%@",result[@"subErrors"][0][@"message"]);
            failure(result[@"subErrors"][0][@"message"]);
        }
    } failure:^(id reason) {
        DLog(@"网络超时");
        failure(NSLocalizedString(@"网络超时", nil));
    }];
}

- (void)registerWithEmail:(NSString *)email passWord:(NSString *)passWord success:(CoreSuccess)success failure:(CoreFailure)failure
{
    if ([email isEqualToString:@""]) {
        DLog(@"邮箱为空");
        failure(NSLocalizedString(@"邮箱或密码没输入，请重试", nil));
        return;
    }
    
    if (![email isValidateEmail]) {
        DLog(@"无效邮箱");
        failure(NSLocalizedString(@"邮箱无效，请重新输入", nil));
        return;
    }
    
    if ([passWord isEqualToString:@""]) {
        DLog(@"密码为空");
        failure(NSLocalizedString(@"邮箱或密码没输入，请重试", nil));
        return;
    }

    if ([passWord judgePasswordStrongth] < 2) {
        DLog(@"密码过于简单,建议使用数字加字母的组合");
        failure(NSLocalizedString(@"密码由6-16位数字、字母组成，不可包含空格和特殊字符", nil));
        return;
    }
    
    [[[MNUserNetManager alloc] init] registerWithEmail:email password:[passWord getMd5Str] success:^(id result) {
        if ([result[@"error"] isEqualToString:@"0"]) {
            
            DLog(@"注册成功");
            success(NSLocalizedString(@"注册成功", nil));
        }else{
            DLog(@"注册失败——错误原因:%@",result[@"subErrors"][0][@"message"]);
            failure(result[@"subErrors"][0][@"message"]);
        }
    } failure:^(id reason) {
        DLog(@"网络超时");
        failure(NSLocalizedString(@"网络超时", nil));
    }];
}

-(void)autoLoginWithSuccess:(CoreSuccess)success failure:(CoreFailure)failure
{
    DLog(@"自动登录开始");
    
    NSString *cacheEmail = [MNUserKeyChain readUserName];
    NSString *cachePwd = [MNUserKeyChain readPassWord];
    
    if ([cacheEmail isEqualToString:@""] || cacheEmail == nil) {
        DLog(@"缓存邮箱为空");
        failure(NSLocalizedString(@"缓存邮箱为空", nil));
        return;
    }
    
    if ([cachePwd isEqualToString:@""] || cachePwd == nil) {
        DLog(@"缓存密码为空");
        failure(NSLocalizedString(@"缓存密码为空", nil));
        return;
    }
    
    [[[MNUserNetManager alloc] init] loginWithEmail:cacheEmail withPassword:cachePwd success:^(id result) {
        if ([result[@"error"] isEqualToString:@"0"]) {
            
            [self setLogin:YES];
            
            [[MNUserModel shareInstance] gainUser:result];
            
            DLog(@"自动登录成功");
            success(NSLocalizedString(@"自动登录成功", nil));
        }else{
            DLog(@"自动登录失败——错误原因:%@",result[@"subErrors"][0][@"message"]);
            failure(result[@"subErrors"][0][@"message"]);
        }
    } failure:^(id reason) {
        DLog(@"网络超时");
        failure(NSLocalizedString(@"网络超时", nil));
    }];
    
    DLog(@"自动登录结束");
}

- (void)logoutWithWithSuccess:(CoreSuccess)success failure:(CoreFailure)failure
{
    if (self.isLogin == NO) {
        DLog(@"当前是未登录状态");
        failure(NSLocalizedString(@"当前是未登录状态", nil));
        return;
    }
    
    [[[MNUserNetManager alloc] init] loginOutWithSuccess:^(id result) {
        if ([result[@"error"] isEqualToString:@"0"] || [result[@"error"] isEqualToString:@"27"]) {
            
            [self setLogin:NO];
            
            [[MNUserModel shareInstance] clearCache];
            [MNUserKeyChain deleteUserNameWithPwd];
            
            DLog(@"注销成功");
            success(NSLocalizedString(@"注销成功", nil));
        }else{
            DLog(@"注销失败——错误原因:%@",result[@"subErrors"][0][@"message"]);
            failure(result[@"subErrors"][0][@"message"]);
        }
    } failure:^(id reason) {
        DLog(@"网络超时");
        failure(NSLocalizedString(@"网络超时", nil));
    }];
}

- (void)resetPasswordWithEmail:(NSString *)email success:(CoreSuccess)success failure:(CoreFailure)failure
{
    if ([email isEqualToString:@""]) {
        DLog(@"邮箱为空");
        failure(NSLocalizedString(@"邮箱或密码没输入，请重试", nil));
        return;
    }
    
    if (![email isValidateEmail]) {
        DLog(@"无效邮箱");
        failure(NSLocalizedString(@"邮箱无效，请重新输入", nil));
        return;
    }
    
    [[[MNUserNetManager alloc] init] resetPasswordWithEmail:email success:^(id result) {
        if ([result[@"error"] isEqualToString:@"0"]) {
            
            [[MNUserModel shareInstance] gainUser:result];
            
            DLog(@"重设密码成功");
            success(NSLocalizedString(@"重设密码成功", nil));
        }else{
            DLog(@"重设密码失败——错误原因:%@",result[@"subErrors"][0][@"message"]);
            failure(result[@"subErrors"][0][@"message"]);
        }
    } failure:^(id reason) {
        DLog(@"网络超时");
        failure(NSLocalizedString(@"网络超时", nil));
    }];
}

-(void)changePasswordWithOldPassword:(NSString *)oldPassword newPassword:(NSString *)newPassword success:(CoreSuccess)success failure:(CoreFailure)failure needLoginOut:(CoreEmptyCallBack)needLoginOut
{
    if ([oldPassword isEqualToString:@""]) {
        DLog(@"旧密码为空");
        failure(@"旧密码为空");
        return;
    }
    
    if ([newPassword isEqualToString:@""]) {
        DLog(@"新密码为空");
        failure(@"新密码为空");
        return;
    }
    
    if ([newPassword judgePasswordStrongth] < 2) {
        DLog(@"新密码过于简单");
        failure(@"新密码过于简单");
        return;
    }
    
    [[[MNUserNetManager alloc] init] changePasswordWithOldPassword:oldPassword withNewPassword:newPassword success:^(id result) {
        if ([result[@"error"] isEqualToString:@"0"]) {
            
            DLog(@"修改密码成功");
            success(@"修改密码成功");
        }else{
            DLog(@"修改密码失败——错误原因:%@",result[@"subErrors"][0][@"message"]);
            failure(result[@"subErrors"][0][@"message"]);
        }
    } failure:^(id reason) {
        DLog(@"网络超时");
        failure(NSLocalizedString(@"网络超时", nil));
    } needLoginOut:^{
        DLog(@"需要退出登陆");
        needLoginOut();
    }];
}

-(void)uploadUserIcon:(UIImage *)icon success:(CoreSuccess)success failure:(CoreFailure)failure needLoginOut:(CoreEmptyCallBack)needLoginOut
{
    NSData *imageData = UIImagePNGRepresentation(icon);
    
    //先请求头像token
    [[[MNUserNetManager alloc] init] uploadIconTokenWithSuccess:^(id result) {
        if ([result[@"error"] isEqualToString:@"0"]) {
            
            //请求头像token成功之后才开始发请求
            [[[MNUserNetManager alloc] init] uploadIconData:imageData token:result[@"token"] success:^(id result) {
                
                DLog(@"result=%@",result);
                if ([result[@"error"] isEqualToString:@"Succeed"]) {
                    
                    DLog(@"上传头像成功——%@",result[@"fileId"]);
                    success(result[@"fileId"]);
                }else{
                    DLog(@"上传头像失败——错误原因:%@",result[@"subErrors"][0][@"message"]);
                    failure(result[@"subErrors"][0][@"message"]);
                }
            } failure:^(id reason) {
                DLog(@"网络超时");
                failure(NSLocalizedString(@"网络超时", nil));
            }];
            
        }else{
            DLog(@"请求头像token失败——错误原因:%@",result[@"subErrors"][0][@"message"]);
            failure(result[@"subErrors"][0][@"message"]);
        }
    } failure:^(id reason) {
        DLog(@"网络超时");
        failure(NSLocalizedString(@"网络超时", nil));
    } needLoginOut:^{
        DLog(@"需要退出登陆");
        needLoginOut();
    }];
}

- (void)updateUserInfoWithIconURL:(NSString *)iconURL nickname:(NSString *)nickname sex:(SexType)sex birthday:(NSString *)birthday weight:(NSString *)weight height:(NSString *)height success:(CoreSuccess)success failure:(CoreFailure)failure needLoginOut:(CoreEmptyCallBack)needLoginOut
{
    if ([nickname isEqualToString:@""]) {
        DLog(@"昵称为空");
        failure(NSLocalizedString(@"昵称为空", nil));
        return;
    }
    
    //参数字典
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setValue:iconURL forKey:@"avatar"];
    [parameter setValue:nickname forKey:@"nickName"];
    [parameter setValue:(sex == SexTypeMan)?@1:@0 forKey:@"sex"];
    [parameter setValue:birthday forKey:@"birthday"];
    [parameter setValue:[NSNumber numberWithInteger:[weight integerValue]] forKey:@"weight"];
    [parameter setValue:[NSNumber numberWithInteger:[height integerValue]] forKey:@"height"];
    
    //发请求
    [[[MNUserNetManager alloc] init] updateUserInfoWithDict:parameter success:^(id result) {
        if ([result[@"error"] isEqualToString:@"0"]) {
            
            [[MNUserModel shareInstance] gainUser:parameter];
            [[MNUserModel shareInstance] saveCache];
            
            [[MNBleBaseService shareInstance] syncWithSuccess:^(id result) {
            } withBinding:NO withFailure:^(id reason) {
            }];
            
            DLog(@"上传用户信息成功");
            success(NSLocalizedString(@"上传用户信息成功", nil));
        }else{
            DLog(@"上传用户信息失败——错误原因:%@",result[@"subErrors"][0][@"message"]);
            failure(result[@"subErrors"][0][@"message"]);
        }
    } failure:^(id reason) {
        DLog(@"网络超时");
        failure(NSLocalizedString(@"网络超时", nil));
    } needLoginOut:^{
        DLog(@"需要退出登陆");
        needLoginOut();
    }];
}

- (void)setMovementTargetWithSteps:(NSInteger)steps success:(CoreSuccess)success failure:(CoreFailure)failure
{
    
}

@end