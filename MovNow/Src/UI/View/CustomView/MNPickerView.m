//
//  MNPickerView.m
//  Q2
//
//  Created by hebing on 14-9-18.
//  Copyright (c) 2014年 hebing. All rights reserved.
//

#import "MNPickerView.h"

#define PICKERBEGINSCROLL @"pickerBeginScroll"
#define PICKERENDSCROLL @"pickerEndScroll"

@interface MNPickerScrollView ()

@property (nonatomic, strong) NSArray *arrValues;

@end

@implementation MNPickerScrollView

- (id)initWithFrame:(CGRect)frame andValues:(NSArray *)arrayValues {
    
    if(self = [super initWithFrame:frame]) {
        [self setScrollEnabled:YES];
        [self setShowsVerticalScrollIndicator:NO];
        [self setUserInteractionEnabled:YES];
        [self setBackgroundColor:[UIColor whiteColor]];
        [self setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self setContentInset:UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)];
        
        if(arrayValues)
            _arrValues = [arrayValues copy];
        self.backgroundColor =  CTRL_BG_COLOR;
    }
    return self;
}

//取消高亮
- (void)dehighlightLastCell {
    NSArray *paths = [NSArray arrayWithObjects:[NSIndexPath indexPathForRow:_tagLastSelected inSection:0], nil];
    [self setTagLastSelected:-1];
    [self beginUpdates];
    [self reloadRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationNone];
    [self endUpdates];
}

//设置高亮
- (void)highlightCellWithIndexPathRow:(NSUInteger)indexPathRow {
    [self setTagLastSelected:indexPathRow];
    NSArray *paths = [NSArray arrayWithObjects:[NSIndexPath indexPathForRow:_tagLastSelected inSection:0], nil];
    [self beginUpdates];
    [self reloadRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationNone];
    [self endUpdates];
}

@end

@interface MNPickerView ()

@property (nonatomic, strong) NSArray *timerArr;
@property (nonatomic, strong) MNPickerScrollView *svView;


@end

@implementation MNPickerView

- (id)initWithFrame:(CGRect)frame andDataArr:(NSArray *)dateArr
{
    self = [super initWithFrame:frame];
    if (self) {
        if (dateArr) {
            NSMutableArray *arr = [[NSMutableArray alloc] init];
            [arr addObject:dateArr[dateArr.count-2]];
            [arr addObject:dateArr[dateArr.count-1]];
            [arr addObjectsFromArray:dateArr];
            [arr addObject:dateArr[0]];
            [arr addObject:dateArr[1]];
            [arr addObject:dateArr[2]];
            
            if (frame.size.height >= 280) {
                [arr insertObject:dateArr[dateArr.count-3] atIndex:0];
                [arr addObject:dateArr[3]];
            }
            _timerArr = arr;
        }
        self.backgroundColor =  CTRL_BG_COLOR;
        [self creatUI];
        
    }
    return self;
}


- (void)creatUI{
    //创建选中高亮边框
    UIImageView *barSel2 = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width-100)/2.0, (self.frame.size.height-40)/2.0, 100, 40)];
    UIImage *image = [UIImage imageNamed:IMAGE_NAME(@"pop_currentChoose")];
    image = [image stretchableImageWithLeftCapWidth:20 topCapHeight:20];
    barSel2.image = image;    

    //创建选择器的数据表
    _svView = [[MNPickerScrollView alloc] initWithFrame:self.bounds andValues:_timerArr];
    _svView.dataSource = self;
    _svView.delegate = self;
    [self addSubview:_svView];
    
    //创建渐变效果层
    CAGradientLayer *gradientLayerTop = [CAGradientLayer layer];
    gradientLayerTop.frame = CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height/2.0);
    gradientLayerTop.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithWhite:1.0 alpha:0.0].CGColor, (id)[UIColor whiteColor].CGColor, nil];//colorWithRed:235.0/255 green:235.0/255 blue:235.0/255 alpha:1.0
    gradientLayerTop.startPoint = CGPointMake(0.0f, 0.7f);
    gradientLayerTop.endPoint = CGPointMake(0.0f, 0.0f);
    
    CAGradientLayer *gradientLayerBottom = [CAGradientLayer layer];
    gradientLayerBottom.frame = CGRectMake(0.0, self.frame.size.height/2.0, self.frame.size.width, self.frame.size.height/2.0);
    gradientLayerBottom.colors = gradientLayerTop.colors;
    gradientLayerBottom.startPoint = CGPointMake(0.0f, 0.3f);
    gradientLayerBottom.endPoint = CGPointMake(0.0f, 1.0f);
    
    [self.layer addSublayer:gradientLayerTop];
    [self.layer addSublayer:gradientLayerBottom];
    
    [self addSubview:barSel2];
    [self setTime:@"20"];
}

