//
//  MNetManager.h
//  Movnow
//
//  Created by baoyx on 15/4/14.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MNetManager : NSObject
+(void)netGetWithParameter:(NSDictionary *)parameter success:(CoreSuccess)success failure:(CoreFailure)failure;
+(void)netGetCacheWithParameter:(NSDictionary *)parameter success:(CoreSuccess)success failure:(CoreFailure)failure loginOut:(void(^)(void))loginOut;
+(void)uploadFile:(NSData *)fileData withToken:(NSString *)token success:(CoreSuccess)success failure:(CoreFailure)failure;
+(void)sendUpdateBraceletDataWithData:(NSDictionary *)data;
+(void)downLatestFirmwareWithUrl:(NSString *)url withToken:(NSString *)token withFileName:(NSString *)name withSuccess:(CoreSuccess)success withFailure:(CoreFailure)failure;
@end
