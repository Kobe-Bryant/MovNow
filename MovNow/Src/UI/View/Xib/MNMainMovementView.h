//
//  MNMainMovementView.h
//  Movnow
//
//  Created by LiuX on 15/4/25.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MNCustomCircleView.h"

@interface MNMainMovementView : UIView

@property (weak, nonatomic) IBOutlet MNCustomCircleView *movementCircleView;
@property (weak, nonatomic) IBOutlet UILabel *kmLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentKmLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentCalorieLabel;

- (MNMainMovementView *)initWithXibFileAndHeight:(CGFloat)height showType:(MovementViewShowType)showType currentSelectedDate:(NSDate *)currentSelectedDate calorieClickBlock:(CoreEmptyCallBack)calorieClickBlock shareClickBlock:(CoreEmptyCallBack)shareClickBlock bottomClickBlock:(CoreEmptyCallBack)bottomClickBlock;

@end
