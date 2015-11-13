//
//  MNMainMovementView.m
//  Movnow
//
//  Created by LiuX on 15/4/25.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//

#import "MNMainMovementView.h"
#import "MNStepViewModel.h"

@interface MNMainMovementView ()<UUChartDataSource>

@property (weak, nonatomic) IBOutlet UIView *chartBgView;

@property (weak, nonatomic) IBOutlet UILabel *mileageLabel;
@property (weak, nonatomic) IBOutlet UILabel *calorieLabel;
@property (weak, nonatomic) IBOutlet UIButton *calorieManagerBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIButton *bottomBtn;

@property (nonatomic,copy) CoreEmptyCallBack calorieClickBlock;
@property (nonatomic,copy) CoreEmptyCallBack shareClickBlock;
@property (nonatomic,copy) CoreEmptyCallBack bottomClickBlock;

/**
 *  当前展现形式
 */
@property (nonatomic,assign) MovementViewShowType currentShowType;
/**
 *  运动数据模型
 */
@property (nonatomic,strong) MNStepViewModel *stepsModel;

@end

@implementation MNMainMovementView

- (MNMainMovementView *)initWithXibFileAndHeight:(CGFloat)height showType:(MovementViewShowType)showType currentSelectedDate:(NSDate *)currentSelectedDate calorieClickBlock:(CoreEmptyCallBack)calorieClickBlock shareClickBlock:(CoreEmptyCallBack)shareClickBlock bottomClickBlock:(CoreEmptyCallBack)bottomClickBlock
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"MNMainMovementView" owner:self options:nil] firstObject];
    
    if (self) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, height);
        
        //视图展示的形式
        _currentShowType = showType;
        
        //初始化运动数据模型
        if (_currentShowType == MovementViewShowTypeMainDeviceVC) {
            _stepsModel = [[MNStepViewModel alloc] initToday];
        }else if (_currentShowType == MovementViewShowTypeDayDetailVC){
            _stepsModel = [[MNStepViewModel alloc] initHistoryWithTime:[[NSDate getStringWithFormat:@"yyyyMMdd" andDate:currentSelectedDate] integerValue]];
        }
        
        self.mileageLabel.text = NSLocalizedString(@"里程", nil);
        self.calorieLabel.text = NSLocalizedString(@"卡路里", nil);
        [self.shareBtn setTitle:NSLocalizedString(@"分享", nil) forState:UIControlStateNormal];
        [self.calorieManagerBtn setTitle:NSLocalizedString(@"卡路里管理", nil) forState:UIControlStateNormal];
        
        self.movementCircleView.msgLabel.text = NSLocalizedString(@"步数",nil);
        self.movementCircleView.textLabel.text = @"0";
        [self.movementCircleView setPercent:0 animated:YES];
        
        [self.calorieManagerBtn setImage:[UIImage imageNamed:IMAGE_NAME(@"main_calorie_btn")] forState:UIControlStateNormal];
        [self.shareBtn setImage:[UIImage imageNamed:IMAGE_NAME(@"main_share_btn")] forState:UIControlStateNormal];
        
        [self.bottomBtn setImage:[UIImage imageNamed:IMAGE_NAME(@"main_bottom_btn")] forState:UIControlStateNormal];
        [self.bottomBtn setImage:[UIImage imageNamed:IMAGE_NAME(@"main_bottom_btn_press")] forState:UIControlStateHighlighted];
        
        [self setChartView];
        
        self.calorieClickBlock = [calorieClickBlock copy];
        self.shareClickBlock = [shareClickBlock copy];
        self.bottomClickBlock = [bottomClickBlock copy];
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

#pragma mark - 按钮点击事件
- (IBAction)calorieManagerBtnClick:(UIButton *)sender
{
    if (self.calorieClickBlock) {
        self.calorieClickBlock();
    }
}

- (IBAction)shareBtnClick:(UIButton *)sender
{
    if (self.shareClickBlock) {
        self.shareClickBlock();
    }
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
    return @[@"0",@"",@"",@"",@"",@"",
                    @"3",@"",@"",@"",@"",@"",
                    @"6",@"",@"",@"",@"",@"",
                    @"9",@"",@"",@"",@"",@"",
                    @"12",@"",@"",@"",@"",@"",
                    @"15",@"",@"",@"",@"",@"",
                    @"18",@"",@"",@"",@"",@"",
                    @"21",@"",@"",@"",@"",@"24"];
}

- (NSArray *)UUChart_yValueArray:(UUChart *)chart
{
    //Y坐标数值数组
    return @[_stepsModel.allDaystepDetails];
}

- (NSArray *)UUChart_ColorArray:(UUChart *)chart
{
    //颜色数组
    return @[NAV_BG_COLOR];
}

- (CGRange)UUChartChooseRangeInLineChart:(UUChart *)chart
{
    //数值显示范围 最大值到最小值
    return CGRangeMake(_stepsModel.allDayMaxStep, 0);
}

- (BOOL)UUChart:(UUChart *)chart showHorizonLineAtIndex:(NSInteger)index
{
    //显示横线条 只有折线图才会生效
    return YES;
}

@end