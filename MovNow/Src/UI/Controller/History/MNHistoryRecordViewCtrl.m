//
//  MNHistoryRecordViewCtrl.m
//  Movnow
//
//  Created by LiuX on 15/5/12.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//

#import "MNHistoryRecordViewCtrl.h"
#import "MNHistoryForDayView.h"
#import "MNHistoryForWeekView.h"
#import "MNHistoryForMonthView.h"
#import "NSDate+Expend.h"
#import "MNHistoryForDayDetailViewCtrl.h"
#import "MNHistoryForWeekDetailViewCtrl.h"
#import "MNHistoryForMonthDetailViewCtrl.h"
#import "MNHistoryDetailModel.h"
#import "MNWeekStepViewModel.h"
#import "MNMonthStepViewModel.h"

@interface MNHistoryRecordViewCtrl ()<HistoryForDayViewDelegate,HistoryForWeekViewDelegate,HistoryForMonthViewDelegate>

/**
 *  顶部的背景视图
 */
@property (nonatomic,strong) UIView *HTopBgView;
/**
 *  导航栏右侧按钮
 */
@property (nonatomic,strong) UIButton *HNavRightBtn;
/**
 *  历史数据日期分类弹出视图
 */
@property (nonatomic,strong) UIView *HHistoryDatePopView;
/**
 *  从数据库中取出的历史记录集合
 */
@property (nonatomic,strong) NSSet *HHistoryDataSet;
/**
 *  历史记录视图每日
 */
@property (nonatomic,strong) MNHistoryForDayView *HDayView;
/**
 *  历史记录视图每周
 */
@property (nonatomic,strong) MNHistoryForWeekView *HWeekView;
/**
 *  历史记录视图每月
 */
@property (nonatomic,strong) MNHistoryForMonthView *HMonthView;
/**
 *  返回按钮的文字
 */
@property (nonatomic,copy) NSString *backItemText;

@end

@implementation MNHistoryRecordViewCtrl

- (UIView *)HTopBgView
{
    if (_HTopBgView == nil) {
        _HTopBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
        _HTopBgView.backgroundColor = NAV_BG_COLOR;
    }
    return _HTopBgView;
}

