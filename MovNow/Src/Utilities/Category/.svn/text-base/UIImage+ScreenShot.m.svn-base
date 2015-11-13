//
//  UIImage+ScreenShot.m
//  MinLin_LED
//
//  Created by Oliver on 15/2/2.
//  Copyright (c) 2015年 Oliver. All rights reserved.
//

#import "UIImage+ScreenShot.h"

@implementation UIImage (ScreenShot)

+ (UIImage *)getCurrentScreen
{
    UIWindow *screenWindow = [[UIApplication sharedApplication] keyWindow];
    UIGraphicsBeginImageContextWithOptions(screenWindow.bounds.size, YES, 0);
    [screenWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return screenImg;
}

@end
