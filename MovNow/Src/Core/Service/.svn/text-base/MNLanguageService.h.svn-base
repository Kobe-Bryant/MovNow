//
//  MNLanguageService.h
//  Movnow
//
//  Created by LiuX on 15/4/15.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//  判断当前系统语言的服务类

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CurrentLanguageType){
    CurrentLanguageTypeChineseSimple = 0, //简体中文
    CurrentLanguageTypeChineseTraditional, //繁体中文
    CurrentLanguageTypeEnglish, //英语
    CurrentLanguageTypeSpanish //西班牙
};

@interface MNLanguageService : NSObject

+ (MNLanguageService *)shareInstance;

- (CurrentLanguageType)getCurrentLanguage;

@end
