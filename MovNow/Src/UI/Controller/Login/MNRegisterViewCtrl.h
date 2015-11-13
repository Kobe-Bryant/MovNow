//
//  MNRegisterViewCtrl.h
//  Movnow
//
//  Created by LiuX on 15/4/15.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//

#import "MNBaseViewCtrl.h"

@interface MNRegisterViewCtrl : MNBaseViewCtrl

//将注册成功后的账户信息回调给主界面
@property (nonatomic,strong) void(^getAccount)(NSString *email,NSString *pwd);

@end
