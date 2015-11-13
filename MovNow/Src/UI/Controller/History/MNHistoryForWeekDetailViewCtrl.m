//
//  MNHistoryForWeekDetailViewCtrl.m
//  Movnow
//
//  Created by LiuX on 15/5/13.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//

#import "MNHistoryForWeekDetailViewCtrl.h"
#import "MNHistoryDetailCell.h"
#import "MNHistoryDetailModel.h"
#import "MNWeekStepViewModel.h"

#define CELL_IDENTIFIER @"MNHistoryDetailCell"

@interface MNHistoryForWeekDetailViewCtrl ()<UUChartDataSource>

/**
 *  图表背景视图
 */
@property (weak, nonatomic) IBOutlet UIView *HChartBgView;
/**
 *  图表
 */
@property (nonatomic,strong) UUChart *HChartView;
/**
 *  周历史数据CollectionView
 */
@property (weak, nonatomic) IBOutlet UICollectionView *HDayOfWeekCollectionView;
/**
 *  当前选中的日数组
 */
@property (nonatomic,strong) NSMutableArray *HSelectedDayChartArr;
/**
 *  日数组最大值
 */
@property (nonatomic,assign) NSInteger HDayMaxData;

@end

@implementation MNHistoryForWeekDetailViewCtrl

- (NSMutableArray *)HSelectedDayChartArr
{
    if (_HSelectedDayChartArr == nil) {
        _HSelectedDayChartArr = [NSMutableArray array];
    }
    return _HSelectedDayChartArr;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setChartView];
    
    [self executeDefaultSetting];
}

- (void)setWeekRecordModelArr:(NSMutableArray *)weekRecordModelArr
{
    _weekRecordModelArr = weekRecordModelArr;
}

#pragma mark - 设置图表
- (void)setChartView
{
    _HChartView = [[UUChart alloc]initWithUUChartDataFrame:self.HChartBgView.bounds withSource:self withStyle:UUChartLineStyle];
    _HChartView.backgroundColor = [UIColor clearColor];
    [_HChartView showInView:self.HChartBgView];
}

#pragma mark - 默认配置
- (void)executeDefaultSetting
{
    [self.HDayOfWeekCollectionView registerNib:[UINib nibWithNibName:CELL_IDENTIFIER bundle:nil] forCellWithReuseIdentifier:CELL_IDENTIFIER];
    [self.HDayOfWeekCollectionView reloadData];
    
    //默认选中第一个
    if (self.weekRecordModelArr.count > 0) {
        [self.HDayOfWeekCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    }
}

#pragma mark - UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.HSelectedDayChartArr setArray:_stepsModel.movementDetails[indexPath.row]];
    _HDayMaxData = ((NSNumber *)_stepsModel.maxMovementDetailsStep[indexPath.row]).integerValue;
    
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
    return _weekRecordModelArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MNHistoryDetailCell *cell = (MNHistoryDetailCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    
    cell.model = _weekRecordModelArr[indexPath.row];
    
    return cell;
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
    return @[self.HSelectedDayChartArr];
}

- (NSArray *)UUChart_ColorArray:(UUChart *)chart
{
    //颜色数组
    return @[NAV_BG_COLOR];
}

- (CGRange)UUChartChooseRangeInLineChart:(UUChart *)chart
{
    //数值显示范围 最大值到最小值
    return CGRangeMake(_HDayMaxData, 0);
}

- (BOOL)UUChart:(UUChart *)chart showHorizonLineAtIndex:(NSInteger)index
{
    //显示横线条 只有折线图才会生效
    return YES;
}

@end