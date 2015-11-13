//
//  MNSleepModel.m
//  Movnow
//
//  Created by baoyx on 15/4/16.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//

#import "MNSleepModel.h"
#import "MNUserKeyChain.h"
#import "MNFirmwareModel.h"
@implementation MNSleepModel
-(instancetype)init
{
    if (self = [super init]) {
        _userId = (NSNumber *)[MNUserKeyChain readUserID];
        _deviceId = [MNFirmwareModel sharestance].number;
        _deviceType = [MNFirmwareModel sharestance].type;
    }
    return self;
}

@end
