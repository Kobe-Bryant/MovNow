//
//  MNUserNetManager.h
//  Movnow
//
//  Created by baoyx on 15/4/15.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MNUserNetManager : NSObject

/**
 *  用户登录
 *
 *  @param email 邮箱
 *  @param passWord 密码
 *  @param success   登陆成功
 *  @param failure  登陆失败
 */
-(void)loginWithEmail:(NSString *)email withPassword:(NSString *)passWord success:(CoreSuccess)success failure:(CoreFailure)failure;

/**
 *  邮箱注册
 *
 *  @param email     邮箱
 *  @param password 密码
 *  @param success  注册成功
 *  @param failure  注册失败
 */
-(void)registerWithEmail:(NSString *)email password:(NSString *)password success:(CoreSuccess)success failure:(CoreFailure)failure;

/**
 *  用户注销
 *
 *  @param success   注销成功
 *  @param failure  注销失败
 */
-(void)loginOutWithSuccess:(CoreSuccess)success failure:(CoreFailure)failure;

/**
 *  邮箱重置密码
 *
 *  @param mail    重置邮箱
 *  @param success  重置成功
 *  @param failure 重置失败
 */
-(void)resetPasswordWithEmail:(NSString *)email success:(CoreSuccess)success failure:(CoreFailure)failure;

/**
 *  修改密码
 *
 *  @param oldPassword 旧密码(不用MD5加密)
 *  @param newPassword 新密码(不用MD5加密)
 *  @param success      修改成功
 *  @param failure     修改失败
 *  @param needLoginOut 需要退出登录
 */
-(void)changePasswordWithOldPassword:(NSString *)oldPassword withNewPassword:(NSString *)newPassword success:(CoreSuccess)success failure:(CoreFailure)failure needLoginOut:(CoreEmptyCallBack)needLoginOut;

/**
 *  更新用户信息
 *
 *  @param dict     用户信息字典
 *  @param success   更新成功
 *  @param failure  更新失败
 *  @param needLoginOut 需要退出登录
 */
-(void)updateUserInfoWithDict:(NSDictionary *)dict success:(CoreSuccess)success failure:(CoreFailure)failure needLoginOut:(CoreEmptyCallBack)needLoginOut;

/**
 *  申请头像token
 *
 *  @param success  申请成功
 *  @param failure  申请失败
 *  @param needLoginOut 需要退出登录
 */
-(void)uploadIconTokenWithSuccess:(CoreSuccess)success failure:(CoreFailure)failure needLoginOut:(CoreEmptyCallBack)needLoginOut;

/**
 *  上传头像
 *
 *  @param iconData 头像数据
 *  @param token    头像token
 *  @param success   上传成功
 *  @param failure  上传失败
 */
-(void)uploadIconData:(NSData *)iconData token:(NSString *)token success:(CoreSuccess)success failure:(CoreFailure)failure;

@end
