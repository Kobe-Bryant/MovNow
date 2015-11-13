//
//  MNUserInfoViewCtrl.m
//  Movnow
//
//  Created by LiuX on 15/4/17.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//

#import "MNUserInfoViewCtrl.h"
#import "MNUserService.h"
#import "MNLoginViewCtrl.h"
#import "MNBaseNavigationCtrl.h"
#import "MNIconChoosePopView.h"
#import "MNUserModel.h"
#import "MNAdaptAlertView.h"
#import "MNPickerView.h"
#import "MNUserInfoPickBgView.h"
#import "UIImageView+WebCache.h"

@interface MNUserInfoViewCtrl ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

/**
 *  昵称编辑背景视图
 */
@property (weak, nonatomic) IBOutlet UIImageView *UNickNameBgView;
/**
 *  用户头像按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *UIconImageBtn;
/**
 *  昵称展示标签
 */
@property (weak, nonatomic) IBOutlet UILabel *UNickNameLabel;
/**
 *  昵称编辑按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *UNickNameEditBtn;
/**
 *  性别选择按钮——男
 */
@property (weak, nonatomic) IBOutlet UIButton *USexChooseManBtn;
/**
 *  性别选择按钮——女
 */
@property (weak, nonatomic) IBOutlet UIButton *USexChooseWomanBtn;
/**
 *  出生年月编辑按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *UBirthdayBtn;
/**
 *  出生年月展示标签
 */
@property (weak, nonatomic) IBOutlet UILabel *UBirthdayLabel;
/**
 *  体重编辑按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *UWeightBtn;
/**
 *  体重展示标签
 */
@property (weak, nonatomic) IBOutlet UILabel *UWeightLabel;
/**
 *  身高编辑按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *UHeightBtn;
/**
 *  身高展示标签
 */
@property (weak, nonatomic) IBOutlet UILabel *UHeightLabel;
/**
 *  申请到的头像URL
 */
@property (nonatomic,copy) NSString *URequestIconURL;
/**
 *  头像URL地址是否申请到了
 */
@property (nonatomic,assign) BOOL UIconURLIsApply;
/**
 *  选择头像时的弹出视图
 */
@property (nonatomic,strong) MNIconChoosePopView *UIconChoosePopView;
/**
 *  选择视图的背景视图
 */
@property (nonatomic,strong) MNUserInfoPickBgView *UPickBackGroundView;
/**
 *  出生年月选择视图
 */
@property (nonatomic,strong) UIDatePicker *UBirthdayPickView;
/**
 *  体重选择视图
 */
@property (nonatomic,strong) MNPickerView *UWeightPickView;
/**
 *  身高选择视图
 */
@property (nonatomic,strong) MNPickerView *UHeightPickView;
/**
 *  上传时需要的出生年月格式字符串
 */
@property (nonatomic,copy) NSString *UUpdateBirthdayString;

@end

@implementation MNUserInfoViewCtrl

- (MNIconChoosePopView *)UIconChoosePopView
{
    if (_UIconChoosePopView == nil) {
        
        __weak typeof (self) weakSelf = self;
        
        _UIconChoosePopView = [[MNIconChoosePopView alloc]initWithXibFile];
        _UIconChoosePopView.btnClickCallback = ^(BtnClickType type){
            
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
    return _UIconChoosePopView;
}

- (MNUserInfoPickBgView *)UPickBackGroundView
{
    if (_UPickBackGroundView == nil) {
        _UPickBackGroundView = [[MNUserInfoPickBgView alloc]initWithXibFileAndDismissBlock:^(UIView *currentContentView) {
            if ([currentContentView isEqual:self.UBirthdayPickView]) { //出生年月弹出视图
                //用于展示的时间格式
                self.UBirthdayLabel.text = [NSDate getStringWithFormat:@"yyyy/MM/dd" andDate:self.UBirthdayPickView.date];
                //上传需要的时间格式
                NSArray *segmentationArr = [self.UBirthdayLabel.text componentsSeparatedByString:@"/"];
                _UUpdateBirthdayString = [NSString stringWithFormat:@"%@%@%@",segmentationArr[0],segmentationArr[1],segmentationArr[2]];
            }else if ([currentContentView isEqual:self.UWeightPickView]){ //体重弹出视图
                self.UWeightLabel.text = self.UWeightPickView.value;
            }else if ([currentContentView isEqual:self.UHeightPickView]){ //身高弹出视图
                self.UHeightLabel.text = self.UHeightPickView.value;
            }
        }];
    }
    return _UPickBackGroundView;
}

- (UIDatePicker *)UBirthdayPickView
{
    if (_UBirthdayPickView == nil) {
        _UBirthdayPickView = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, 200)];
        _UBirthdayPickView.maximumDate = [NSDate date];
        _UBirthdayPickView.datePickerMode = UIDatePickerModeDate;
        _UBirthdayPickView.tintColor = [UIColor orangeColor];
    }
    return _UBirthdayPickView;
}

