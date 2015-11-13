//
//  MNBaseViewCtrl.m
//  CDN
//
//  Created by Yigol on 14/12/20.
//  Copyright (c) 2014年 injoinow. All rights reserved.
//

#import "MNBaseViewCtrl.h"

@interface MNBaseViewCtrl ()

@end

@implementation MNBaseViewCtrl

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }else{
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setUpBackBarItem];
    
    self.view.backgroundColor = CTRL_BG_COLOR;
}

#pragma mark - 左侧按钮
- (void)setUpBackBarItem
{
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:[self backBarItemText] style:UIBarButtonItemStylePlain target:self action:nil];
}

- (NSString *)backBarItemText
{
    return @"";
}

#pragma mark - 右侧按钮
- (void)setUpRightBarItem
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:[self rightBarItemText] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarItemPress:)];
}

- (NSString *)rightBarItemText
{
    return @"";
}

- (void)rightBarItemPress:(UIButton *)item
{
    
}
@end
