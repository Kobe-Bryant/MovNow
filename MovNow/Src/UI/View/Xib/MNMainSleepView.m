//
//  MNMainSleepView.m
//  Movnow
//
//  Created by LiuX on 15/4/25.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//

#import "MNMainSleepView.h"

@interface MNMainSleepView ()<UUChartDataSource>

@property (weak, nonatomic) IBOutlet UIView *chartBgView;

@property (weak, nonatomic) IBOutlet UILabel *deepSleepLabel;
@property (weak, nonatomic) IBOutlet UILabel *shallowSleepLabel;
@property (weak, nonatomic) IBOutlet UIButton *deepSleepHistoryBtn;
@property (weak, nonatomic) IBOutlet UIButton *shallowSleepHistoryBtn;
@property (weak, nonatomic) IBOutlet UIButton *bottomBtn;

@property (nonatomic,copy) CoreEmptyCallBack bottomClickBlock;

/**
 *  当前展现形式
 */
@property (nonatomic,assign) SleepViewShowType currentShowType;

@end

@implementation MNMainSleepView

- (MNMainSleepView *)initWithXibFileAndHeight:(CGFloat)height showType:(SleepViewShowType)showType currentSelectedDate:(NSDate *)currentSelectedDate bottomClickBlock:(CoreEmptyCallBack)bottomClickBlock
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"MNMainSleepView" owner:self options:nil] firstObject];
    
    if (self) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, height);
        
        //视图展示的形式
        _currentShowType = showType;
        
        //初始化睡眠数据模型
        if (_currentShowType == SleepViewShowTypeMainDeviceVC) {
            
        }else if (_currentShowType == SleepViewShowTypeDayDetailVC){

        }
        
        self.deepSleepLabel.text = NSLocalizedString(@"深睡时长", nil);
        self.shallowSleepLabel.text = NSLocalizedString(@"浅睡时长", nil);
        
        [self.deepSleepHistoryBtn setTitle:NSLocalizedString(@"深睡", nil) forState:UIControlStateNormal];
        [self.shallowSleepHistoryBtn setTitle:NSLocalizedString(@"浅睡", nil) forState:UIControlStateNormal];
        
        self.sleepCircleView.msgLabel.text = NSLocalizedString(@"睡眠时长",nil);
        self.sleepCircleView.textLabel.text = @"00:00:00";
        [self.sleepCircleView setPercent:0 animated:YES];
        
        [self.deepSleepHistoryBtn setImage:[UIImage imageNamed:IMAGE_NAME(@"main_deep_sleep_btn")] forState:UIControlStateNormal];
        [self.shallowSleepHistoryBtn setImage:[UIImage imageNamed:IMAGE_NAME(@"main_shallow_sleep_btn")] forState:UIControlStateNormal];
        
        [self.bottomBtn setImage:[UIImage imageNamed:IMAGE_NAME(@"main_bottom_btn")] forState:UIControlStateNormal];
        [self.bottomBtn setImage:[UIImage imageNamed:IMAGE_NAME(@"main_bottom_btn_press")] forState:UIControlStateHighlighted];
        
        [self setChartView];
        
        self.bottomClickBlock = [bottomClickBlock copy];
    }
    return self;
}

#pragma mark - 设置图表
- (void)setChartView
{
    UUChart *chartView = [[UUChart alloc]initWithUUChartDataFrame:self.chartBgView.bounds withSource:self withStyle:UUChartBarStyle];
    chartView.backgroundColor = [UIColor clearColor];
    [chartView showInView:self.chartBgView];
}

- (IBAction)bottomBtnClick:(UIButton *)sender
{
    if (self.bottomClickBlock) {
        self.bottomClickBlock();
    }
}

#pragma mark - UUChartDataSource
- (NSArray *)UUChart_xLabelArray:(UUChart *)chart
{
    //X坐标标题数组
    return @[@"3",@"",
             @"6",@"",
             @"9",@"",
             @"12",@"",
             @"15",@"",
             @"18",@"",@"21"];
}

- (NSArray *)UUChart_yValueArray:(UUChart *)chart
{
    //Y坐标数值数组
    NSArray *dataArr1 = @[@"18",@"13",@"11",@"18",@"19",
                          @"20",@"17",@"15",@"13",@"18",@"11",
                          @"19",@"10",@"6",@"7"];
    NSArray *dataArr2 = @[@"18",@"13",@"11",@"18",@"19",
                          @"20",@"11",@"18",@"13",@"18",@"11",
                          @"19",@"10",@"8",@"10"];
    
    return @[dataArr1,dataArr2];
}

- (NSArray *)UUChart_ColorArray:(UUChart *)chart
{
    //颜色数组
    return @[[UIColor colorWith8BitRed:90 green:93 blue:190],
             [UIColor colorWith8BitRed:114 green:150 blue:195]];
}

- (CGRange)UUChartChooseRangeInLineChart:(UUChart *)chart
{
    //数值显示范围 最大值到最小值
    return CGRangeMake(20, 0);
}

@end