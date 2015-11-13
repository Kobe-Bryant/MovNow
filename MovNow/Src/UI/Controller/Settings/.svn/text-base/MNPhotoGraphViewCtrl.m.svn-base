//
//  MNPhotoGraphViewCtrl.m
//  Movnow
//
//  Created by LiuX on 15/4/28.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//

#import "MNPhotoGraphViewCtrl.h"
#import "JSCameraOperationManager.h"
#import "MNBleBaseService.h"
#import "MNCameraSettingView.h"

@interface MNPhotoGraphViewCtrl ()<JSCameraControllerDelegate,MNBleBaseServicePhotoMessageDelegate>

/**
 *  底部工具条背景视图
 */
@property (weak, nonatomic) IBOutlet UIImageView *PBgImageView;
/**
 *  取消照相按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *PCancelBtn;
/**
 *  取景视图
 */
@property (weak, nonatomic) IBOutlet UIImageView *PSceneImageView;
/**
 *  切换主次摄像头按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *PChangeCameraBtn;
/**
 *  摄像按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *PTakePhotoBtn;
/**
 *  设置按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *PSettingBtn;
/**
 *  提醒标签
 */
@property (weak, nonatomic) IBOutlet UILabel *PAlertWordsLabel;
/**
 *  相机界面逻辑处理者
 */
@property (nonatomic,strong) JSCameraOperationManager *PCameraManager;
/**
 *  相机设置视图
 */
@property (nonatomic,strong) MNCameraSettingView *PSettingView;
/**
 *  拍照效果覆盖视图
 */
@property (nonatomic,strong) UIView *PCoverView;
/**
 *  当前选择的连拍次数
 */
@property (nonatomic,assign) NSInteger PCurrentCount;
/**
 *  当前选择的连拍间隔
 */
@property (nonatomic,assign) NSInteger PCurrentInterval;
/**
 *  当前已连拍的次数
 */
@property (nonatomic,assign) NSInteger PCurrentPhotoGraphCount;
/**
 *  等待超时定时器
 */
@property (nonatomic,strong) NSTimer *PTimeOutTimer;
/**
 *  连拍定时器
 */
@property (nonatomic,strong) NSTimer *PContinuousTimer;
/**
 *  定时拍摄是否处于锁定状态
 */
@property (nonatomic,assign) BOOL PTimerIsLock;

@end

@implementation MNPhotoGraphViewCtrl

- (JSCameraOperationManager *)PCameraManager
{
    if (_PCameraManager == nil) {
        _PCameraManager=[[JSCameraOperationManager alloc]init];
        _PCameraManager.CameraDelegate = self;
    }
    return _PCameraManager;
}

- (MNCameraSettingView *)PSettingView
{
    if (_PSettingView == nil) {
        _PSettingView = [[MNCameraSettingView alloc]initWithXibFileAndFrame:CGRectMake(- SCREEN_WIDTH, SCREEN_HEIGHT/2 - 30, SCREEN_WIDTH, 180) countBlock:^(NSInteger count) {
            _PCurrentCount = count;
        } intervalBlock:^(NSInteger interval) {
            _PCurrentInterval = interval;
        }];
    }
    return _PSettingView;
}

- (UIView *)PCoverView
{
    if (_PCoverView == nil) {
        _PCoverView = [[UIView alloc]initWithFrame:self.view.bounds];
        _PCoverView.backgroundColor = [UIColor clearColor];
    }
    return _PCoverView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loaclOperation];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self resetImages];
    
    [self executeDefaultSetting];
    
    [self sendBlueToothRequest];
}

#pragma mark - 重设图片
- (void)resetImages
{
    [self.PBgImageView setImage:[UIImage imageNamed:IMAGE_NAME(@"camera_bg_view")]];
    [self.PCancelBtn setImage:[UIImage imageNamed:IMAGE_NAME(@"camera_cancel_btn")] forState:UIControlStateNormal];
    [self.PChangeCameraBtn setImage:[UIImage imageNamed:IMAGE_NAME(@"camera_change_btn")] forState:UIControlStateNormal];
    [self.PChangeCameraBtn setImage:[UIImage imageNamed:IMAGE_NAME(@"camera_change_btn_press")] forState:UIControlStateSelected];
    [self.PTakePhotoBtn setImage:[UIImage imageNamed:IMAGE_NAME(@"camera_takePhoto_btn")] forState:UIControlStateNormal];
    [self.PTakePhotoBtn setImage:[UIImage imageNamed:IMAGE_NAME(@"camera_takePhoto_btn_press")] forState:UIControlStateHighlighted];
    [self.PSettingBtn setImage:[UIImage imageNamed:IMAGE_NAME(@"camera_setting_btn")] forState:UIControlStateNormal];
    [self.PSettingBtn setImage:[UIImage imageNamed:IMAGE_NAME(@"camera_setting_btn_press")] forState:UIControlStateSelected];
}

