//
//  MNHistoryForWeekView.m
//  Movnow
//
//  Created by LiuX on 15/5/12.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//

#import "MNHistoryForWeekView.h"
#import "MNWeekStepViewModel.h"

@interface MNHistoryForWeekView ()<UUChartDataSource>

/**
 *  三张折线图
 */
@property (nonatomic,strong) UUChart *chartView1;
@property (nonatomic,strong) UUChart *chartView2;
@property (nonatomic,strong) UUChart *chartView3;
/**
 *  当前星期的开始日期和结束日期
 */
@property (nonatomic,strong) NSDate *startDate;
@property (nonatomic,strong) NSDate *endDate;

@property (weak, nonatomic) IBOutlet UILabel *topDateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView1;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView2;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView3;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel1;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel2;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel3;
@property (weak, nonatomic) IBOutlet UIView *chartBgView1;
@property (weak, nonatomic) IBOutlet UIView *chartBgView2;
@property (weak, nonatomic) IBOutlet UIView *chartBgView3;
@property (weak, nonatomic) IBOutlet UILabel *stepsConstLabel;
@property (weak, nonatomic) IBOutlet UILabel *kmConstLabel;
@property (weak, nonatomic) IBOutlet UILabel *kcalConstLabel;
@property (weak, nonatomic) IBOutlet UILabel *historyDataLabel1;
@property (weak, nonatomic) IBOutlet UILabel *historyDataLabel2;
@property (weak, nonatomic) IBOutlet UILabel *historyDataLabel3;

@property (nonatomic,strong) NSCalendar *weekCalendar;
@property (nonatomic,assign) HistoryDataType historyDataType;

@end

@implementation MNHistoryForWeekView

- (NSCalendar *)weekCalendar
{
    if (_weekCalendar == nil) {
        _weekCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    }
    return _weekCalendar;
}

- (MNHistoryForWeekView *)initWithXibFileAndFrame:(CGRect)frame historyDataType:(HistoryDataType)historyDataType
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"MNHistoryForWeekView" owner:self options:nil] firstObject];
    
    if (self) {
        self.frame = frame;
        self.backgroundColor = [UIColor clearColor];
        
        [self setChartView];
        
        _historyDataType = historyDataType;
        
        switch (_historyDataType) { //区分历史数据类型
            case HistoryDataTypeMovement: //运动
            {
                [self.iconImageView1 setImage:[UIImage imageNamed:IMAGE_NAME(@"history_steps_icon")]];
                [self.iconImageView2 setImage:[UIImage imageNamed:IMAGE_NAME(@"history_mileage_icon")]];
                [self.iconImageView3 setImage:[UIImage imageNamed:IMAGE_NAME(@"history_calories_icon")]];
                
                self.nameLabel1.text = NSLocalizedString(@"步数:", nil);
                self.nameLabel2.text = NSLocalizedString(@"里程:", nil);
                self.nameLabel3.text = NSLocalizedString(@"卡路里:", nil);
                
                //判断当前是否为英制
                if ([[U_DEFAULTS objectForKey:IS_BRITISH_SYSTEM] isEqualToString:@"1"]) {
                    self.kmConstLabel.text = @"Mi";
                }else{
                    self.kmConstLabel.text = @"Km";
                }
            }
                break;
            case HistoryDataTypeSleep: //睡眠
            {
                [self.iconImageView1 setImage:[UIImage imageNamed:IMAGE_NAME(@"history_sleep_icon")]];
                [self.iconImageView2 setImage:[UIImage imageNamed:IMAGE_NAME(@"history_deepSleep_icon")]];
                [self.iconImageView3 setImage:[UIImage imageNamed:IMAGE_NAME(@"history_shallowSleep_icon")]];
                
                self.nameLabel1.text = NSLocalizedString(@"睡眠时长:", nil);
                self.nameLabel2.text = NSLocalizedString(@"深睡时长:", nil);
                self.nameLabel3.text = NSLocalizedString(@"浅睡时长:", nil);
                
                self.stepsConstLabel.hidden = YES;
                self.kmConstLabel.hidden = YES;
                self.kcalConstLabel.hidden = YES;
            }
                break;
            case HistoryDataTypeHeartRate: //心率
            {
                
            }
                break;
            default:
                break;
        }
        
        //左滑手势
        UISwipeGestureRecognizer *leftSwipe=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(leftSwipe:)];
        leftSwipe.direction=UISwipeGestureRecognizerDirectionLeft;
        [self addGestureRecognizer:leftSwipe];
        
        //右滑手势
        UISwipeGestureRecognizer *rightSwipe=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(rightSwipe:)];
        rightSwipe.direction=UISwipeGestureRecognizerDirectionRight;
        [self addGestureRecognizer:rightSwipe];
    }
    return self;
}

