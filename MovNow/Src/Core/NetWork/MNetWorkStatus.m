//
//  MNetWorkStatus.m
//  Movnow
//
//  Created by HelloWorld on 15/4/14.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//

#import "MNetWorkStatus.h"
#import "Reachability.h"

@interface MNetWorkStatus ()

@property (nonatomic,strong) Reachability *reachDetector;

@end

@implementation MNetWorkStatus

- (Reachability *)reachDetector
{
    if (_reachDetector == nil) {
        _reachDetector = [Reachability reachabilityForInternetConnection];
    }
    return _reachDetector;
}

+ (MNetWorkStatus *)shareInstance
{
    static dispatch_once_t onceToken;
    static MNetWorkStatus *_mnStatus = nil;
    dispatch_once(&onceToken, ^{
        _mnStatus = [[self alloc]init];
    });
    return _mnStatus;
}

-(BOOL)isConnectedToTheNetwork
{   
    [self.reachDetector startNotifier];
    
    switch ([self.reachDetector currentReachabilityStatus]){
        case NotReachable:
        {
            DLog(@"当前没有网络...");
            return NO;
        }
            break;
        case ReachableViaWiFi:
        {
            DLog(@"当前为WiFi网络...");
            return YES;
        }
            break;
        case ReachableViaWWAN:
        {
            DLog(@"当前为手机GPRS网络...");
            return YES;
        }
            break;
        default:
            return NO;
            break;
    }
}

@end
