//
//  MNUserKeyChain.m
//  Movnow
//
//  Created by baoyx on 15/4/14.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//

#import "MNUserKeyChain.h"
#import "MNKeyChain.h"
static NSString * const KEY_IN_KEYCHAIN = @"com.wkl.WKLNetDemo.allinfo";
static NSString * const KEY_PASSWORD = @"com.wkl.WKLNetDemo.password";
static NSString * const KEY_USERNAME = @"com.wkl.WKLNetDemo.username";
static NSString * const KEY_SESSION = @"com.wkl.WKLNetDemo.session";
static NSString * const KEY_USERID = @"com.wkl.WKLNetDemo.userid";
@implementation MNUserKeyChain

+(void)savePassWord:(NSString *)password withUserName:(NSString *)userName withSession:(NSString *)session withUserID:(NSNumber *)userID
{
    NSMutableDictionary *userNamePasswordKVPairs = [NSMutableDictionary dictionary];
    [userNamePasswordKVPairs setValue:password forKey:KEY_PASSWORD];
    [userNamePasswordKVPairs setValue:userName forKey:KEY_USERNAME];
    [userNamePasswordKVPairs setValue:session forKey:KEY_SESSION];
    [userNamePasswordKVPairs setValue:userID forKey:KEY_USERID];
    [MNKeyChain save:KEY_IN_KEYCHAIN data:userNamePasswordKVPairs];
}

+(id)readPassWord
{
    NSMutableDictionary *userNamePasswordKVPairs = (NSMutableDictionary *)[MNKeyChain load:KEY_IN_KEYCHAIN];
    return [userNamePasswordKVPairs objectForKey:KEY_PASSWORD];
}

+(id)readUserName
{
    NSMutableDictionary *userNamePasswordKVPairs = (NSMutableDictionary *)[MNKeyChain load:KEY_IN_KEYCHAIN];
    return [userNamePasswordKVPairs objectForKey:KEY_USERNAME];
}
+(id)readSession
{
    NSMutableDictionary *userNamePasswordKVPairs = (NSMutableDictionary *)[MNKeyChain load:KEY_IN_KEYCHAIN];
    return [userNamePasswordKVPairs objectForKey:KEY_SESSION];
}

+(id)readUserID
{
    NSMutableDictionary *userNamePasswordKVPairs = (NSMutableDictionary *)[MNKeyChain load:KEY_IN_KEYCHAIN];
    return [userNamePasswordKVPairs objectForKey:KEY_USERID];
}

+(void)deleteUserNameWithPwd
{
    [MNKeyChain delete:KEY_IN_KEYCHAIN];
}
@end
