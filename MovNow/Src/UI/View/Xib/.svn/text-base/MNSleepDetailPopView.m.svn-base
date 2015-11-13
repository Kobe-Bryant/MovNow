//
//  MNSleepDetailPopView.m
//  Movnow
//
//  Created by LiuX on 15/5/14.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//

#import "MNSleepDetailPopView.h"
#import "MNSleepDetailCell.h"

#define CELL_IDENTIFIER @"MNSleepDetailCell"

@interface MNSleepDetailPopView ()<UICollectionViewDataSource,UICollectionViewDelegate,UUChartDataSource>

/**
 *  当前展现形式
 */
@property (nonatomic,assign) SleepViewShowType currentShowType;
/**
 *  图表背景视图
 */
@property (weak, nonatomic) IBOutlet UIView *chartBgView;

@property (weak, nonatomic) IBOutlet UILabel *topTextLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *sleepCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *bottomTextLabel;

@end

@implementation MNSleepDetailPopView

- (MNSleepDetailPopView *)initWithXibFileAndShowType:(SleepViewShowType)showType currentSelectedDate:(NSDate *)currentSelectedDate
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"MNSleepDetailPopView" owner:self options:nil] firstObject];
    
    if (self) {
        
        //视图展示的形式
        _currentShowType = showType;
        
        if (_currentShowType == SleepViewShowTypeMainDeviceVC) {
            self.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
        }else if (_currentShowType == SleepViewShowTypeDayDetailVC){
            self.frame = CGRectMake(0, SCREEN_HEIGHT - 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
        }
        
        [self.sleepCollectionView registerNib:[UINib nibWithNibName:CELL_IDENTIFIER bundle:nil] forCellWithReuseIdentifier:CELL_IDENTIFIER];
        //默认选中第一个
        [self.sleepCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        
        [self setChartView];
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

#pragma mark - 显示或隐藏
- (void)showSelf
{
    [UIView animateWithDuration:kAnimationInterval animations:^{
        CGRect tempRect = self.frame;
        if (_currentShowType == SleepViewShowTypeMainDeviceVC) {
            tempRect.origin.y = 64;
        }else if (_currentShowType == SleepViewShowTypeDayDetailVC){
            tempRect.origin.y = 0;
        }
        self.frame = tempRect;
    }];
}

- (void)hideSelf
{
    [UIView animateWithDuration:kAnimationInterval animations:^{
        CGRect tempRect = self.frame;
        if (_currentShowType == SleepViewShowTypeMainDeviceVC) {
            tempRect.origin.y = SCREEN_HEIGHT;
        }else if (_currentShowType == SleepViewShowTypeDayDetailVC){
            tempRect.origin.y = SCREEN_HEIGHT - 64;
        }
        self.frame = tempRect;
    }];
}

- (IBAction)didDragBgView:(UIPanGestureRecognizer *)sender
{
    CGPoint translatedPoint = [sender translationInView:self];
    CGFloat centerY = sender.view.center.y + translatedPoint.y;
    
    //极限的Y值
    if (_currentShowType == SleepViewShowTypeMainDeviceVC) {
        if (centerY - HEIGHT(sender.view)/2 < 64) return;
    }else if (_currentShowType == SleepViewShowTypeDayDetailVC){
        if (centerY - HEIGHT(sender.view)/2 < 0) return;
    }
    
    sender.view.center = CGPointMake(sender.view.center.x, centerY);
    [sender setTranslation:CGPointMake(0, 0) inView:self];
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        
        //界面中点的Y值
        CGFloat mediumY = 0;
        if (_currentShowType == SleepViewShowTypeMainDeviceVC) {
            mediumY = SCREEN_HEIGHT/2;
        }else if (_currentShowType == SleepViewShowTypeDayDetailVC){
            mediumY = (SCREEN_HEIGHT - 64)/2;
        }
        if (Y(sender.view) > mediumY) {
            [self hideSelf];
        } else {
            [self showSelf];
        }
    }
}

#pragma mark - UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MNSleepDetailCell *cell = (MNSleepDetailCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    
    if (indexPath.item == 0) {
        [cell setTransform:CGAffineTransformIdentity];
    }else{
        [cell setTransform:CGAffineTransformMakeScale(0.7, 0.7)];
    }
    
    return cell;
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
                         @"20",@"17",@"18",@"13",@"18",@"11",
                         @"19",@"10",@"6",@"7",@"9"];
    NSArray *dataArr2 = @[@"18",@"13",@"11",@"18",@"19",
                          @"20",@"17",@"18",@"13",@"18",@"11",
                          @"19",@"10",@"6",@"7",@"9"];
    
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