- (MNPickerView *)UWeightPickView
{
    if (_UWeightPickView == nil) {
        NSMutableArray *defaultWeightArr = [NSMutableArray array];
        NSString *defaultWeight = nil;
        
        //判断当前是否是英制
        if ([[U_DEFAULTS objectForKey:IS_BRITISH_SYSTEM] isEqualToString:@"1"]) {
            for (int i = 88; i <= 670; i++) {
                [defaultWeightArr addObject:[NSString stringWithFormat:@"%d lb",i]];
            }
            defaultWeight = @"52";
        }else{
            for (NSInteger i = 40; i <= 99; i ++) {
                [defaultWeightArr addObject:[NSString stringWithFormat:@"%ld kg",i]];
            }
            defaultWeight = @"35";
        }
        
        _UWeightPickView = [[MNPickerView alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, 200) andDataArr:defaultWeightArr];
        _UWeightPickView.value = defaultWeight;
    }
    return _UWeightPickView;
}

- (MNPickerView *)UHeightPickView
{
    if (_UHeightPickView == nil) {
        NSMutableArray *defaultHeightArr = [NSMutableArray array];
        NSString *defaultHeight = nil;
        
        //判断当前是否是英制
        if ([[U_DEFAULTS objectForKey:IS_BRITISH_SYSTEM] isEqualToString:@"1"]){
            for (int i = 3; i <= 9; i++) {
                [defaultHeightArr addObject:[NSString stringWithFormat:@"%d ft",i]];
            }
            defaultHeight = @"27";
        }else{
            for (NSInteger i = 99; i <= 299; i ++) {
                [defaultHeightArr addObject:[NSString stringWithFormat:@"%ld cm",i]];
            }
            defaultHeight = @"76";
        }

        _UHeightPickView = [[MNPickerView alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, 200) andDataArr:defaultHeightArr];
        _UHeightPickView.value = defaultHeight;
    }
    return _UHeightPickView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loaclOperation];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setUpRightBarItem];
    
    [self executeDefaultSetting];
    
    [self resetImages];
}

#pragma mark - 默认配置
- (void)executeDefaultSetting
{
    //从模型中取出数据
    _URequestIconURL = [MNUserModel shareInstance].avatar;
    _UIconURLIsApply = YES;
    
    self.UNickNameLabel.text = [MNUserModel shareInstance].nickName;
    
    self.USexChooseManBtn.selected = ([[MNUserModel shareInstance].sex isEqualToNumber:[NSNumber numberWithInteger:1]])?YES:NO;
    self.USexChooseWomanBtn.selected = (self.USexChooseManBtn.selected == YES)?NO:YES;
    
    //出身年月字符串需要进行处理
    NSMutableString *showBirthdayString = [NSMutableString stringWithString:[MNUserModel shareInstance].birthday];
    [showBirthdayString insertString:@"/" atIndex:4];
    [showBirthdayString insertString:@"/" atIndex:7];
    self.UBirthdayLabel.text = showBirthdayString;
    
    //判断当前是否是英制
    if ([[U_DEFAULTS objectForKey:IS_BRITISH_SYSTEM] isEqualToString:@"1"]) {
        self.UWeightLabel.text = [NSString stringWithFormat:@"%.0f lb",([MNUserModel shareInstance].weight.floatValue)/2.2046226f];
        self.UHeightLabel.text = [NSString stringWithFormat:@"%.0f ft",([MNUserModel shareInstance].height.floatValue)/30.48];
    }else{
        self.UWeightLabel.text = [NSString stringWithFormat:@"%@ kg",[MNUserModel shareInstance].weight.stringValue];
        self.UHeightLabel.text = [NSString stringWithFormat:@"%@ cm",[MNUserModel shareInstance].height.stringValue];
    }
}

