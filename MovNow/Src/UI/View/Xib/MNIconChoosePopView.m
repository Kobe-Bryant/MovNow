//
//  MNIconChoosePopView.m
//  Movnow
//
//  Created by LiuX on 15/4/17.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//

#import "MNIconChoosePopView.h"

@interface MNIconChoosePopView ()

@property (weak, nonatomic) IBOutlet UIButton *ICameraBtn;
@property (weak, nonatomic) IBOutlet UIButton *IPhotoAlbumBtn;
@property (weak, nonatomic) IBOutlet UIButton *ICancelBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSpace;
@property (nonatomic,assign) BOOL isShowed;

@end

@implementation MNIconChoosePopView

- (MNIconChoosePopView *)initWithXibFile
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"MNIconChoosePopView" owner:self options:nil] firstObject];
    
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
         
        [self.iconView setHighlighted:NO];
        [self.ICameraBtn setTitle:NSLocalizedString(@"拍照", nil) forState:UIControlStateNormal];
        self.ICameraBtn.layer.cornerRadius = COMMON_CORNER;
        [self.IPhotoAlbumBtn setTitle:NSLocalizedString(@"选择本地照片", nil) forState:UIControlStateNormal];
        self.IPhotoAlbumBtn.layer.cornerRadius = COMMON_CORNER;
        [self.ICancelBtn setTitle:NSLocalizedString(@"取消", nil) forState:UIControlStateNormal];
        self.ICancelBtn.layer.cornerRadius = COMMON_CORNER;
        self.ICancelBtn.layer.borderWidth = 1.f;
    }
    
    return self;
}

- (void)showInView:(UIView *)view
{
    if (self.isShowed == YES) return;
    self.isShowed = YES;
    
    [view addSubview:self];
    
    self.bottomSpace.constant = 64;
    [UIView animateWithDuration:kAnimationInterval animations:^{
        [self layoutIfNeeded];
    }];
}

#pragma mark - 点击背景view
- (IBAction)clickToBgView:(UITapGestureRecognizer *)sender
{
    [self hideSelf];
}

#pragma mark - 相机按钮点击事件
- (IBAction)cameraBtnClick:(UIButton *)sender
{
    if (_btnClickCallback) {
        _btnClickCallback(BtnClickTypeCamera);
    }
}

#pragma mark - 相册按钮点击事件
- (IBAction)photoAlbumBtnClick:(UIButton *)sender
{
    if (_btnClickCallback) {
        _btnClickCallback(BtnClickTypePhotoAlbum);
    }
}

#pragma mark - 取消按钮点击事件
- (IBAction)cancelBtnClick:(UIButton *)sender
{
    [self hideSelf];
}

- (void)hideSelf
{
    self.isShowed = NO;
    
    self.bottomSpace.constant = - 236;
    [UIView animateWithDuration:kAnimationInterval animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