#pragma mark - 设置图表
- (void)setChartView
{
    _chartView1 = [[UUChart alloc]initWithUUChartDataFrame:self.chartBgView1.bounds withSource:self withStyle:UUChartLineStyle];
    _chartView1.backgroundColor = [UIColor clearColor];
    _chartView1.tag = 10;
    [_chartView1 addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chartViewClick:)]];
    [_chartView1 showInView:self.chartBgView1];
    
    _chartView2 = [[UUChart alloc]initWithUUChartDataFrame:self.chartBgView2.bounds withSource:self withStyle:UUChartLineStyle];
    _chartView2.backgroundColor = [UIColor clearColor];
    _chartView2.tag = 11;
    [_chartView2 addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chartViewClick:)]];
    [_chartView2 showInView:self.chartBgView2];
    
    _chartView3 = [[UUChart alloc]initWithUUChartDataFrame:self.chartBgView3.bounds withSource:self withStyle:UUChartLineStyle];
    _chartView3.backgroundColor = [UIColor clearColor];
    _chartView3.tag = 12;
    [_chartView3 addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chartViewClick:)]];
    [_chartView3 showInView:self.chartBgView3];
}

- (void)setCurrentDate:(NSDate *)currentDate
{
    _currentDate = currentDate;
    
    //周记录起始时间
    _startDate = [NSDate getWeekRangeArrWithDate:currentDate][0];
    _endDate = [NSDate getWeekRangeArrWithDate:currentDate][1];
    
    self.topDateLabel.text = [NSString stringWithFormat:@"%@ - %@",[NSDate getStringWithFormat:@"yyyy/MM/dd" andDate:_startDate],[NSDate getStringWithFormat:@"yyyy/MM/dd" andDate:_endDate]];
    
    //更新数据模型
    switch (_historyDataType) {
        case HistoryDataTypeMovement: //运动
        {
            _stepsModel = [[MNWeekStepViewModel alloc]initWeekWithStartDate:_startDate withEndDate:_endDate];
            
            self.historyDataLabel1.text = [NSString stringWithFormat:@"%ld",_stepsModel.sumStep];
            //判断当前是否为英制
            if ([[U_DEFAULTS objectForKey:IS_BRITISH_SYSTEM] isEqualToString:@"1"]) {
                self.historyDataLabel2.text = [NSString stringWithFormat:@"%f",_stepsModel.sumMileage * 0.6213712];
            }else{
                self.historyDataLabel2.text = [NSString stringWithFormat:@"%ld",_stepsModel.sumMileage];
            }
            self.historyDataLabel3.text = [NSString stringWithFormat:@"%ld",_stepsModel.sumCalorie];
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
    
    //刷新表格
    [_chartView1 strokeChart];
    [_chartView2 strokeChart];
    [_chartView3 strokeChart];
}

- (void)chartViewClick:(UITapGestureRecognizer *)sender
{
    if ([self.delegate respondsToSelector:@selector(historyForWeekView:didClickButtonIndex:)]) {
        [self.delegate historyForWeekView:self didClickButtonIndex:sender.view.tag - 10];
    }
}

#pragma mark - 左右滑动事件
-(void)leftSwipe:(UISwipeGestureRecognizer*)leftSwipe
{
    //选择的时间区间不能大于今天
    if ([[NSDate nextDay:_currentDate Days:7] compare:[NSDate date]] == NSOrderedDescending) return;
    
    //让当前日期前进一周
    self.currentDate = [NSDate nextDay:_currentDate Days:7];
    
    [UIView transitionWithView:self
                      duration:0.5
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    animations:^{
                        [self setNeedsDisplay];
                    }completion:nil];
}

-(void)rightSwipe:(UISwipeGestureRecognizer*)rightSwipe
{
    //让当前日期后退一周
    self.currentDate = [NSDate preDay:_currentDate Days:7];
    
    [UIView transitionWithView:self
                      duration:0.5
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                        [self setNeedsDisplay];
                    }completion:nil];
}

#pragma mark - UUChartDataSource
- (NSArray *)UUChart_xLabelArray:(UUChart *)chart
{
    //X坐标标题数组
    return @[@"",@"",@"",@"",@"",@"",@""];
}

- (NSArray *)UUChart_yValueArray:(UUChart *)chart
{
    //Y坐标数值数组
    switch (_historyDataType) {
        case HistoryDataTypeMovement: //运动
        {
            if (chart == _chartView1) {
                return @[_stepsModel.steps];
            }else if (chart == _chartView2) {
                return @[_stepsModel.mileages];
            }else {
                return @[_stepsModel.calories];
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
    
    return @[];
}

- (NSArray *)UUChart_ColorArray:(UUChart *)chart
{
    //颜色数组
    return @[NAV_BG_COLOR];
}

- (CGRange)UUChartChooseRangeInLineChart:(UUChart *)chart
{
    //数值显示范围 最大值到最小值
    switch (_historyDataType) {
        case HistoryDataTypeMovement: //运动
        {
            if (chart == _chartView1) {
                return CGRangeMake(_stepsModel.maxStep, 0);
            }else if (chart == _chartView2) {
                return CGRangeMake(_stepsModel.maxMileage, 0);
            }else {
                return CGRangeMake(_stepsModel.maxCalorie, 0);
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
    return CGRangeMake(0, 0);
}

- (BOOL)UUChart:(UUChart *)chart showHorizonLineAtIndex:(NSInteger)index
{
    //显示横线条 只有折线图才会生效
    return YES;
}

@end