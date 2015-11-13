//
//  MNFunctionIntroduceViewCtrl.m
//  Movnow
//
//  Created by LiuX on 15/4/23.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//

#import "MNFunctionIntroduceViewCtrl.h"
#import "MNFunctionIntroduceCell.h"

#define CELL_INDENTIFIER @"MNFunctionIntroduceCell"

@implementation MNFunctionIntroduceViewCtrl

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(-35, 0, -35, 0);
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MNFunctionIntroduceCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_INDENTIFIER];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:CELL_INDENTIFIER owner:self options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    switch (indexPath.row) {
        case 0:
        {
            cell.functionLabel.text = NSLocalizedString(@"带着设备活动、睡眠，在手机上查看活动状况、睡眠情况。", nil);
            if ([[MNLanguageService shareInstance] getCurrentLanguage] == CurrentLanguageTypeChineseSimple || [[MNLanguageService shareInstance] getCurrentLanguage] == CurrentLanguageTypeChineseTraditional) {
                [cell.functionImgView setImage:[UIImage imageNamed:IMAGE_NAME(@"Chinese_function_1")]];
            }else if ([[MNLanguageService shareInstance] getCurrentLanguage] == CurrentLanguageTypeEnglish){
                [cell.functionImgView setImage:[UIImage imageNamed:IMAGE_NAME(@"English_function_1")]];
            }else if ([[MNLanguageService shareInstance] getCurrentLanguage] == CurrentLanguageTypeSpanish){
                [cell.functionImgView setImage:[UIImage imageNamed:IMAGE_NAME(@"Spanish_function_1")]];
            }
        }
            break;
        case 1:
        {
            cell.functionLabel.text = NSLocalizedString(@"在手机上设置喝水、久坐、闹钟提醒，设备到达设置事件点时，会给您提醒。", nil);
            if ([[MNLanguageService shareInstance] getCurrentLanguage] == CurrentLanguageTypeChineseSimple || [[MNLanguageService shareInstance] getCurrentLanguage] == CurrentLanguageTypeChineseTraditional) {
                [cell.functionImgView setImage:[UIImage imageNamed:IMAGE_NAME(@"Chinese_function_2")]];
            }else if ([[MNLanguageService shareInstance] getCurrentLanguage] == CurrentLanguageTypeEnglish){
                [cell.functionImgView setImage:[UIImage imageNamed:IMAGE_NAME(@"English_function_2")]];
            }else if ([[MNLanguageService shareInstance] getCurrentLanguage] == CurrentLanguageTypeSpanish){
                [cell.functionImgView setImage:[UIImage imageNamed:IMAGE_NAME(@"Spanish_function_2")]];
            }
        }
            break;
        case 2:
        {
            cell.functionLabel.text = NSLocalizedString(@"当手机来电、短信时，手环在您手边时，会给您震动提醒。", nil);
            if ([[MNLanguageService shareInstance] getCurrentLanguage] == CurrentLanguageTypeChineseSimple || [[MNLanguageService shareInstance] getCurrentLanguage] == CurrentLanguageTypeChineseTraditional) {
                [cell.functionImgView setImage:[UIImage imageNamed:IMAGE_NAME(@"Chinese_function_3")]];
            }else if ([[MNLanguageService shareInstance] getCurrentLanguage] == CurrentLanguageTypeEnglish){
                [cell.functionImgView setImage:[UIImage imageNamed:IMAGE_NAME(@"English_function_3")]];
            }else if ([[MNLanguageService shareInstance] getCurrentLanguage] == CurrentLanguageTypeSpanish){
                [cell.functionImgView setImage:[UIImage imageNamed:IMAGE_NAME(@"Spanish_function_3")]];
            }
        }
            break;
        default:
            break;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}

@end
