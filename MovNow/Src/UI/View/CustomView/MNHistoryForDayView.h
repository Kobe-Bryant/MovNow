//
//  MNHistoryForDayView.h
//  Movnow
//
//  Created by LiuX on 15/5/7.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MNHistoryForDayView;

@protocol HistoryForDayViewDelegate <NSObject>
@optional
-(void)historyForDayView:(MNHistoryForDayView *)historyForDayView didSelectedDate:(NSDate *)date;
@end

@interface MNHistoryForDayView : UIView

@property (nonatomic,strong) NSSet *calendarSet;
/**
 *  当前日期
 */
@property (nonatomic,strong) NSDate *currentDate;

@property (nonatomic,weak) id<HistoryForDayViewDelegate> delegate;

@end
