//
//  MNIconChoosePopView.h
//  Movnow
//
//  Created by LiuX on 15/4/17.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MNIconChoosePopView;

typedef NS_ENUM(NSInteger, BtnClickType){
    BtnClickTypeCamera, //相机
    BtnClickTypePhotoAlbum //相册
};

typedef void (^btnClickCallback)(BtnClickType type);

@interface MNIconChoosePopView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@property (nonatomic,copy) btnClickCallback btnClickCallback;

/**
 *  从Xib文件初始化
 *
 */
- (MNIconChoosePopView *)initWithXibFile;

/**
 *  显示
 *
 */
- (void)showInView:(UIView *)view;
/**
 *  隐藏
 */
- (void)hideSelf;

@end
