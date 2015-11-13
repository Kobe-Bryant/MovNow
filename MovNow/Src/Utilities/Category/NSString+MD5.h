//
//  NSString+MD5.h
//  CDN
//
//  Created by Oliver on 15/1/2.
//  Copyright (c) 2015年 injoinow. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MD5)

//MD5加密
- (NSString *)getMd5Str;

//文件MD5效验
+(BOOL)fileEffectWithMd5:(NSString *)md5 filePath:(NSString *)filePath;

@end
