//
//  MNDialogOtaUpgradeService.h
//  Movnow
//
//  Created by baoyx on 15/5/7.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//  dialogOTA升级服务类

#import <Foundation/Foundation.h>

@interface MNDialogOtaUpgradeService : NSObject
+(MNDialogOtaUpgradeService*)shareInstance;
-(void)startDialogOtaUpgradeProgress:(void (^)(int progress))progress withSuccess:(CoreFailure)success withFailure:(CoreFailure)failure;
@end
