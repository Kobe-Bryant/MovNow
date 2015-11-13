//
//  MNProtocolViewCtrl.m
//  Movnow
//
//  Created by LiuX on 15/4/15.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//

#import "MNProtocolViewCtrl.h"

@interface MNProtocolViewCtrl ()

/**
 *  服务协议textView
 */
@property (weak, nonatomic) IBOutlet UITextView *PProtocolTW;

@end

@implementation MNProtocolViewCtrl

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loaclOperation];
}

#pragma mark - 本地化操作
- (void)loaclOperation
{
    self.PProtocolTW.text = NSLocalizedString(@"服务协议内容", nil);
}

@end
