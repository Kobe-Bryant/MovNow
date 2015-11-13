//
//  MNEditFoodViewCtrl.m
//  Movnow
//
//  Created by LiuX on 15/5/11.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//

#import "MNEditFoodViewCtrl.h"
#import "MNCalorieModel.h"
#import "MNIconChoosePopView.h"

@interface MNEditFoodViewCtrl ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

/**
 *  食物图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *EFoodImageView;
/**
 *  卡路里图标
 */
@property (weak, nonatomic) IBOutlet UIImageView *ECalorieIcon1;
@property (weak, nonatomic) IBOutlet UIImageView *ECalorieIcon2;
/**
 *  食物名称背景视图
 */
@property (weak, nonatomic) IBOutlet UIImageView *ENameBgImageView;
/**
 *  食物卡路里背景视图
 */
@property (weak, nonatomic) IBOutlet UIImageView *ECalorieBgImageView;
/**
 *  食物名称输入框
 */
@property (weak, nonatomic) IBOutlet UITextField *ENameTF;
/**
 *  食物名称输入框
 */
@property (weak, nonatomic) IBOutlet UITextField *ECalorieTF;
/**
 *  选择头像时的弹出视图
 */
@property (nonatomic,strong) MNIconChoosePopView *EIconChoosePopView;

@end

@implementation MNEditFoodViewCtrl

- (MNIconChoosePopView *)EIconChoosePopView
{
    if (_EIconChoosePopView == nil) {
        
        __weak typeof (self) weakSelf = self;
        
        _EIconChoosePopView = [[MNIconChoosePopView alloc]initWithXibFile];
        _EIconChoosePopView.btnClickCallback = ^(BtnClickType type){
            
            UIImagePickerController* imagePickerController = [[UIImagePickerController alloc] init];
            imagePickerController.allowsEditing = YES;
            imagePickerController.delegate = weakSelf;
            
            switch (type) {
                case BtnClickTypeCamera: //照相
                {
                    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                        [weakSelf.view showHUDWithStr:NSLocalizedString(@"当前照相机不可用",nil) hideAfterDelay:kAlertWordsInterval];
                        return;
                    }
                    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                }
                    break;
                case BtnClickTypePhotoAlbum: //相册
                {
                    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                        [weakSelf.view showHUDWithStr:NSLocalizedString(@"当前相册不可用",nil) hideAfterDelay:kAlertWordsInterval];
                        return;
                    }
                    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                }
                    break;
                default:
                    break;
            }
            
            [weakSelf presentViewController:imagePickerController animated:YES completion:nil];
        };
    }
    return _EIconChoosePopView;
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
    
    [self setUpRightBarItem];
}

#pragma mark - 默认配置
- (void)executeDefaultSetting
{
    [self.EFoodImageView setImage:[UIImage imageWithData:_cModel.cImageData]];
    self.EIconChoosePopView.iconView.image = self.EFoodImageView.image;
    self.ENameTF.text = _cModel.cFoodName;
    if ([_cModel.cCalorieNumber.stringValue isEqualToString:@"0"]) {
        self.ECalorieTF.text = @"";
    }else{
        self.ECalorieTF.text = _cModel.cCalorieNumber.stringValue;
    }
}

#pragma mark - 重设图片
- (void)resetImages
{
    [self.ECalorieIcon1 setImage:[UIImage imageNamed:IMAGE_NAME(@"calories_icon")]];
    [self.ECalorieIcon2 setImage:[UIImage imageNamed:IMAGE_NAME(@"calories_icon")]];
    [self.ENameBgImageView setImage:[UIImage imageNamed:IMAGE_NAME(@"input")]];
    [self.ECalorieBgImageView setImage:[UIImage imageNamed:IMAGE_NAME(@"input")]];
}

#pragma mark - 本地化操作
- (void)loaclOperation
{
    self.ENameTF.attributedPlaceholder = [[NSAttributedString alloc]initWithString:NSLocalizedString(@"输入食物名称",nil) attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    self.ECalorieTF.attributedPlaceholder = [[NSAttributedString alloc]initWithString:NSLocalizedString(@"输入食物卡路里", nil) attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
}

#pragma mark - 保存按钮
- (NSString *)rightBarItemText
{
    return NSLocalizedString(@"保存", nil);
}

- (void)rightBarItemPress:(UIButton *)item
{
    if ([self.ENameTF.text isEqualToString:@""]) {
        [self.view showHUDWithStr:NSLocalizedString(@"食物名称不能为空", nil) hideAfterDelay:kAlertWordsInterval];
        return;
    }
    
    if ([self.ECalorieTF.text isEqualToString:@""]) {
        [self.view showHUDWithStr:NSLocalizedString(@"食物卡路里不能为空", nil) hideAfterDelay:kAlertWordsInterval];
        return;
    }
    
    if (self.editType == FoodEditTypeAdd) { //添加
        if (self.didAddCalorieFood) {
            self.didAddCalorieFood([MNCalorieModel modelWithImageData:_cModel.cImageData name:self.ENameTF.text calorieNumber:[NSNumber numberWithFloat:[self.ECalorieTF.text floatValue]]]);
        }
    }else if (self.editType == FoodEditTypeChange){ //修改
        if (self.didChangeCalorieFood) {
            self.didChangeCalorieFood([MNCalorieModel modelWithImageData:UIImagePNGRepresentation(self.EFoodImageView.image) name:self.ENameTF.text calorieNumber:[NSNumber numberWithFloat:[self.ECalorieTF.text floatValue]]],_changeIndexPath);
        }
    }
    
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 点击食物图片
- (IBAction)clickToFoodImage:(UITapGestureRecognizer *)sender
{
    if (self.editType == FoodEditTypeAdd) return;
    
    [self.view endEditing:YES];
    [self.EIconChoosePopView showInView:self.view];
}

#pragma mark - 点击背景视图
- (IBAction)clickToBgView:(UITapGestureRecognizer *)sender
{
    [self.view endEditing:YES];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.ENameTF) {
        [self.ENameBgImageView setImage:[UIImage imageNamed:IMAGE_NAME(@"input_signup_s")]];
    }else if (textField == self.ECalorieTF){
        [self.ECalorieBgImageView setImage:[UIImage imageNamed:IMAGE_NAME(@"input_signup_s")]];
    }
    
    [UIView animateWithDuration:kAnimationInterval animations:^{
        CGRect tempRect = self.view.frame;
        tempRect.origin.y = -114;
        self.view.frame = tempRect;
    }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.ENameTF) {
        [self.ENameBgImageView setImage:[UIImage imageNamed:IMAGE_NAME(@"input")]];
    }else if (textField == self.ECalorieTF){
        [self.ECalorieBgImageView setImage:[UIImage imageNamed:IMAGE_NAME(@"input")]];
    }
    
    [UIView animateWithDuration:kAnimationInterval animations:^{
        CGRect tempRect = self.view.frame;
        tempRect.origin.y = 64;
        self.view.frame = tempRect;
    }];
}

#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //取出用户选择的图片
    UIImage *pickedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        [self.EFoodImageView setImage:pickedImage];
        self.EIconChoosePopView.iconView.image = self.EFoodImageView.image;
    }];
}

@end