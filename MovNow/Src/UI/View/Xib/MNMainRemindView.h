//
//  MNMainRemindView.h
//  Movnow
//
//  Created by LiuX on 15/4/25.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MainRemindBtnClickType){
    MainRemindBtnClickTypeDrink, //喝水
    MainRemindBtnClickTypeGetUp, //起床
    MainRemindBtnClickTypeBMI, //体质指数
    MainRemindBtnClickTypeSitting //久坐
};

typedef void (^MainRemindBtnClickBlock)(MainRemindBtnClickType type);

@interface MNMainRemindView : UIView

- (MNMainRemindView *)initWithXibFileAndHeight:(CGFloat)height clickBlock:(MainRemindBtnClickBlock)clickBlock;

@end
