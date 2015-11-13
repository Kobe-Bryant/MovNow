//
//  MNMovementDetailPopView.m
//  Movnow
//
//  Created by LiuX on 15/5/14.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//

#import "MNMovementDetailPopView.h"
#import "MNMovementService.h"
#import "NSDate+Expend.h"
#import "MNStepViewModel.h"

@interface MNMovementDetailPopView ()<UUChartDataSource>

/**
 *  当前展现形式
 */
@property (nonatomic,assign) MovementViewShowType currentShowType;
/**
 *  图表背景视图
 */
@property (weak, nonatomic) IBOutlet UIView *chartBgView;
/**
 *  运动数据模型
 */
@property (nonatomic,strong) MNStepViewModel *stepsModel;

@property (weak, nonatomic) IBOutlet UILabel *topStepsTargetLabel;
@property (weak, nonatomic) IBOutlet UIView *stepBgView;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *dateInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *kmConstLabel;
@property (weak, nonatomic) IBOutlet UILabel *kmDataLabel;
@property (weak, nonatomic) IBOutlet UILabel *stepsDataLabel;
@property (weak, nonatomic) IBOutlet UILabel *kcalDataLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomTextLabel;

@end

@implementation MNMovementDetailPopView

- (MNMovementDetailPopView *)initWithXibFileAndShowType:(MovementViewShowType)showType currentSelectedDate:(NSDate *)currentSelectedDate
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"MNMovementDetailPopView" owner:self options:nil] firstObject];
    
    if (self) {
        
        //视图展示的形式
        _currentShowType = showType;
        
        //初始化frame 运动数据模型
        if (_currentShowType == MovementViewShowTypeMainDeviceVC) {
            self.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
            _stepsModel = [[MNStepViewModel alloc] initToday];
        }else if (_currentShowType == MovementViewShowTypeDayDetailVC){
            self.frame = CGRectMake(0, SCREEN_HEIGHT - 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
            _stepsModel = [[MNStepViewModel alloc]initHistoryWithTime:[[NSDate getStringWithFormat:@"yyyyMMdd" andDate:currentSelectedDate] integerValue]];
        }
        
        self.stepBgView.layer.cornerRadius = 10.f;
        self.stepBgView.clipsToBounds = YES;
        
        [self setChartView];
        
        [self.bgImageView setImage:[UIImage imageNamed:IMAGE_NAME(@"history_outside_cell_detail")]];
        [self.iconImageView setImage:[UIImage imageNamed:IMAGE_NAME(@"history_movement_icon")]];
        
        self.topStepsTargetLabel.text = [NSString stringWithFormat:@"您当前设置的每天目标是%ld步",[MNMovementService shareInstance].goalStep];
        self.dateInfoLabel.text = [NSDate getTimeInfoWithDate:currentSelectedDate];
        
        //判断当前是否为英制
        if ([[U_DEFAULTS objectForKey:IS_BRITISH_SYSTEM] isEqualToString:@"1"]) {
            self.kmConstLabel.text = @"mi";
            self.kmDataLabel.text = [NSString stringWithFormat:@"%.1f",_stepsModel.mileage * 0.6213712];
        }else{
            self.kmConstLabel.text = @"km";
            self.kmDataLabel.text = [NSString stringWithFormat:@"%.1f",_stepsModel.mileage];
        }
        
        self.stepsDataLabel.text = _stepsModel.steps;
        self.kcalDataLabel.text = [NSString stringWithFormat:@"%.1f",_stepsModel.calorie];
    }
    return self;
}

#pragma mark - 设置图表
- (void)setChartView
{
    UUChart *chartView = [[UUChart alloc]initWithUUChartDataFrame:self.chartBgView.bounds withSource:self withStyle:UUChartLineStyle];
    chartView.backgroundColor = [UIColor clearColor];
    [chartView showInView:self.chartBgView];
}

#pragma mark - 显示或隐藏
- (void)showSelf
{
    [UIView animateWithDuration:kAnimationInterval animations:^{
        CGRect tempRect = self.frame;
        if (_currentShowType == MovementViewShowTypeMainDeviceVC) {
            tempRect.origin.y = 64;
        }else if (_currentShowType == MovementViewShowTypeDayDetailVC){
            tempRect.origin.y = 0;
        }
        self.frame = tempRect;
    }];
}

- (void)hideSelf
{
    [UIView animateWithDuration:kAnimationInterval animations:^{
        CGRect tempRect = self.frame;
        if (_currentShowType == MovementViewShowTypeMainDeviceVC) {
            tempRect.origin.y = SCREEN_HEIGHT;
        }else if (_currentShowType == MovementViewShowTypeDayDetailVC){
            tempRect.origin.y = SCREEN_HEIGHT - 64;
        }
        self.frame = tempRect;
    }];
}

#pragma mark - 拖动事件
- (IBAction)didDragBgView:(UIPanGestureRecognizer *)sender
{
    CGPoint translatedPoint = [sender translationInView:self];
    CGFloat centerY = sender.view.center.y + translatedPoint.y;
    
    //极限的Y值
    if (_currentShowType == MovementViewShowTypeMainDeviceVC) {
        if (centerY - HEIGHT(sender.view)/2 < 64) return;
    }else if (_currentShowType == MovementViewShowTypeDayDetailVC){
        if (centerY - HEIGHT(sender.view)/2 < 0) return;
    }
    
    sender.view.center = CGPointMake(sender.view.center.x, centerY);
    [sender setTranslation:CGPointMake(0, 0) inView:self];
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        
        //界面中心的Y值
        CGFloat mediumY = 0;
        if (_currentShowType == MovementViewShowTypeMainDeviceVC) {
            mediumY = SCREEN_HEIGHT/2;
        }else if (_currentShowType == MovementViewShowTypeDayDetailVC){
            mediumY = (SCREEN_HEIGHT - 64)/2;
        }
        if (Y(sender.view) > mediumY) {
            [self hideSelf];
        } else {
            [self showSelf];
        }
    }
}

#pragma mark - UUChartDataSource
- (NSArray *)UUChart_xLabelArray:(UUChart *)chart
{
    //X坐标标题数组
    return @[@"3",@"",@"",@"",@"",@"",
                    @"6",@"",@"",@"",@"",@"",
                    @"9",@"",@"",@"",@"",@"",
                    @"12",@"",@"",@"",@"",@"",
                    @"15",@"",@"",@"",@"",@"",
                    @"18",@"",@"",@"",@"",@"21"];
}

- (NSArray *)UUChart_yValueArray:(UUChart *)chart
{
    //Y坐标数值数组
    return @[_stepsModel.diurnalstepDetails];
}

- (NSArray *)UUChart_ColorArray:(UUChart *)chart
{
    //颜色数组
    return @[NAV_BG_COLOR];
}

- (CGRange)UUChartChooseRangeInLineChart:(UUChart *)chart
{
    //数值显示范围 最大值到最小值
    return CGRangeMake(_stepsModel.diurnalMaxStep, 0);
}

- (BOOL)UUChart:(UUChart *)chart showHorizonLineAtIndex:(NSInteger)index
{
    //显示横线条 只有折线图才会生效
    return YES;
}

@end