#pragma mark - 保存按钮
- (NSString *)rightBarItemText
{
    return NSLocalizedString(@"保存",nil);
}

- (void)rightBarItemPress:(UIButton *)sender
{
    if (_UIconURLIsApply == NO) {
        [self.view showHUDWithStr:NSLocalizedString(@"头像地址正在申请中",nil) hideAfterDelay:kAlertWordsInterval];
        return;
    }
    
    [[MNUserService shareInstance] updateUserInfoWithIconURL:_URequestIconURL nickname:self.UNickNameLabel.text sex:self.USexChooseManBtn.selected?SexTypeMan:SexTypeWoman birthday:_UUpdateBirthdayString weight:self.UWeightLabel.text height:self.UHeightLabel.text success:^(id result) {
        [self.view showHUDWithStr:NSLocalizedString(result,nil) hideAfterDelay:kAlertWordsInterval];
    } failure:^(id reason) {
        [self.view showHUDWithStr:NSLocalizedString(reason,nil) hideAfterDelay:kAlertWordsInterval];
    } needLoginOut:^{
        JUMP_TO_LOGIN;
    }];
}

#pragma mark - 本地化操作
- (void)loaclOperation
{
    [self.UNickNameEditBtn setTitle:NSLocalizedString(@"编辑", nil) forState:UIControlStateNormal];
    [self.UBirthdayBtn setTitle:NSLocalizedString(@"年龄:", nil) forState:UIControlStateNormal];
    [self.UWeightBtn setTitle:NSLocalizedString(@"体重:", nil) forState:UIControlStateNormal];
    [self.UHeightBtn setTitle:NSLocalizedString(@"身高:", nil) forState:UIControlStateNormal];
}

#pragma mark - 重设图片
- (void)resetImages
{
    [self.UIconImageBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:_URequestIconURL] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:IMAGE_NAME(@"profile_avatar")]];
    [self.UIconChoosePopView.iconView sd_setImageWithURL:[NSURL URLWithString:_URequestIconURL] placeholderImage:[UIImage imageNamed:IMAGE_NAME(@"profile_avatar")]];
    [self.UNickNameBgView setImage:[UIImage imageNamed:IMAGE_NAME(@"list")]];
    [self.UNickNameEditBtn setBackgroundImage:[UIImage imageNamed:IMAGE_NAME(@"pop_btn_cancel")] forState:UIControlStateNormal];
    [self.UNickNameEditBtn setBackgroundImage:[UIImage imageNamed:IMAGE_NAME(@"pop_btn_confirm")] forState:UIControlStateHighlighted];
    [self.USexChooseManBtn setImage:[UIImage imageNamed:IMAGE_NAME(@"sex_btn_man")] forState:UIControlStateNormal];
    [self.USexChooseManBtn setImage:[UIImage imageNamed:IMAGE_NAME(@"sex_btn_man_selected")] forState:UIControlStateSelected];
    [self.USexChooseManBtn setBackgroundImage:[UIImage imageNamed:IMAGE_NAME(@"sex_background")] forState:UIControlStateNormal];
    [self.USexChooseWomanBtn setImage:[UIImage imageNamed:IMAGE_NAME(@"sex_btn_woman")] forState:UIControlStateNormal];
    [self.USexChooseWomanBtn setImage:[UIImage imageNamed:IMAGE_NAME(@"sex_btn_woman_selected")] forState:UIControlStateSelected];
    [self.USexChooseWomanBtn setBackgroundImage:[UIImage imageNamed:IMAGE_NAME(@"sex_background")] forState:UIControlStateNormal];
    [self.UBirthdayBtn setBackgroundImage:[UIImage imageNamed:IMAGE_NAME(@"list")] forState:UIControlStateNormal];
    [self.UBirthdayBtn setBackgroundImage:[UIImage imageNamed:IMAGE_NAME(@"list_press")] forState:UIControlStateHighlighted];
    [self.UWeightBtn setBackgroundImage:[UIImage imageNamed:IMAGE_NAME(@"list")] forState:UIControlStateNormal];
    [self.UWeightBtn setBackgroundImage:[UIImage imageNamed:IMAGE_NAME(@"list_press")] forState:UIControlStateHighlighted];
    [self.UHeightBtn setBackgroundImage:[UIImage imageNamed:IMAGE_NAME(@"list")] forState:UIControlStateNormal];
    [self.UHeightBtn setBackgroundImage:[UIImage imageNamed:IMAGE_NAME(@"list_press")] forState:UIControlStateHighlighted];
}

