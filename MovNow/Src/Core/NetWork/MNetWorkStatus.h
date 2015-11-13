//
//  MNetWorkStatus.h
//  Movnow
//
//  Created by HelloWorld on 15/4/14.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MNetWorkStatus : NSObject

+ (MNetWorkStatus *)shareInstance;

/**
 *  是否连接上了网络
 *
 *  @return YES / NO
 */
- (BOOL)isConnectedToTheNetwork;

@end
