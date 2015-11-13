//
//  MNCameraSettingView.h
//  Movnow
//
//  Created by LiuX on 15/4/28.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^CameraCountBlock)(NSInteger count);
typedef void (^CameraIntervalBlock)(NSInteger interval);

@interface MNCameraSettingView : UIView

- (MNCameraSettingView *)initWithXibFileAndFrame:(CGRect)frame countBlock:(CameraCountBlock)countBlock intervalBlock:(CameraIntervalBlock)intervalBlock;

@end
