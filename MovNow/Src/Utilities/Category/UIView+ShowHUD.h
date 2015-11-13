//
//  UIView+ShowHUD.h
//  Movnow
//
//  Created by LiuX on 15/4/24.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ShowHUD)

/**
 *  显示正在加载的样式(转圈圈)
 *
 *  @param str 自定义文字
 */
- (void)showHUDWithStr:(NSString *)str;

/**
 *  隐藏正在加载的样式
 */
- (void)hideHUD;

/**
 *  显示文字 之后自动消失
 *
 *  @param str  自定义文字
 *  @param timeInterval 显示时间
 */
- (void)showHUDWithStr:(NSString *)str hideAfterDelay:(NSTimeInterval )timeInterval;

@end
