//
//  MNUserKeyChain.h
//  Movnow
//
//  Created by baoyx on 15/4/14.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MNUserKeyChain : NSObject
/**
 *  保存用户名和密码
 *
 *  @param password 密码
 *  @param userName 用户名
 */
+(void)savePassWord:(NSString *)password withUserName:(NSString *)userName withSession:(NSString *)session withUserID:(NSNumber *)userID;
/**
 *  读取密码
 *
 *  @return 密码
 */
+(id)readPassWord;
/**
 *  读取用户名
 *
 *  @return 用户名
 */
+(id)readUserName;
/**
 *  读取session
 *
 *  @return session
 */
+(id)readSession;
/**
 *  读取userID
 *
 *  @return userID
 */
+(id)readUserID;
/**
 *  删除用户名、密码、session
 */

+(void)deleteUserNameWithPwd;
@end
