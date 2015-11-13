//
//  MNFirmwareModel.h
//  Movnow
//
//  Created by baoyx on 15/4/15.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
@interface MNFirmwareModel : JSONModel
+(MNFirmwareModel *)sharestance;
@property (nonatomic,copy) NSString *type; //设备类型
@property (nonatomic,copy) NSString *number; //设备编号
@property (nonatomic,copy) NSString *uuid;  //uuid
@property (nonatomic,copy) NSNumber *firmwareVersion; //固件版本
-(void)saveCache;
-(void)clearCache;
@end
