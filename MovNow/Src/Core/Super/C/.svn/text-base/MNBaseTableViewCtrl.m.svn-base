//
//  MNBaseTableViewCtrl.m
//  CDN
//
//  Created by Oliver on 14/12/22.
//  Copyright (c) 2014年 injoinow. All rights reserved.
//

#import "MNBaseTableViewCtrl.h"

@interface MNBaseTableViewCtrl ()<UIAlertViewDelegate>

@end

@implementation MNBaseTableViewCtrl

- (instancetype)init
{
    return [super initWithStyle:UITableViewStyleGrouped];
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    return [super initWithStyle:UITableViewStyleGrouped];
}

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
    
    self.tableView.backgroundColor = CTRL_BG_COLOR;
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

#pragma mark - 完整的tableview分割线
- (void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

@end