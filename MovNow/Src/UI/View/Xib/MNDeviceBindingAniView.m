//
//  MNDeviceBindingAniView.m
//  Movnow
//
//  Created by LiuX on 15/4/25.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//

//旋转速度
#define Rotation_Speed 1.0
//波纹频率
#define Halo_Frequency 0.5
//波纹速度
#define Halo_Speed 3.0
#define kRotationAnimationpath @"rotationAnimation"



#import "MNDeviceBindingAniView.h"


@interface MNDeviceBindingAniView ()

@property (weak, nonatomic) IBOutlet UIImageView *bindingBgView;
@property (weak, nonatomic) IBOutlet UIImageView *bindingCenterIconView;
@property (weak, nonatomic) IBOutlet UIImageView *bindingHaloView;
@property (weak, nonatomic) IBOutlet UIImageView *bindingHaloBgView;

@property (nonatomic,strong) NSTimer *bindingAniTimer;
@property (nonatomic,copy) CoreSuccess clickBlock;

@end

@implementation MNDeviceBindingAniView

- (BOOL)isAnimationing
{
    return (_bindingAniTimer.isValid == YES)?YES:NO;
}

- (MNDeviceBindingAniView *)initWithXibFileWithClickBlock:(CoreSuccess)clickBlock
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"MNDeviceBindingAniView" owner:self options:nil] firstObject];
    
    if (self) {
        self.frame = CGRectMake(0, 50, SCREEN_WIDTH, 300);
        
        self.bindingBgView.image = [UIImage imageNamed:IMAGE_NAME(@"binding_bg")];
        self.bindingCenterIconView.image = [UIImage imageNamed:IMAGE_NAME(@"binding_blueTooth_icon")];
        self.bindingHaloView.image = [UIImage imageNamed:IMAGE_NAME(@"binding_ halo")];
        self.bindingHaloBgView.image = [UIImage imageNamed:IMAGE_NAME(@"binding_ halo_bg")];
        
        self.clickBlock = [clickBlock copy];
    }
    
    return self;
}

- (IBAction)clickToBgView:(UITapGestureRecognizer *)sender
{
    if (self.isAnimationing == YES) return;
    
    if (self.clickBlock) {
        self.clickBlock(self);
    }
}

- (void)startAnimation
{
    self.bindingCenterIconView.image = [UIImage imageNamed:IMAGE_NAME(@"binding_blueTooth_icon")];
    
    CAAnimation* animation = (CAAnimation*)[self.bindingHaloView.layer animationForKey:kRotationAnimationpath];
    if (animation) {
        [self.bindingHaloView.layer removeAnimationForKey:kRotationAnimationpath];
    }
    //转圈动画
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: - M_PI];
    rotationAnimation.duration = Rotation_Speed;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = INT_MAX;
    [self.bindingHaloView.layer addAnimation:rotationAnimation forKey:kRotationAnimationpath];
    
    _bindingAniTimer = [NSTimer scheduledTimerWithTimeInterval:Halo_Frequency target:self selector:@selector(executeTimer) userInfo:nil repeats:YES];
    //添加监听
    [self addRotationAnimationObseral];
    
    
}

#pragma mark Pravite Method
- (void)addRotationAnimationObseral
{
    NSNotificationCenter* notify = [NSNotificationCenter defaultCenter];
   [notify addObserver:self  selector:@selector(executeTimer) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)executeTimer
{
    __block UIImageView *fadeOutHaloView = [[UIImageView alloc]initWithFrame:CGRectMake(X(self.bindingHaloBgView)  , Y(self.bindingHaloBgView), WIDTH(self.bindingHaloBgView), HEIGHT(self.bindingHaloBgView))];
    fadeOutHaloView.image = [UIImage imageNamed:IMAGE_NAME(@"binding_ halo_bg")];
    fadeOutHaloView.backgroundColor = [UIColor clearColor];
    [self addSubview:fadeOutHaloView];
    
    [UIView animateWithDuration:Halo_Speed animations:^{
        fadeOutHaloView.frame = self.bounds;
        fadeOutHaloView.alpha = 0;
    }completion:^(BOOL finished) {
        [fadeOutHaloView removeFromSuperview];
        fadeOutHaloView = nil;
    }];
}

- (void)stop
{
    self.bindingCenterIconView.image = [UIImage imageNamed:IMAGE_NAME(@"binding_error")];
    
    [self.bindingHaloView.layer removeAllAnimations];
    [_bindingAniTimer invalidate];
    _bindingAniTimer = nil;
}

@end
