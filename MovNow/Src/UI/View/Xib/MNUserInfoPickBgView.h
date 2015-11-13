//
//  MNUserInfoPickBgView.h
//  Movnow
//
//  Created by LiuX on 15/4/22.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MNUserInfoPickBgView : UIView

typedef void(^BgViewDismissBlock)(UIView *currentContentView);

- (void)setContentView:(UIView *)contentView;

- (MNUserInfoPickBgView *)initWithXibFileAndDismissBlock:(BgViewDismissBlock)dismissBlock;

- (void)showInView:(UIView *)view;

@end
