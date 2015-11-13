//
//  MNDeviceBindingAniView.h
//  Movnow
//
//  Created by LiuX on 15/4/25.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MNDeviceBindingAniView : UIView

//当前是否在执行动画
@property (nonatomic,assign,readonly) BOOL isAnimationing;

- (MNDeviceBindingAniView *)initWithXibFileWithClickBlock:(CoreSuccess)clickBlock;

- (void)startAnimation;

- (void)stop;

@end
