//
//  UIView+ShowHUD.m
//  Movnow
//
//  Created by LiuX on 15/4/24.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//

#define LOADING_TAG 8888
#define HUD_ALPHA 0.7

#import "UIView+ShowHUD.h"
#import "MBProgressHUD.h"

@implementation UIView (ShowHUD)

- (void)showHUDWithStr:(NSString *)str
{
    [[self viewWithTag:LOADING_TAG] removeFromSuperview];
    
    MBProgressHUD *loadingHud = [[MBProgressHUD alloc] initWithView:self];
    loadingHud.color = NAV_TEXT_COLOR;
    loadingHud.alpha = HUD_ALPHA;
    loadingHud.activityIndicatorColor = [UIColor whiteColor];
    loadingHud.labelColor = [UIColor whiteColor];
    loadingHud.labelText = str;
    loadingHud.labelFont = SUBTITLE_FONT;
    loadingHud.tag = LOADING_TAG;
    [self addSubview:loadingHud];
    [loadingHud show:YES];
}

- (void)hideHUD
{
    [(MBProgressHUD *)[self viewWithTag:LOADING_TAG] hide:YES];
}

- (void)showHUDWithStr:(NSString *)str hideAfterDelay:(NSTimeInterval )timeInterval
{
    MBProgressHUD *autoHideHud = [[MBProgressHUD alloc] initWithView:self];
    autoHideHud.mode = MBProgressHUDModeText;
    autoHideHud.color = NAV_TEXT_COLOR;
    autoHideHud.alpha = HUD_ALPHA;
    autoHideHud.labelColor = [UIColor whiteColor];
    autoHideHud.labelText = str;
    autoHideHud.labelFont = SUBTITLE_FONT;
    [self addSubview:autoHideHud];
    [autoHideHud show:YES];
    [autoHideHud hide:YES afterDelay:timeInterval];
}

@end
