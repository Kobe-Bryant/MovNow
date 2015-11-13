//
//  MNHistoryForMonthDetailViewCtrl.m
//  Movnow
//
//  Created by LiuX on 15/5/13.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//

#import "MNHistoryForMonthDetailViewCtrl.h"
#import "MNHistoryDetailCell.h"
#import "MNHistoryDetailModel.h"
#import "MNMonthStepViewModel.h"

#define CELL_IDENTIFIER @"MNHistoryDetailCell"

@interface MNHistoryForMonthDetailViewCtrl ()<UUChartDataSource>

/**
 *  图表背景视图
 */
@property (weak, nonatomic) IBOutlet UIView *HChartBgView;
/**
 *  图表
 */
@property (nonatomic,strong) UUChart *HChartView;
/**
 *  月历史数据CollectionView
 */
@property (weak, nonatomic) IBOutlet UICollectionView *HWeekOfMonthCollectionView;
/**
 *  当前选中的周数组
 */
@property (nonatomic,strong) NSMutableArray *HSelectedMonthChartArr;
/**
 *  周数组最大值
 */
@property (nonatomic,assign) NSInteger HWeekMaxData;

@end

@implementation MNHistoryForMonthDetailViewCtrl

- (NSMutableArray *)HSelectedMonthChartArr
{
    if (_HSelectedMonthChartArr == nil) {
        _HSelectedMonthChartArr = [NSMutableArray array];
    }
    return _HSelectedMonthChartArr;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setChartView];
    
    [self executeDefaultSetting];
}

#pragma mark - 设置图表
- (void)setChartView
{
    _HChartView = [[UUChart alloc]initWithUUChartDataFrame:self.HChartBgView.bounds withSource:self withStyle:UUChartLineStyle];
    _HChartView.backgroundColor = [UIColor clearColor];
    [_HChartView showInView:self.HChartBgView];
}

- (void)setMonthRecordModelArr:(NSMutableArray *)monthRecordModelArr
{
    _monthRecordModelArr = monthRecordModelArr;
}

#pragma mark - 默认配置
- (void)executeDefaultSetting
{
    [self.HWeekOfMonthCollectionView registerNib:[UINib nibWithNibName:CELL_IDENTIFIER bundle:nil] forCellWithReuseIdentifier:CELL_IDENTIFIER];
    [self.HWeekOfMonthCollectionView reloadData];
    
    //默认是第一周的数据
    if (self.monthRecordModelArr.count > 0) {
        [self.HWeekOfMonthCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    }
}

#pragma mark - UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.HSelectedMonthChartArr setArray:_stepsModel.movementDetails[indexPath.row]];
    _HWeekMaxData = ((NSNumber *)_stepsModel.maxMovementDetailsStep[indexPath.row]).integerValue;
    
    //刷新图表
    [_HChartView strokeChart];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _monthRecordModelArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MNHistoryDetailCell *cell = (MNHistoryDetailCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    
    cell.model = _monthRecordModelArr[indexPath.row];
    
    return cell;
}

#pragma mark - UUChartDataSource
- (NSArray *)UUChart_xLabelArray:(UUChart *)chart
{
    //X坐标标题数组
    return @[@"1",@"2",@"3",@"4",@"5",@"6",@"7"];
}

- (NSArray *)UUChart_yValueArray:(UUChart *)chart
{
    //Y坐标数值数组
    return @[self.HSelectedMonthChartArr];
}

- (NSArray *)UUChart_ColorArray:(UUChart *)chart
{
    //颜色数组
    return @[NAV_BG_COLOR];
}

- (CGRange)UUChartChooseRangeInLineChart:(UUChart *)chart
{
    //数值显示范围 最大值到最小值
    return CGRangeMake(_HWeekMaxData, 0);
}

- (BOOL)UUChart:(UUChart *)chart showHorizonLineAtIndex:(NSInteger)index
{
    //显示横线条 只有折线图才会生效
    return YES;
}

@end