- (void)setTime:(NSString *)time {
    NSInteger index = [time integerValue];
    [_svView dehighlightLastCell];
    [self centerCellWithIndexPathRow:index forScrollView:_svView];
}


- (void)setValue:(NSString *)value{
    _value = value;
    [self setTime:value];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (![scrollView isDragging]) {
        [self centerValueForScrollView:(MNPickerScrollView *)scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self centerValueForScrollView:(MNPickerScrollView *)scrollView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [[NSNotificationCenter defaultCenter] postNotificationName:PICKERBEGINSCROLL object:nil];
    MNPickerScrollView *sv = (MNPickerScrollView *)scrollView;
    [sv dehighlightLastCell];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int count = scrollView.frame.size.height/40;
    if (_svView.contentOffset.y > (_timerArr.count-count)*40){
        _svView.contentOffset = CGPointMake(0, 0);
    } else if (_svView.contentOffset.y < 0){
        _svView.contentOffset = CGPointMake(0, (_timerArr.count-count)*40);
    }
}

- (void)centerValueForScrollView:(MNPickerScrollView *)scrollView {
    [[NSNotificationCenter defaultCenter] postNotificationName:PICKERENDSCROLL object:nil];
    float offset = scrollView.contentOffset.y;
    
    int mod = (int)offset%(int)40;
    
    float newValue = (mod >= 20.0) ? offset+(40-mod) : offset-mod;
    NSInteger indexPathRow = (int)(newValue/40);
    
    [self centerCellWithIndexPathRow:indexPathRow forScrollView:scrollView];
}

- (void)centerCellWithIndexPathRow:(NSUInteger)indexPathRow forScrollView:(MNPickerScrollView *)scrollView {
    
    if(indexPathRow >= [scrollView.arrValues count]) {
        indexPathRow = [scrollView.arrValues count]-3;
    }
    float newOffset = indexPathRow*40.0;
    newOffset = newOffset;
    
//    [CATransaction begin];
    
//    [CATransaction setCompletionBlock:^{
    
    NSUInteger index = indexPathRow+(scrollView.frame.size.height/80);
    
        [scrollView highlightCellWithIndexPathRow:index];
        _value = _timerArr[index];
        
//        [scrollView setUserInteractionEnabled:YES];
//        [scrollView setAlpha:1.0];
//    }];
    
    [scrollView setContentOffset:CGPointMake(0.0, newOffset) animated:YES];
//    [CATransaction commit];
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    MNPickerScrollView *sv = (MNPickerScrollView *)tableView;
    return [sv.arrValues count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *identifier = @"reusableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    MNPickerScrollView *sv = (MNPickerScrollView *)tableView;
    
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [cell setBackgroundColor:[UIColor clearColor]];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    NSInteger i = labs(indexPath.row - sv.tagLastSelected);
    if (i == 0){
        cell.textLabel.font = [UIFont systemFontOfSize:24.0];
        cell.textLabel.textColor = [UIColor orangeColor];
    }else {
        cell.textLabel.font = [UIFont systemFontOfSize:20];
        cell.textLabel.textColor = [UIColor darkGrayColor];
    }
    
    [cell.textLabel setText:sv.arrValues[indexPath.row]];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

@end