- (UIButton *)HNavRightBtn
{
    if (_HNavRightBtn == nil) {
        _HNavRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _HNavRightBtn.frame = CGRectMake(0, 0, 55, 40);
        [_HNavRightBtn setBackgroundImage:[UIImage imageNamed:IMAGE_NAME(@"history_nav_rightBtn")] forState:UIControlStateNormal];
        [_HNavRightBtn setBackgroundImage:[UIImage imageNamed:IMAGE_NAME(@"history_nav_rightBtn_selected")] forState:UIControlStateSelected];
        [_HNavRightBtn addTarget:self action:@selector(rightBarItemPress:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _HNavRightBtn;
}

- (UIView *)HHistoryDatePopView
{
    if (_HHistoryDatePopView == nil) {
        _HHistoryDatePopView = [[UIView alloc]initWithFrame:CGRectMake(249, 0, 55, 0)];
        _HHistoryDatePopView.backgroundColor = [UIColor colorWith8BitRed:79 green:129 blue:169];
        _HHistoryDatePopView.alpha = 0;
        
        switch (self.historyDataType) {
            case HistoryDataTypeMovement: //运动
            {
                for (NSInteger i = 0; i < 3; i ++) {
                    UIButton *historyDateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    historyDateBtn.frame = CGRectMake(0, 50 * i, WIDTH(_HHistoryDatePopView), 50);
                    [historyDateBtn addTarget:self action:@selector(historyDateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    historyDateBtn.tag = (i + 1) * 100;
                    switch (i) {
                        case 0:
                        {
                            [historyDateBtn setTitle:NSLocalizedString(@"日", nil) forState:UIControlStateNormal];
                        }
                            break;
                        case 1:
                        {
                            [historyDateBtn setTitle:NSLocalizedString(@"周", nil) forState:UIControlStateNormal];
                        }
                            break;
                        case 2:
                        {
                            [historyDateBtn setTitle:NSLocalizedString(@"月", nil) forState:UIControlStateNormal];
                        }
                            break;
                        default:
                            break;
                    }
                    [_HHistoryDatePopView addSubview:historyDateBtn];
                }
            }
                break;
            case HistoryDataTypeSleep: //睡眠
            {
                for (NSInteger i = 0; i < 2; i ++) {
                    UIButton *historyDateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    historyDateBtn.frame = CGRectMake(0, 50 * i, WIDTH(_HHistoryDatePopView), 50);
                    [historyDateBtn addTarget:self action:@selector(historyDateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    historyDateBtn.tag = (i + 1) * 100;
                    switch (i) {
                        case 0:
                        {
                            [historyDateBtn setTitle:NSLocalizedString(@"日", nil) forState:UIControlStateNormal];
                        }
                            break;
                        case 1:
                        {
                            [historyDateBtn setTitle:NSLocalizedString(@"周", nil) forState:UIControlStateNormal];
                        }
                            break;
                        default:
                            break;
                    }
                    [_HHistoryDatePopView addSubview:historyDateBtn];
                }
            }
                break;
            case HistoryDataTypeHeartRate: //心率
            {
                for (NSInteger i = 0; i < 2; i ++) {
                    UIButton *historyDateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    historyDateBtn.frame = CGRectMake(0, 50 * i, WIDTH(_HHistoryDatePopView), 50);
                    [historyDateBtn addTarget:self action:@selector(historyDateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    historyDateBtn.tag = (i + 1) * 100;
                    switch (i) {
                        case 0:
                        {
                            [historyDateBtn setTitle:NSLocalizedString(@"周", nil) forState:UIControlStateNormal];
                        }
                            break;
                        case 1:
                        {
                            [historyDateBtn setTitle:NSLocalizedString(@"月", nil) forState:UIControlStateNormal];
                        }
                            break;
                        default:
                            break;
                    }
                    [_HHistoryDatePopView addSubview:historyDateBtn];
                }
            }
                break;
            default:
                break;
        }
    }
    return _HHistoryDatePopView;
}

- (NSSet *)HHistoryDataSet
{
    if (_HHistoryDataSet == nil) {
        
        //根据跳转类型查询历史数据
        switch (self.historyDataType) {
            case HistoryDataTypeMovement: //运动
            {
                
            }
                break;
            case HistoryDataTypeSleep: //睡眠
            {
                
            }
                break;
            case HistoryDataTypeHeartRate: //心率
            {
                
            }
                break;
            default:
                break;
        }
    }
    return _HHistoryDataSet;
}

- (MNHistoryForDayView *)HDayView
{
    if (_HDayView == nil) {
        _HDayView = [[MNHistoryForDayView alloc]initWithFrame:self.view.bounds];
        _HDayView.calendarSet = self.HHistoryDataSet;
        _HDayView.currentDate = [NSDate date];
        _HDayView.delegate = self;
    }
    return _HDayView;
}

- (MNHistoryForWeekView *)HWeekView
{
    if (_HWeekView == nil) {
        _HWeekView = [[MNHistoryForWeekView alloc]initWithXibFileAndFrame:self.view.bounds historyDataType:self.historyDataType];
        _HWeekView.currentDate = [NSDate date];
        _HWeekView.delegate = self;
    }
    return _HWeekView;
}

- (MNHistoryForMonthView *)HMonthView
{
    if (_HMonthView == nil) {
        _HMonthView = [[MNHistoryForMonthView alloc]initWithXibFileAndFrame:self.view.bounds historyDataType:self.historyDataType];
        _HMonthView.currentDate = [NSDate date];
        _HMonthView.delegate = self;
    }
    return _HMonthView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self executeDefaultSetting];
    
    [self setUpRightBarItem];
}

#pragma mark 返回文字
- (NSString *)backBarItemText
{
    return NSLocalizedString(_backItemText, nil);
}

#pragma mark - 右侧按钮重写
- (void)setUpRightBarItem
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.HNavRightBtn];
}

- (void)rightBarItemPress:(UIButton *)item
{
    item.selected = !item.selected;
    
    [UIView animateWithDuration:kAnimationInterval animations:^{
        if (item.selected == YES) { //展开
            
            [self.view addSubview:self.HHistoryDatePopView];
            
            CGFloat popViewHeight = 0;
            //判断跳转类型
            switch (self.historyDataType) {
                case HistoryDataTypeMovement: //运动
                {
                    popViewHeight = 150;
                }
                    break;
                case HistoryDataTypeSleep: //睡眠
                {
                    popViewHeight = 100;
                }
                    break;
                case HistoryDataTypeHeartRate: //心率
                {
                    popViewHeight = 100;
                }
                    break;
                default:
                    break;
            }
            CGRect tempRect = self.HHistoryDatePopView.frame;
            tempRect.size.height = popViewHeight;
            self.HHistoryDatePopView.frame = tempRect;
            self.HHistoryDatePopView.alpha = 1;
        }else{ //收起
            CGRect tempRect = self.HHistoryDatePopView.frame;
            tempRect.size.height = 0;
            self.HHistoryDatePopView.frame = tempRect;
            self.HHistoryDatePopView.alpha = 0;
        }
    }completion:^(BOOL finished) {
        if (item.selected == NO) {
            [self.HHistoryDatePopView removeFromSuperview];
        }
    }];
}

#pragma mark - 默认配置
- (void)executeDefaultSetting
{
    [self.view addSubview:self.HTopBgView];
    [self.view addSubview:self.HWeekView];
}

#pragma mark - 历史记录日期分类按钮点击事件
- (void)historyDateBtnClick:(UIButton *)btn
{
    [self rightBarItemPress:self.HNavRightBtn];
    
    [self.HDayView removeFromSuperview];
    [self.HWeekView removeFromSuperview];
    [self.HMonthView removeFromSuperview];
    
    switch (self.historyDataType) {
        case HistoryDataTypeMovement: //运动
        {
            switch (btn.tag) {
                case 100: //日
                {
                    [self.view addSubview:self.HDayView];
                }
                    break;
                case 200: //周
                {
                    [self.view addSubview:self.HWeekView];
                }
                    break;
                case 300: //月
                {
                    [self.view addSubview:self.HMonthView];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case HistoryDataTypeSleep: //睡眠
        {
            switch (btn.tag) {
                case 100: //日
                {
                    [self.view addSubview:self.HDayView];
                }
                    break;
                case 200: //周
                {
                    [self.view addSubview:self.HWeekView];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case HistoryDataTypeHeartRate: //心率
        {
            switch (btn.tag) {
                case 100: //周
                {
                    [self.view addSubview:self.HWeekView];
                }
                    break;
                case 200: //月
                {
                    [self.view addSubview:self.HMonthView];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - HistoryForDayViewDelegate
- (void)historyForDayView:(MNHistoryForDayView *)historyForDayView didSelectedDate:(NSDate *)date
{
    MNHistoryForDayDetailViewCtrl *dayDetailVC = [[MNHistoryForDayDetailViewCtrl alloc]initWithNibName:@"MNHistoryForDayDetailViewCtrl" bundle:nil];
    dayDetailVC.historyDataType = self.historyDataType;
    dayDetailVC.currentSelectedDate = date;
    
    _backItemText = @"日记录";
    [self setUpBackBarItem];
    [self.navigationController pushViewController:dayDetailVC animated:YES];
    
    if ([self.HHistoryDataSet containsObject:[NSDate getStringWithFormat:@"yyyyMMdd" andDate:date]]) {
        DLog(@"这一天有历史数据，可以跳转");
    }
}

#pragma mark - HistoryForWeekViewDelegate
- (void)historyForWeekView:(MNHistoryForWeekView *)historyForWeekView didClickButtonIndex:(NSInteger)index
{
    MNHistoryForWeekDetailViewCtrl *weekDetailVC = [[MNHistoryForWeekDetailViewCtrl alloc]initWithNibName:@"MNHistoryForWeekDetailViewCtrl" bundle:nil];
    weekDetailVC.stepsModel = self.HWeekView.stepsModel;
    
    switch (self.historyDataType) {
        case HistoryDataTypeMovement: //运动
        {
            switch (index) {
                case 0: //步数
                {
                    
                }
                    break;
                case 1: //距离
                {
                    
                }
                    break;
                case 2: //卡路里
                {
                    
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case HistoryDataTypeSleep: //睡眠
        {
            
        }
            break;
        case HistoryDataTypeHeartRate: //心率
        {
            
        }
            break;
        default:
            break;
    }
    
    _backItemText = @"周记录";
    [self setUpBackBarItem];
    [self.navigationController pushViewController:weekDetailVC animated:YES];
}

#pragma mark - HistoryForMonthViewDelegate
- (void)historyForMonthView:(MNHistoryForMonthView *)historyForMonthView didClickButtonIndex:(NSInteger)index
{
    MNHistoryForMonthDetailViewCtrl *monthDetailVC = [[MNHistoryForMonthDetailViewCtrl alloc]initWithNibName:@"MNHistoryForMonthDetailViewCtrl" bundle:nil];
    monthDetailVC.stepsModel = self.HMonthView.stepsModel;
    
    switch (index) {
        case 0:
        {
            
        }
            break;
        case 1:
        {
            
        }
            break;
        case 2:
        {
            
        }
            break;
        default:
            break;
    }
    
    _backItemText = @"月记录";
    [self setUpBackBarItem];
    [self.navigationController pushViewController:monthDetailVC animated:YES];
}

@end