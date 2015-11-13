//
//  JSCameraOperationManager.h
//  cameratest
//
//  Created by Json on 14-10-17.
//  Copyright (c) 2014年 Jsonmess. All rights reserved.
//

//摄像头
enum KCameraChose
{
    KCameraFont=0,//副
    KCameraBack//主
};
//相机状态
enum KCameraSate
{
    KCameraSateNormal=0,//相机正常
    KCameraSateDisable//相机不可用
};
//闪光灯
enum KFlashLightState
{
    KFlashLightOff=0,//关闭
    KFlashLightOpen,//开启
    KFlashLightAuto,//自动
    KNoFlashLight//不可用
};

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol JSCameraControllerDelegate <NSObject>
@optional
- (void)didFinishPickPhotoImage:(UIImage *)image;//取景完成
@end

@interface JSCameraOperationManager : NSObject
@property(nonatomic,assign)enum KFlashLightState FlashLightState;
@property(nonatomic,assign)enum KCameraSate CameraSate;
@property(nonatomic,assign)enum KCameraChose CameraChose;
@property(nonatomic,strong)id<JSCameraControllerDelegate>CameraDelegate;//代理

//初始化camera
-(void)initializeCameraWithPreview:(UIImageView *)preview;
//设置闪光灯
-(void)setFlashLightState:(enum KFlashLightState)FlashLightState;
//初始化AVCaptureSession
-(void)SetCaptureSessionWithCamera:(enum KCameraChose)chose;
//捕捉图片
- (void)CaptureImage;
//保存到相册
-(void)SavePictureToLibraryWithImage:(UIImage *)image;
//停止
- (void)StopCaptureImage;

@end
