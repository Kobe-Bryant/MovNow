//
//  MNDeviceBindingViewCtrl.h
//  Movnow
//
//  Created by LiuX on 15/4/25.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//

#import "MNBaseViewCtrl.h"

typedef NS_ENUM(NSInteger, OperationType){
    OperationTypeBinding, //绑定
    OperationTypeUpdateFirmware //升级固件
};

@interface MNDeviceBindingViewCtrl : MNBaseViewCtrl

@property (nonatomic,assign) OperationType type;

@end
