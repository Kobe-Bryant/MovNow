//
//  NSString+RegexAddition.h
//  ==============================================
//  正则相关
//  ==============================================
//  Created by Fish on 14-3-21.
//  Copyright (c) 2014年 Fish. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (RegexAddition)

/**
 *  验证邮箱是不是可用
 *
 *  return YES / NO
 */
- (BOOL)isValidateEmail;

/**
 *  验证是不是数字
 *
 *  return YES / NO
 */
- (BOOL)isNumber;

/**
 *  验证是不是英文
 *
 *  return YES / NO
 */
- (BOOL)isEnglish;

/**
 *  验证是不是汉字
 *
 *  return YES / NO
 */
- (BOOL)isChinese;

/**
 *  验证是不是网络链接地址
 *
 *  return YES / NO
 */
- (BOOL)isInternetUrl;

/**
 *  是不是手机号码
 *
 *  @param mobileNum 手机号
 *
 *  @return YES / NO
 */
- (BOOL)isMobileNumber;

/**
 *  判断密码强度
 *
 *  @return 1     密码强度低，建议修改
                    2     密码强度一般
                    3     密码强度高
                    4     密码强度极高
 */
- (NSInteger)judgePasswordStrongth;

@end
