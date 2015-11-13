//
//  MNUserService.h
//  Movnow
//
//  Created by LiuX on 15/4/16.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//  所有与用户相关操作的服务类

@interface MNUserService : NSObject

typedef NS_ENUM(NSInteger, SexType){
    SexTypeMan = 0, //男人
    SexTypeWoman //女人
};

//当前的登陆状态
@property (nonatomic,assign,getter=isLogin) BOOL login;


+ (MNUserService *)shareInstance;

/**
 *  用户登录接口
 *
 *  @param email  邮箱
 *  @param passWord 密码
 *  @param success  成功回调
 *  @param failure  失败回调
 */
-(void)loginWithEmail:(NSString *)email passWord:(NSString *)passWord success:(CoreSuccess)success failure:(CoreFailure)failure;

/**
 *  用户注册接口
 *
 *  @param email    邮箱
 *  @param passWord 密码
 *  @param success  成功回调
 *  @param failure  失败回调
 */
- (void)registerWithEmail:(NSString *)email passWord:(NSString *)passWord success:(CoreSuccess)success failure:(CoreFailure)failure;

/**
 *  用户自动登录接口(当缓存的账号信息不为空时调用)
 *
 *  @param success 成功回调
 *  @param failure 失败回调
 */
-(void)autoLoginWithSuccess:(CoreSuccess)success failure:(CoreFailure)failure;

/**
 *  用户注销接口
 *
 *  @param success 成功回调
 *  @param failure 失败回调
 */
- (void)logoutWithWithSuccess:(CoreSuccess)success failure:(CoreFailure)failure;

/**
 *  用户通过邮箱重置密码接口
 *
 *  @param email   邮箱
 *  @param success 成功回调
 *  @param failure 失败回调
 */
- (void)resetPasswordWithEmail:(NSString *)email success:(CoreSuccess)success failure:(CoreFailure)failure;

/**
 *  用户修改密码接口
 *
 *  @param oldPassword 旧密码
 *  @param newPassword 新密码
 *  @param success     成功回调
 *  @param failure     失败回调
 *  @param needLoginOut 需要退出登录
 */
-(void)changePasswordWithOldPassword:(NSString *)oldPassword newPassword:(NSString *)newPassword success:(CoreSuccess)success failure:(CoreFailure)failure needLoginOut:(CoreEmptyCallBack)needLoginOut;

/**b
 *  上传头像
 *
 *  @param icon 头像
 *  @param success   上传成功
 *  @param failure  上传失败
 *  @param needLoginOut 需要退出登录
 */
-(void)uploadUserIcon:(UIImage *)icon success:(CoreSuccess)success failure:(CoreFailure)failure needLoginOut:(CoreEmptyCallBack)needLoginOut;

/**
 *  用户更新个人信息接口
 *
 *  @param nickname  昵称
 *  @param sex    性别
 *  @param birthday    出生年月
 *  @param weight 体重
 *  @param height 身高
 *  @param success     成功回调
 *  @param failure     失败回调
 *  @param needLoginOut 需要退出登录
 */
- (void)updateUserInfoWithIconURL:(NSString *)iconURL nickname:(NSString *)nickname sex:(SexType)sex birthday:(NSString *)birthday weight:(NSString *)weight height:(NSString *)height success:(CoreSuccess)success failure:(CoreFailure)failure needLoginOut:(CoreEmptyCallBack)needLoginOut;

@end
