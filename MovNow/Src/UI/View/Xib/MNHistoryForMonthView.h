//
//  MNHistoryForMonthView.h
//  Movnow
//
//  Created by LiuX on 15/5/12.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MNHistoryForMonthView;
@class MNMonthStepViewModel;

@protocol HistoryForMonthViewDelegate <NSObject>
@optional
-(void)historyForMonthView:(MNHistoryForMonthView *)historyForMonthView didClickButtonIndex:(NSInteger)index;
@end

@interface MNHistoryForMonthView : UIView
/**
 *  当前日期
 */
@property (nonatomic,strong) NSDate *currentDate;
/**
 *  月运动数据模型
 */
@property (nonatomic,strong) MNMonthStepViewModel *stepsModel;

@property (nonatomic,weak) id<HistoryForMonthViewDelegate> delegate;

- (MNHistoryForMonthView *)initWithXibFileAndFrame:(CGRect)frame historyDataType:(HistoryDataType)historyDataType;

@end