#pragma mark - 默认配置
- (void)executeDefaultSetting
{
    //设置拍照代理
    [MNBleBaseService shareInstance].photoMessageDelegate = self;
    
    //初始化照相机
    [self.PCameraManager initializeCameraWithPreview:self.PSceneImageView];
    
    //添加设置视图
    [self.view addSubview:self.PSettingView];
    
    //60秒内若没有进行任何操作 则提示超时
    _PTimeOutTimer = [NSTimer scheduledTimerWithTimeInterval:60.f target:self selector:@selector(waitingForTimeOut) userInfo:nil repeats:NO];
    
    _PCurrentCount = 0;
    _PCurrentInterval = 0;
    _PCurrentPhotoGraphCount = 0;
    _PTimerIsLock = NO;
}

#pragma mark - 发出蓝牙请求
- (void)sendBlueToothRequest
{
    [[MNBleBaseService shareInstance] keyLockWithLock:YES withSuccess:^(id result) {
    } withFailure:^(id reason) {
    }];
}

#pragma mark - 本地化操作
- (void)loaclOperation
{
    self.PAlertWordsLabel.text = NSLocalizedString(@"请按击设备一下,假装打电话,别被发现", nil);
}

#pragma mark - 超时情况的回调
- (void)waitingForTimeOut
{
    self.PAlertWordsLabel.text = NSLocalizedString(@"操作超时", nil);
}

#pragma mark - 取消照相按钮点击事件
- (IBAction)cancelBtnClick:(UIButton *)sender
{
    [_PTimeOutTimer invalidate];
    _PTimeOutTimer = nil;
    
    [_PContinuousTimer invalidate];
    _PContinuousTimer = nil;
    
    [[MNBleBaseService shareInstance] keyLockWithLock:NO withSuccess:^(id result) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } withFailure:^(id reason) {
    }];
}

#pragma mark - 切换主次摄像头按钮点击事件
- (IBAction)changeCameraBtnClick:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected == YES) {
        self.PCameraManager.CameraChose = KCameraFont;
    }else{
        self.PCameraManager.CameraChose = KCameraBack;
    }
    
    [self.PCameraManager StopCaptureImage];
    [self.PCameraManager SetCaptureSessionWithCamera:self.PCameraManager.CameraChose];
}

#pragma mark - 摄像按钮点击事件
- (IBAction)takePhotoBtnClick:(UIButton *)sender
{
    if (_PTimerIsLock == YES) return;
    
    [_PTimeOutTimer invalidate];
    _PTimeOutTimer = nil;
    _PTimeOutTimer = [NSTimer scheduledTimerWithTimeInterval:5.f target:self selector:@selector(waitingForTimeOut) userInfo:nil repeats:NO];
    
    //隐藏设置视图
    if (self.PSettingBtn.selected == YES) [self settingBtnClick:self.PSettingBtn];
    
    //判断是否需要执行连拍
    if (_PCurrentCount != 0&&_PCurrentInterval != 0) {
        _PTimerIsLock = YES;
        _PCurrentPhotoGraphCount = 0;
        _PContinuousTimer = [NSTimer scheduledTimerWithTimeInterval:_PCurrentInterval target:self selector:@selector(continuousTakePhoto) userInfo:nil repeats:YES];
    }else{
        [self.PCameraManager CaptureImage];
    }
}

#pragma mark 执行连拍
- (void)continuousTakePhoto
{
    if (_PCurrentPhotoGraphCount == _PCurrentCount) {
        _PTimerIsLock = NO;
        [_PContinuousTimer invalidate];
        _PContinuousTimer = nil;
        return;
    }
    
    [self.PCameraManager CaptureImage];
    
    _PCurrentPhotoGraphCount ++;
}

#pragma mark - 取景视图点击事件
- (IBAction)clickToSceneImageView:(UITapGestureRecognizer *)sender
{
    //隐藏设置视图
    if (self.PSettingBtn.selected == YES) [self settingBtnClick:self.PSettingBtn];
}

#pragma mark - 设置按钮点击事件
- (IBAction)settingBtnClick:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    if (sender.selected == YES) {
        [UIView animateWithDuration:kAnimationInterval animations:^{
            CGRect tempRect = self.PSettingView.frame;
            tempRect.origin.x = 0;
            self.PSettingView.frame = tempRect;
        }];
    }else{
        [UIView animateWithDuration:kAnimationInterval animations:^{
            CGRect tempRect = self.PSettingView.frame;
            tempRect.origin.x = - SCREEN_WIDTH;
            self.PSettingView.frame = tempRect;
        }];
    }
}

#pragma mark - JSCameraControllerDelegate
- (void)didFinishPickPhotoImage:(UIImage *)image
{
    [self.view addSubview:self.PCoverView];
    
    [UIView animateWithDuration:0.3f animations:^{
        self.PCoverView.backgroundColor = [UIColor whiteColor];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3f animations:^{
            self.PCoverView.backgroundColor = [UIColor clearColor];
        }completion:^(BOOL finished) {
            [self.PCoverView removeFromSuperview];
        }];
    }];
}

#pragma mark - MNBleBaseServicePhotoMessageDelegate
- (void)recevicePhotoMessage
{
    [self takePhotoBtnClick:self.PTakePhotoBtn];
}

@end
