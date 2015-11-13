//
//  MNUserModel.m
//  Movnow
//
//  Created by baoyx on 15/4/15.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//

#import "MNUserModel.h"

@implementation MNUserModel
+(MNUserModel *)shareInstance
{
    static MNUserModel *simple;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        simple = [MNUserModel loadCahe];
    });
    return simple;
}

+(MNUserModel *)loadCahe
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    MNUserModel *user = [[MNUserModel alloc] init];
    if ([[[defaults dictionaryRepresentation] allKeys] containsObject:@"user"]) {
        NSString *jsonString = [defaults stringForKey:@"user"];
        user = [[MNUserModel alloc] initWithString:jsonString error:nil];
    }else{
        user.nickName = @"";
        user.sex = @(0);
        user.signature = @"";
        user.birthday = @"19900101";
        user.height = @(175);
        user.weight = @(65);
        user.proId = @(0);
        user.cityId = @(0);
        user.districtId = @(0);
        user.userId = @(0);
        user.avatar = @"";
        
    }
    return user;
}
-(void)gainUser:(NSDictionary *)user
{
    
    if ([[user allKeys] containsObject:@"nickName"]) {
        
        if ([user[@"nickName"] isKindOfClass:[NSNull class]]) {
            _nickName = @"";
        }else
        {
            _nickName = user[@"nickName"];
        }
    }
    
    if ([[user allKeys] containsObject:@"sex"]) {
        _sex = user[@"sex"];
    }
    
    if ([[user allKeys] containsObject:@"signature"]) {
        if ([user[@"signature"] isKindOfClass:[NSNull class]]) {
            
            _signature = @"";
        }else{
            _signature = user[@"signature"];
        }
    }
    
    if ([[user allKeys] containsObject:@"birthday"]) {
        if ([user[@"birthday"] isKindOfClass:[NSNull class]]) {
            _birthday = @"19900101";
        }else
        {
            _birthday = user[@"birthday"];
        }
    }
    
    if ([[user allKeys] containsObject:@"height"]) {
        _height = user[@"height"];
    }
    
    if ([[user allKeys] containsObject:@"weight"]) {
        _weight = user[@"weight"];
    }
    
    if ([[user allKeys] containsObject:@"proId"]) {
        _proId = user[@"proId"];
    }
    
    if ([[user allKeys] containsObject:@"cityId"]) {
        _cityId = user[@"cityId"];
    }
    
    if ([[user allKeys] containsObject:@"districtId"]) {
        _districtId = user[@"districtId"];
    }
    if ([[user allKeys] containsObject:@"userId"]) {
        _userId = user[@"userId"];
    }
    
    if ([[user allKeys] containsObject:@"avatar"]) {
        if ([user[@"avatar"] isKindOfClass:[NSNull class]]) {
            _avatar = @"";
        }else
        {
            _avatar = user[@"avatar"];
        }
    }
    
}
-(void)clearCache
{
    _nickName = @"";
    _sex = @(0);
    _signature = @"";
    _birthday = @"19900101";
    _height = @(175);
    _weight = @(65);
    _proId = @(0);
    _cityId = @(0);
    _districtId = @(0);
    _userId = @(0);
    _avatar = @"";
}

-(void)saveCache
{
    NSString *jsonString = [self toJSONString];
    [U_DEFAULTS setObject:jsonString forKey:@"user"];
    [U_DEFAULTS synchronize];
}

@end