#pragma mark - 头像选择按钮点击事件
- (IBAction)iconImageBtnClick:(UIButton *)sender
{
    [self.UIconChoosePopView showInView:self.view];
}

#pragma mark  昵称编辑按钮点击事件
- (IBAction)nickNameEditBtnClick:(UIButton *)sender
{
    MNAdaptAlertView *tfAlert = [[MNAdaptAlertView alloc]initStyleTextFieldWithBlock:^(MNAdaptAlertView *alertView, int buttonIndex) {
        if (buttonIndex == 1) {
            if ([alertView.textField.text isEqualToString:@""]) {
                [self.view showHUDWithStr:NSLocalizedString(@"昵称不能为空", nil) hideAfterDelay:kAlertWordsInterval];
            }else{
                self.UNickNameLabel.text = alertView.textField.text;
            }
        }
    }];
    tfAlert.textField.text = self.UNickNameLabel.text;
    [tfAlert show];
    [tfAlert.textField becomeFirstResponder];
}

#pragma mark  性别选择按钮点击事件
- (IBAction)sexChooseBtnClick:(UIButton *)sender
{
    self.USexChooseManBtn.selected = NO;
    self.USexChooseWomanBtn.selected = NO;
    sender.selected = YES;
}

#pragma mark  出生年月按钮点击事件
- (IBAction)birthdayChooseBtnClick:(UIButton *)sender
{
    [self.UPickBackGroundView setContentView:self.UBirthdayPickView];
    [self.UPickBackGroundView showInView:self.view];
}

#pragma mark 体重选择按钮点击事件
- (IBAction)weightChooseBtnClick:(UIButton *)sender
{
    [self.UPickBackGroundView setContentView:self.UWeightPickView];
    [self.UPickBackGroundView showInView:self.view];
}

#pragma mark  身高选择按钮点击事件
- (IBAction)heightChooseBtnClick:(UIButton *)sender
{
    [self.UPickBackGroundView setContentView:self.UHeightPickView];
    [self.UPickBackGroundView showInView:self.view];
}

#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //取出用户选择的图片
    UIImage *pickedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
        //设置图片
        [self.UIconImageBtn setBackgroundImage:pickedImage forState:UIControlStateNormal];
        [self.UIconChoosePopView.iconView setImage:pickedImage];
        
        //头像的URL地址请求完成之前 无法进行保存用户信息
        _UIconURLIsApply = NO;
        
        //URL地址请求开始
        [[MNUserService shareInstance] uploadUserIcon:pickedImage success:^(id result) {
            _URequestIconURL = result;
            _UIconURLIsApply = YES;
        } failure:^(id reason) {
            [self.view showHUDWithStr:NSLocalizedString(reason, nil) hideAfterDelay:kAlertWordsInterval];
            _UIconURLIsApply = YES;
        } needLoginOut:^{
            JUMP_TO_LOGIN;
        }];
    }];
}

@end
