//
//  NSString+RegexAddition.m
//  ==============================================
//  正则相关
//  ==============================================
//  Created by Fish on 14-3-21.
//  Copyright (c) 2014年 Fish. All rights reserved.
//

#import "NSString+RegexAddition.h"

#define REGULAR_FILE_NAME @"Regular"

// 判断邮件格式正则表达式
#define EMAIL_REGEX_NAME @"\\b([a-zA-Z0-9%_.+\\-]+)@([a-zA-Z0-9.\\-]+?\\.[a-zA-Z]{2,6})\\b"

// 判断数字正则表达式
#define NUMBER_REGEX_NAME @"^[0-9]*$"

// 判断英文正则表达式
#define ENGLISH_REGEX_NAME @"^[A-Za-z]+$"

// 判断中文正则表达式
#define CHINESE_REGEX_NAME @"^[\u4e00-\u9fa5],{0,}$"

// 判断网址正则表达式
#define INTERNET_URL_REGEX_NAME @"^http://([\\w-]+\\.)+[\\w-]+(/[\\w-./?%&=]*)?$ ；^[a-zA-z]+://(w+(-w+)*)(.(w+(-w+)*))*(?S*)?$"

//判断手机正则表达式
#define PHONE_REGEX_NAME @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,0-9]))\\d{8}$"

@implementation NSString (RegexAddition)

// 邮件
- (BOOL)isValidateEmail
{
    NSPredicate *regex = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", EMAIL_REGEX_NAME];
    return [regex evaluateWithObject:self];
}

// 数字
- (BOOL)isNumber
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", NUMBER_REGEX_NAME];
    return [predicate evaluateWithObject:self];
}

// 英文
- (BOOL)isEnglish
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", ENGLISH_REGEX_NAME];
    return [predicate evaluateWithObject:self];
}

// 汉字
- (BOOL)isChinese
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CHINESE_REGEX_NAME];
    return [predicate evaluateWithObject:self];
}

// 网址
- (BOOL)isInternetUrl
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", INTERNET_URL_REGEX_NAME];
    return [predicate evaluateWithObject:self];
}

// 手机号码
- (BOOL)isMobileNumber
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",PHONE_REGEX_NAME];
    return [predicate evaluateWithObject:self];
}

//密码强度
- (NSInteger)judgePasswordStrongth
{
    NSArray *tempArray1 = [[NSArray alloc] initWithObjects:@"a", @"b", @"c", @"d", @"e", @"f", @"g", @"h", @"i", @"j", @"k", @"l", @"m", @"n", @"o", @"p", @"q", @"r", @"s", @"t", @"u", @"v", @"w", @"x", @"y", @"z", nil];
    
    NSArray *tempArray2 = [[NSArray alloc] initWithObjects:@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"0", nil];
    
    NSArray *tempArray3 = [[NSArray alloc] initWithObjects:@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", nil];
    
    NSArray *tempArray4 = [[NSArray alloc] initWithObjects:@"~",@"`",@"@",@"#",@"$",@"%",@"^",@"&",@"*",@"(",@")",@"-",@"_",@"+",@"=",@"{",@"}",@"[",@"]",@"|",@":",@";",@"“",@"'",@"‘",@"<",@",",@".",@">",@"?",@"/",@"、", nil];
    
    NSString* result1 = [NSString stringWithFormat:@"%d",[self judgeRange:tempArray1 password:self]];
    NSString* result2 = [NSString stringWithFormat:@"%d",[self judgeRange:tempArray2 password:self]];
    NSString* result3 = [NSString stringWithFormat:@"%d",[self judgeRange:tempArray3 password:self]];
    NSString* result4 = [NSString stringWithFormat:@"%d",[self judgeRange:tempArray4 password:self]];
    
    NSMutableArray *resultArray = [NSMutableArray arrayWithObjects:result1,result2,result3,result4,nil];
    
    NSInteger strongLevel = 0;
    for (NSString *result in resultArray) {
        if ([result isEqualToString:@"1"]) {
            strongLevel ++;
        }
    }
    
    return strongLevel;
}

// 判断是否包含
- (BOOL)judgeRange:(NSArray *)tempArray password:(NSString *)password
{
    BOOL result = NO;
    for (int i = 0; i < [tempArray count]; i ++){
        if ([password rangeOfString:[tempArray objectAtIndex:i]].location != NSNotFound){
            result = YES;
        }
    }
    return result;
}

@end
