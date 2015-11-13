//
//  MNUserNetManager.m
//  Movnow
//
//  Created by baoyx on 15/4/15.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//

#import "MNUserNetManager.h"
#import "MNetManager.h"
#import "NSString+MD5.h"
#import "MNUserKeyChain.h"
#import "MNUserModel.h"

@interface MNUserNetManager ()

@property (nonatomic,strong) MNUserModel *user;

@end

@implementation MNUserNetManager

- (MNUserModel *)user
{
    return [MNUserModel shareInstance];
}

- (void)loginWithEmail:(NSString *)email withPassword:(NSString *)passWord success:(CoreSuccess)success failure:(CoreFailure)failure
{
    DLog(@"登陆开始");
    
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setValue:@"user.login" forKey:@"method"];
    [parameter setValue:email forKey:@"username"];
    [parameter setValue:passWord forKey:@"password"];
    
    [MNetManager netGetWithParameter:parameter success:^(id result) {
        success(result);
    } failure:^(id reason) {
        failure(reason);
    }];
    
    DLog(@"登陆结束");
}

-(void)registerWithEmail:(NSString *)email password:(NSString *)password success:(CoreSuccess)success failure:(CoreFailure)failure
{
    DLog(@"注册开始");
    
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setValue:@"user.registerbyemail" forKey:@"method"];
    [parameter setValue:email forKey:@"email"];
    [parameter setValue:password forKey:@"password"];
    
    [MNetManager netGetWithParameter:parameter success:^(id result) {
        success(result);
    } failure:^(id reason) {
        failure(reason);
    }];
    
    DLog(@"注册结束");
}

-(void)loginOutWithSuccess:(CoreSuccess)success failure:(CoreFailure)failure
{
    DLog(@"注销开始");

    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setValue:@"user.logout" forKey:@"method"];
    [parameter setValue:self.user.userId forKey:@"uid"];
    [parameter setValue:[MNUserKeyChain readSession] forKey:@"session"];
    
    [MNetManager netGetWithParameter:parameter success:^(id result) {
        success(result);
    } failure:^(id reason) {
        failure(reason);
    }];
    
    DLog(@"注销结束");
}

-(void)resetPasswordWithEmail:(NSString *)email success:(CoreSuccess)success failure:(CoreFailure)failure
{
    DLog(@"重设密码开始");
    
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setValue:@"user.resetpasswordbyemail" forKey:@"method"];
    [parameter setValue:email forKey:@"email"];
    
    [MNetManager netGetWithParameter:parameter success:^(id result) {
        success(result);
    } failure:^(id reason) {
        failure(reason);
    }];
    
    DLog(@"重设密码结束");
}

-(void)changePasswordWithOldPassword:(NSString *)oldPassword withNewPassword:(NSString *)newPassword success:(CoreSuccess)success failure:(CoreFailure)failure needLoginOut:(CoreEmptyCallBack)needLoginOut
{
    DLog(@"修改密码开始");
    
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setValue:@"user.changepassword" forKey:@"method"];
    [parameter setValue:oldPassword forKey:@"oldPassword"];
    [parameter setValue:newPassword forKey:@"newPassword"];
    [parameter setValue:self.user.userId forKey:@"uid"];
    
    [MNetManager netGetCacheWithParameter:parameter success:^(id result) {
        success(result);
    } failure:^(id reason) {
        failure(reason);
    } loginOut:^{
        needLoginOut();
    }];
    
    DLog(@"修改密码结束");
}

-(void)updateUserInfoWithDict:(NSDictionary *)dict success:(CoreSuccess)success failure:(CoreFailure)failure needLoginOut:(CoreEmptyCallBack)needLoginOut
{
    DLog(@"更新用户信息开始");
    
    [dict setValue:@"user.updateuserinfo" forKey:@"method"];
    
    [MNetManager netGetCacheWithParameter:dict success:^(id result) {
        success(result);
    } failure:^(id reason) {
        failure(reason);
    } loginOut:^{
        needLoginOut();
    }];
    
    DLog(@"更新用户信息结束");
}

-(void)uploadIconTokenWithSuccess:(CoreSuccess)success failure:(CoreFailure)failure needLoginOut:(CoreEmptyCallBack)needLoginOut
{
    DLog(@"获取头像token开始");
    
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setValue:@"user.getuploadfiletoken" forKey:@"method"];
    [parameter setValue:self.user.userId forKey:@"uid"];

    [MNetManager netGetCacheWithParameter:parameter success:^(id result) {
        success(result);
    } failure:^(id reason) {
        failure(reason);
    } loginOut:^{
        needLoginOut();
    }];
    
    DLog(@"获取头像token结束");
}

-(void)uploadIconData:(NSData *)iconData token:(NSString *)token success:(CoreSuccess)success failure:(CoreFailure)failure
{
    DLog(@"上传用户头像开始");
    
    [MNetManager uploadFile:iconData withToken:token success:^(id result) {
        success(result);
    } failure:^(id reason) {
        failure(reason);
    }];
    
    DLog(@"上传用户头像结束");
}

@end
