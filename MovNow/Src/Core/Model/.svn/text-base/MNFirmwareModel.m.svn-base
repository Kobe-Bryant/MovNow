//
//  MNFirmwareModel.m
//  Movnow
//
//  Created by baoyx on 15/4/15.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//

#import "MNFirmwareModel.h"

@implementation MNFirmwareModel

+(MNFirmwareModel *)sharestance
{
    static MNFirmwareModel *simple;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        simple = [MNFirmwareModel loadCahe];
    });
    return simple;
}

+(MNFirmwareModel *)loadCahe
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    MNFirmwareModel *firmwareModel = [[MNFirmwareModel alloc] init];
    
    if ([[[defaults dictionaryRepresentation] allKeys] containsObject:@"firmware"]) {
        NSString *jsonString = [defaults stringForKey:@"firmware"];
        firmwareModel = [[MNFirmwareModel alloc] initWithString:jsonString error:nil];
    }else{
        firmwareModel.type=@"";
        firmwareModel.number = @"";
        firmwareModel.uuid = @"";
        firmwareModel.firmwareVersion= @(0);
    }
    return firmwareModel;
    
}

-(void)clearCache
{
    _type = @"";
    _number = @"";
    _uuid = @"";
    _firmwareVersion =@(0);
    
}
-(void)saveCache
{
    NSString *jsonString = [self toJSONString];
    [U_DEFAULTS setObject:jsonString forKey:@"firmware"];
    [U_DEFAULTS synchronize];
}
@end
