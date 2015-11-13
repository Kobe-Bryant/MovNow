//
//  NSDictionary+String.m
//  network
//
//  Created by tengqingqing on 14-12-10.
//  Copyright (c) 2014年 ysp. All rights reserved.
//

#import "NSDictionary+String.h"

@implementation NSDictionary (String)

- (NSString *)customRequestString
{
    NSArray *keyArr = [self allKeys];
    
    NSMutableArray *arr = [NSMutableArray array];
    
    for (int i = 0; i < keyArr.count; i++) {
        NSString *key = keyArr[i];
        NSString *value = [self objectForKey:key];
        NSString *str = [NSString stringWithFormat:@"\"%@\":\"%@\"",key,value];
        [arr addObject:str];
    }
    
    NSString *str = [arr componentsJoinedByString:@","];
    NSMutableString *mStr = [NSMutableString stringWithFormat:@"{%@}",str];
    return mStr;
}

- (NSString *)jsonRequestString
{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    return jsonString;
}

@end
