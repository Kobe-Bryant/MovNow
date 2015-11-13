//
//  MNCalendarView.m
//  Movnow
//
//  Created by LiuX on 15/5/7.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//

#import "MNHistoryForDayView.h"
#import "MNLanguageService.h"
#import "NSDate+Expend.h"

@interface MNHistoryForDayView ()

@property (nonatomic,strong) NSArray *weekNameArr;

@property (nonatomic,strong) NSCalendar *gregorianCalendar;

@property (nonatomic,assign) NSInteger currentYear;
@property (nonatomic,assign) NSInteger currentMonth;
@property (nonatomic,assign) NSInteger currentDay;

@end

@implementation MNHistoryForDayView

- (NSArray *)weekNameArr
{
    if (_weekNameArr == nil) {
        _weekNameArr =  @[NSLocalizedString(@"周日",nil),
                                                NSLocalizedString(@"周一",nil),
                                                NSLocalizedString(@"周二",nil),
                                                NSLocalizedString(@"周三",nil),
                                                NSLocalizedString(@"周四",nil),
                                                NSLocalizedString(@"周五",nil),
                                                NSLocalizedString(@"周六",nil)];
    }
    return _weekNameArr;
}

- (NSCalendar *)gregorianCalendar
{
    if (_gregorianCalendar == nil) {
        _gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        
        NSDateComponents *components = [_gregorianCalendar components:(NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:self.currentDate];
        
        _currentYear = components.year;
        _currentMonth = components.month;
        _currentDay  = components.day;
    }
    return _gregorianCalendar;
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]){
        
        self.backgroundColor = [UIColor clearColor];
        
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

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    //布局相关
    NSInteger columns = 7;
    NSInteger sizeW = 44;
    NSInteger sizeH = sizeW;
    NSInteger originX = 7;
    NSInteger originY = 70;
    
    //取出一个月中的第一天的日期
    NSDateComponents *firstDayOfMonthComponents = [self.gregorianCalendar components:(NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:self.currentDate];
    firstDayOfMonthComponents.day = 1;
    
    //上个月的dateComponents
    NSDateComponents *previousMonthComponents = [self.gregorianCalendar components:(NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:self.currentDate];
    previousMonthComponents.month -=1;
    
    //上个月的天数
    NSInteger lastMonthDays = [[self.gregorianCalendar components:NSWeekdayCalendarUnit fromDate:[self.gregorianCalendar dateFromComponents:firstDayOfMonthComponents]] weekday];
    lastMonthDays -= 1;
    if(lastMonthDays < 0) lastMonthDays += 7;
    
    //当前月的天数
    NSInteger currentMonthDays = [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit
                                                                    inUnit:NSMonthCalendarUnit
                                                                   forDate:self.currentDate].length;
    
    //下个月的天数
    NSInteger nextMonthDays = (currentMonthDays + lastMonthDays) % columns;
    
    //标题标签
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WIDTH(self), 40)];
    [titleLabel setText:[[NSDate getStringWithFormat:([[MNLanguageService shareInstance] getCurrentLanguage] == CurrentLanguageTypeChineseSimple || [[MNLanguageService shareInstance] getCurrentLanguage] == CurrentLanguageTypeChineseTraditional)?@"<yyyy / MM>":@"<MM / yyyy>" andDate:self.currentDate] uppercaseString]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:[UIFont systemFontOfSize:20]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [self addSubview:titleLabel];
    
    //日历中的星期日到星期六标签(固定不变)
    for (NSInteger i = 0; i < self.weekNameArr.count; i ++) {
        
        UILabel *weekNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(originX + (sizeW * (i%columns)) + 7.5, originY - 45, sizeW, sizeH)];
        [weekNameLabel setText:[self.weekNameArr objectAtIndex:i]];
        [weekNameLabel setTextColor:[UIColor whiteColor]];
        [weekNameLabel setFont:[UIFont systemFontOfSize:13]];
        [self addSubview:weekNameLabel];
    }
    
    //当月的天数按钮
    for (NSInteger i = 0; i < currentMonthDays; i ++){
        
        UIButton *monthDayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        monthDayBtn.tag = i + 1;
        
        [monthDayBtn setFrame:CGRectMake(originX + (sizeW * ((i + lastMonthDays) % columns)), originY + (sizeH * ((i + lastMonthDays) / columns)), sizeW, sizeH)];
        [monthDayBtn setTitle:[NSString stringWithFormat:@"%ld",i + 1] forState:UIControlStateNormal];
        [monthDayBtn.titleLabel setFont:[UIFont fontWithName:@"Noteworthy" size:14]];
        [monthDayBtn addTarget:self action:@selector(monthDayBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        //默认的颜色
        [monthDayBtn setTitleColor:[UIColor colorWith8BitRed:101 green:145 blue:182] forState:UIControlStateNormal];
        
        //有数据的日期按钮颜色设的深一点 并且有数据的日期按钮设置为透明
        if ([_calendarSet containsObject:[NSString stringWithFormat:@"%ld%02ld%02ld", firstDayOfMonthComponents.year, firstDayOfMonthComponents.month, i + 1]]) {
            
            [monthDayBtn setTitleColor:NAV_TEXT_COLOR forState:UIControlStateNormal];
            [monthDayBtn setBackgroundImage:[UIImage imageNamed:IMAGE_NAME(@"calendar_currentDay_press")] forState:UIControlStateHighlighted];
        }else{
            monthDayBtn.alpha = 0.5;
        }
        
        //当天天的那个日期按钮设置背景图片
        if (i + 1 == _currentDay&&firstDayOfMonthComponents.month == _currentMonth&&firstDayOfMonthComponents.year == _currentYear){
            
            monthDayBtn.alpha = 1.0;
            [monthDayBtn setTitleColor:NAV_TEXT_COLOR forState:UIControlStateNormal];
            [monthDayBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            
            [monthDayBtn setBackgroundImage:[UIImage imageNamed:IMAGE_NAME(@"calendar_currentDay")] forState:UIControlStateNormal];
            [monthDayBtn setBackgroundImage:[UIImage imageNamed:IMAGE_NAME(@"calendar_currentDay_press")] forState:UIControlStateHighlighted];
        }
        
        [self addSubview:monthDayBtn];
    }
    
    //上个月的天数按钮
    for (NSInteger i = 0; i < lastMonthDays; i ++) {
        
        UILabel *lastMonthDayLabel = [[UILabel alloc]initWithFrame:CGRectMake(originX + (sizeW * (i%columns)) + 13, originY + (sizeH * (i/columns)), sizeW, sizeH)];
        [lastMonthDayLabel setText:[NSString stringWithFormat:@"%ld",[[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:[self.gregorianCalendar dateFromComponents:previousMonthComponents]].length - lastMonthDays + i + 1]];
        [lastMonthDayLabel setTextColor:[UIColor lightGrayColor]];
        [lastMonthDayLabel setFont:[UIFont fontWithName:@"Noteworthy" size:14]];
        [self addSubview:lastMonthDayLabel];
    }
    
    //下个月的天数按钮
    if(nextMonthDays >0){
        for (NSInteger i = nextMonthDays; i < columns; i ++) {
            
            UILabel *remainDaysLabel = [[UILabel alloc]initWithFrame:CGRectMake(originX + (sizeW * (i %columns)) + 18, originY + (sizeH * ((currentMonthDays + lastMonthDays) / columns)), sizeW, sizeH)];
            [remainDaysLabel setText:[NSString stringWithFormat:@"%ld",(i + 1) - nextMonthDays]];
            [remainDaysLabel setTextColor:[UIColor lightGrayColor]];
            [remainDaysLabel setFont:[UIFont fontWithName:@"Noteworthy" size:14]];
            [self addSubview:remainDaysLabel];
        }
    }
}

#pragma mark - 日期按钮点击事件
-(void)monthDayBtnClick:(UIButton *)btn
{
    NSDateComponents *components = [self.gregorianCalendar components:(NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:self.currentDate];
    components.day = btn.tag;
    
    if ([self.delegate respondsToSelector:@selector(historyForDayView:didSelectedDate:)]) {
        [self.delegate historyForDayView:self didSelectedDate:[self.gregorianCalendar dateFromComponents:components]];
    }
}

#pragma mark - 左右滑动事件
-(void)leftSwipe:(UISwipeGestureRecognizer*)leftSwipe
{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    NSDateComponents *nextMonthComponents = [self.gregorianCalendar components:(NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:self.currentDate];
    
    nextMonthComponents.day = 1;
    nextMonthComponents.month += 1;
    
    self.currentDate = [self.gregorianCalendar dateFromComponents:nextMonthComponents];
    
    [UIView transitionWithView:self
                      duration:0.5
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    animations:^{
                        [self setNeedsDisplay];
                    }completion:nil];
}

-(void)rightSwipe:(UISwipeGestureRecognizer*)rightSwipe
{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSDateComponents *lastMonthComponents = [self.gregorianCalendar components:(NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:self.currentDate];
    
    lastMonthComponents.day = 1;
    lastMonthComponents.month -= 1;
    
    self.currentDate = [self.gregorianCalendar dateFromComponents:lastMonthComponents];
    
    [UIView transitionWithView:self
                      duration:0.5
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                        [self setNeedsDisplay];
                    }completion:nil];
}

@end