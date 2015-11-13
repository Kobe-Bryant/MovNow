//
//  NSString+URL.m
//  Beacon
//
//  Created by hebing on 14/12/22.
//  Copyright (c) 2014年 Movnow. All rights reserved.
//
#import "NSString+URL.h"
#import "NSString+SHA1.h"

@implementation NSString (URL)

- (NSString *)URLEncode
{
    NSArray *escapeChars = [NSArray arrayWithObjects:@";" , @"/" , @"?" , @":" ,
                            @"@" , @"&" , @"=" , @"+" ,
                            @"$" , @"," , @"[" , @"]",
                            @"#", @"!", @"'", @"(",
                            @")", @"*", nil];
    
    NSArray *replaceChars = [NSArray arrayWithObjects:@"%3B" , @"%2F" , @"%3F" ,
                             @"%3A" , @"%40" , @"%26" ,
                             @"%3D" , @"%2B" , @"%24" ,
                             @"%2C" , @"%5B" , @"%5D",
                             @"%23", @"%21", @"%27",
                             @"%28", @"%29", @"%2A", nil];
    
    long len = [escapeChars count];
    
    NSMutableString *temp = [self mutableCopy];
    
    for(int i = 0; i < len; i++)
    {
        [temp replaceOccurrencesOfString:[escapeChars objectAtIndex:i]
                              withString:[replaceChars objectAtIndex:i]
                                 options:NSLiteralSearch
                                   range:NSMakeRange(0, [temp length])];
    }
    
    return [NSString stringWithString:temp];
}

+ (NSString *)createSignWithDictionary:(NSMutableDictionary *)signDict
{
    if (!signDict[@"app_key"] || [signDict[@"app_key"] isEqualToString:@""]) {
        [signDict setValue:_App_Key forKey:@"app_key"];
    }
    if (signDict[@"v"]) {
        
        [signDict setValue:_Version forKey:@"v"];
    }
    NSArray *keyArr = [signDict allKeys];
    keyArr = [keyArr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
        NSComparisonResult result = [obj1 compare:obj2 options:NSCaseInsensitiveSearch];
        return result==NSOrderedDescending;
    }];
    
    NSMutableString *str = [NSMutableString string];
    for (NSString *key in keyArr) {
        [str appendFormat:@"%@%@", key, signDict[key]];
    }
    NSString *signStr = [NSString stringWithFormat:@"%@%@%@", _App_Secret, str, _App_Secret];
    
    return [[signStr getSha1Str] uppercaseString];
}

+ (NSString *)createURLWithDictionary:(NSDictionary *)parameterDict sign:(NSString *)sign
{
    NSMutableString *sendURL = [NSMutableString stringWithFormat:@"%@?", _Web_Site];
    for (NSString *key in parameterDict.allKeys) {
        if ([key isEqualToString:@"timestamp"]) {
            [sendURL appendFormat:@"%@=%@", key, [[parameterDict objectForKey:key] stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
        } else {
            [sendURL appendFormat:@"%@=%@", key, [parameterDict objectForKey:key]];
        }
        [sendURL appendString:@"&"];
    }
    [sendURL appendFormat:@"sign=%@", sign];
    
    return sendURL;
}

+(NSString *)getUserDeviceIdentifier
{
    NSString *os=[NSString stringWithFormat:@"%@-%@-%@",[UIDevice currentDevice].model,[UIDevice currentDevice].systemName,[UIDevice currentDevice].systemVersion];
    NSString *app=@"-2.0";
    
    return [NSString stringWithFormat:@"%@;%@;%@",os,app,@"Bluetooth-4.0"];
}

@end