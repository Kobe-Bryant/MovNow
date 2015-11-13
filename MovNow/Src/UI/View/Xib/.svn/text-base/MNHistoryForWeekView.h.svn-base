//
//  MNHistoryForWeekView.h
//  Movnow
//
//  Created by LiuX on 15/5/12.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MNHistoryForWeekView;
@class MNWeekStepViewModel;

@protocol HistoryForWeekViewDelegate <NSObject>
@optional
-(void)historyForWeekView:(MNHistoryForWeekView *)historyForWeekView didClickButtonIndex:(NSInteger)index;
@end

@interface MNHistoryForWeekView : UIView

/**
 *  当前日期
 */
@property (nonatomic,strong) NSDate *currentDate;
/**
 *  周运动数据模型
 */
@property (nonatomic,strong) MNWeekStepViewModel *stepsModel;

@property (nonatomic,weak) id<HistoryForWeekViewDelegate> delegate;

- (MNHistoryForWeekView *)initWithXibFileAndFrame:(CGRect)frame historyDataType:(HistoryDataType)historyDataType;

@end
