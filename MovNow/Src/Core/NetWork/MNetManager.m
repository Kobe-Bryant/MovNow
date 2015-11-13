//
//  MNetManager.m
//  Movnow
//
//  Created by baoyx on 15/4/14.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//

#import "MNetManager.h"
#import "AFNetworking.h"
#import "MNetWorkStatus.h"
#import "NSString+URL.h"
#import "MNUserKeyChain.h"
#import "JSONKit.h"
#import "zlib.h"
#import "NSString+MD5.h"

@implementation MNetManager
+(void)netGetWithParameter:(NSDictionary *)parameter success:(CoreSuccess)success failure:(CoreFailure)failure
{
    if (![[MNetWorkStatus shareInstance] isConnectedToTheNetwork]) {
        DLog(@"%@",NSLocalizedString(@"当前网络不可用,请检查你的网络设置",nil));
        return;
    }
    NSMutableDictionary *signInfo = [NSMutableDictionary dictionaryWithDictionary:parameter];
    [signInfo setValue:_App_Key forKey:@"app_key"];
    [signInfo setValue:_Version forKey:@"v"];
    NSString *sign = [NSString createSignWithDictionary:signInfo];
    NSString *webUrl = [NSString createURLWithDictionary:signInfo sign:sign];
    NSURL *url = [NSURL URLWithString:webUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setAllHTTPHeaderFields:@{@"User-Agent":[NSString getUserDeviceIdentifier]}];

    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        success(JSON);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        DLog(@"网路出错,原因:error=%@ 描述:%@",error,JSON);
        failure(JSON);
    }];
    [operation start];
    
}
+(void)netGetCacheWithParameter:(NSDictionary *)parameter success:(CoreSuccess)success failure:(CoreFailure)failure loginOut:(void(^)(void))loginOut
{
    __block NSMutableDictionary *signInfo = [NSMutableDictionary dictionaryWithDictionary:parameter];
    [signInfo setValue:(NSString *)[MNUserKeyChain readSession] forKey:@"session"];
    
    [self netGetWithParameter:signInfo success:^(id result) {
        if ([[result allKeys] containsObject:@"error"]) {
            if ([result[@"error" ] isEqualToString:@"27"]) {
                
                [self gainSession:^(NSString *token) {
                    signInfo[@"session"] =token;
                    [self netGetWithParameter:signInfo success:^(id result) {
                        success(result);
                    } failure:^(id reason) {
                        failure(reason);
                    }];
                    
                } withfailure:^{
                    loginOut();
                } withError:^(id reason) {
                    failure(reason);
                }];
                
            }else
            {
                success(result);
            }
        }
        
    } failure:^(id reason) {
        failure(reason);
        
    }];
}
+(void)gainSession:(void (^)(NSString *token))success withfailure:(void (^)(void))failure withError:(CoreFailure)error
{
    NSString *userName = (NSString *)[MNUserKeyChain readUserName];
    NSString *passWord = (NSString *)[MNUserKeyChain readPassWord];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setValue:@"user.login" forKey:@"method"];
    [parameter setValue:userName forKey:@"username"];
    [parameter setValue:passWord forKey:@"password"];
    
    [self netGetWithParameter:parameter success:^(id result) {
        if ([result[@"error"] isEqualToString:@"0"]) {
            if ([result[@"sessionId"] isKindOfClass:[NSNull class]]) {
                failure();
            }else
            {
                success((NSString *)result[@"sessionId"]);
            }
        }else
        {
            failure();
        }
        
    } failure:^(id reason) {
        error(reason);
    }];
}
#define BOUNDARY @"ABC12345678"
+(void)uploadFile:(NSData *)fileData withToken:(NSString *)token success:(CoreSuccess)success failure:(CoreFailure)failure
{
    NSString *str=[NSString stringWithFormat:@"%@&filename=%@&token=%@",_UploadPicUrl,@"q2.jpg",token];
    NSURL *url=[NSURL URLWithString:str];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    [request addValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", BOUNDARY] forHTTPHeaderField:@"Content-Type"];
    NSMutableString *bodyString = [NSMutableString string];
    [bodyString appendFormat:@"--%@\r\n", BOUNDARY];
    [bodyString appendString:@"Content-Disposition: form-data; name=\"action\"\r\n"];
    [bodyString appendString:@"\r\n"];
    NSLog(@"bodyString is %@..",bodyString);
    NSMutableData *bodyData = [[NSMutableData alloc] init];
    NSData *bodyStringData = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
    
    [bodyData appendData:bodyStringData];
    [bodyData appendData:fileData];
    NSString *endString = [NSString stringWithFormat:@"\r\n--%@--\r\n", BOUNDARY];
    NSData *endData = [endString dataUsingEncoding:NSUTF8StringEncoding];
    [bodyData appendData:endData];
    
    NSString *len = [NSString stringWithFormat:@"%ld", (unsigned long)[bodyData length]];
    // 计算bodyData的总长度  根据该长度写Content-Lenngth字段
    [request addValue:len forHTTPHeaderField:@"Content-Length"];
    [request addValue:[NSString getUserDeviceIdentifier] forHTTPHeaderField:@"User-Agent"];
    // 设置请求体
    [request setHTTPBody:bodyData];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        success(JSON);
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
         DLog(@"网路出错,原因:error=%@ 描述:%@",error,JSON);
        failure(JSON);
    }];
    [operation start];
}
+(void)sendUpdateBraceletDataWithData:(NSDictionary *)data
{
    if (![[MNetWorkStatus shareInstance] isConnectedToTheNetwork]) {
        return;
    }
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSString *timestamp = [df stringFromDate:[NSDate date]];
    NSMutableDictionary *signInfo = [NSMutableDictionary dictionary];
    [signInfo setValue:_App_Key forKey:@"app_key"];
    //    [signInfo setValue:_Verson forKey:@"v"];
    [signInfo setValue:@"bracelet.receivebraceletdata" forKey:@"method"];
    [signInfo setValue:timestamp forKey:@"timestamp"];
    [signInfo setValue:@"1" forKey:@"data_type"];
     NSString *sign = [NSString createSignWithDictionary:signInfo];
    //POST
    //转换为URL
    NSURL *postURL = [NSURL URLWithString:_API_BRACELET_PATH];
    //第二个区别点(请求为NSMutableURLRequest)
    NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:postURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    //第四点(必须手动声明当前的请求方式为POST)
    [postRequest setHTTPMethod:@"POST"];
    //设置<HEADER>中的参数
    [postRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [postRequest addValue:[NSString getUserDeviceIdentifier] forHTTPHeaderField:@"User-Agent"];
    [postRequest addValue:@"bracelet.receivebraceletdata" forHTTPHeaderField:@"method"];
    [postRequest addValue:@"1" forHTTPHeaderField:@"data_type"];
    [postRequest addValue:_App_Key forHTTPHeaderField:@"app_key"];
    [postRequest addValue:timestamp forHTTPHeaderField:@"timestamp"];
    [postRequest addValue:sign forHTTPHeaderField:@"sign"];
    NSString *dataJson=[data JSONString];
    
    /* 原始数据 */
    NSData *stringData = [dataJson dataUsingEncoding:NSUTF8StringEncoding];
    NSInteger len = [stringData length];
    
    /* 压缩 */
    Byte byteData[len];
    unsigned long byteLen = sizeof(byteData);
    compress(byteData, &byteLen, [stringData bytes], len);
    NSLog(@"压缩前大小：%ld,  压缩后大小：%lu", (long)len, byteLen);
    [postRequest setHTTPBody:[NSData dataWithBytes:byteData length:len]];
    
}

+(void)downLatestFirmwareWithUrl:(NSString *)url withToken:(NSString *)token withFileName:(NSString *)name withSuccess:(CoreSuccess)success withFailure:(CoreFailure)failure
{
    NSURL *webUrl = [NSURL URLWithString:url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:webUrl];
    [request setAllHTTPHeaderFields:@{@"User-Agent":[NSString getUserDeviceIdentifier]}];
    NSString *cachepath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *fileName = [cachepath stringByAppendingPathComponent:name];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setOutputStream:[NSOutputStream outputStreamToFileAtPath:fileName append:NO]];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([NSString fileEffectWithMd5:token filePath:fileName]) {
            //md5校验成功
            success(@{@"error":@"0",@"message":@"固件MD5校验成功"});
        }else
        {
            //md5校验失败
            success(@{@"error":@"1",@"message":@"固件MD5校验失败"});
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}
@end
