//
//  NSString+URL.h
//  Beacon
//
//  Created by hebing on 14/12/22.
//  Copyright (c) 2014年 Movnow. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (URL)

// URL编码
- (NSString *)URLEncode;

// 将字典加密成数字签名
+ (NSString *)createSignWithDictionary:(NSMutableDictionary *)signDict;

// 根据参数字典和数字签名创建URL
+ (NSString *)createURLWithDictionary:(NSDictionary *)parameterDict sign:(NSString *)sign;

//获取用户设备标识
+(NSString *)getUserDeviceIdentifier;

@end

