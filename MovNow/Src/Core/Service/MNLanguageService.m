//
//  MNLanguageService.m
//  Movnow
//
//  Created by LiuX on 15/4/15.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//

#import "MNLanguageService.h"

@implementation MNLanguageService

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (MNLanguageService *)shareInstance
{
    static dispatch_once_t onceToken;
    static MNLanguageService *_mnLanguage = nil;
    dispatch_once(&onceToken, ^{
        _mnLanguage = [[self alloc]init];
    });
    return _mnLanguage;
}

- (CurrentLanguageType)getCurrentLanguage
{
    CurrentLanguageType type;
    NSString *languageName = [[U_DEFAULTS objectForKey:@"AppleLanguages"] objectAtIndex:0];
    
    if ([languageName isEqualToString:@"zh-Hant"]) {
        type = CurrentLanguageTypeChineseTraditional;
    }else if ([languageName isEqualToString:@"zh-Hans"]){
        type = CurrentLanguageTypeChineseSimple;
    }else if ([languageName isEqualToString:@"es"]){
        type = CurrentLanguageTypeSpanish;
    }else{
        type = CurrentLanguageTypeEnglish;
    }
    
    return type;
}

@end
