//
//  MNCalorieManageViewCtrl.m
//  Movnow
//
//  Created by LiuX on 15/5/11.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//

#import "MNCalorieManageViewCtrl.h"
#import "MNCalorieFoodCell.h"
#import "MNCalorieModel.h"
#import "MNAdaptAlertView.h"
#import "MNEditFoodViewCtrl.h"
#import "MNIconChoosePopView.h"

#define CELL_IDENTIFIER @"MNCalorieFoodCell"

@interface MNCalorieManageViewCtrl ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

/**
 *  食物展示视图
 */
@property (weak, nonatomic) IBOutlet UICollectionView *CFoodCollectionView;
/**
 *  食物数组
 */
@property (nonatomic,strong) NSMutableArray *cCalorieFoodArr;
/**
 *  卡路里图标
 */
@property (weak, nonatomic) IBOutlet UIImageView *CCalorieIconView;
/**
 *  固定文字标签
 */
@property (weak, nonatomic) IBOutlet UILabel *CCalorieConstLabel1;
@property (weak, nonatomic) IBOutlet UILabel *CCalorieConstLabel2;
/**
 *  卡路里计算过程标签
 */
@property (weak, nonatomic) IBOutlet UILabel *CCalorieCalculateLabel;
/**
 *  卡路里计算结果标签
 */
@property (weak, nonatomic) IBOutlet UILabel *CCalorieResultLabel;
/**
 *  选择头像时的弹出视图
 */
@property (nonatomic,strong) MNIconChoosePopView *CIconChoosePopView;
/**
 *  返回按钮的文字
 */
@property (nonatomic,copy) NSString *backItemText;

@end

@implementation MNCalorieManageViewCtrl

- (NSMutableArray *)cCalorieFoodArr
{
    if (_cCalorieFoodArr == nil) {
        //直接取出缓存的数组
        NSData *calorieFoodArrData = [U_DEFAULTS objectForKey:CALORIE_ARRAY_DATA];
        if (calorieFoodArrData) {
            _cCalorieFoodArr = [NSKeyedUnarchiver unarchiveObjectWithData:calorieFoodArrData];
        }else{
            _cCalorieFoodArr = [NSMutableArray array];
        }
    }
    return _cCalorieFoodArr;
}

- (MNIconChoosePopView *)CIconChoosePopView
{
    if (_CIconChoosePopView == nil) {
        
        __weak typeof (self) weakSelf = self;
        
        _CIconChoosePopView = [[MNIconChoosePopView alloc]initWithXibFile];
        _CIconChoosePopView.btnClickCallback = ^(BtnClickType type){
            
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
    return _CIconChoosePopView;
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
}

#pragma mark - 默认配置
- (void)executeDefaultSetting
{
    [self.CFoodCollectionView registerNib:[UINib nibWithNibName:CELL_IDENTIFIER bundle:nil] forCellWithReuseIdentifier:CELL_IDENTIFIER];
    
    [self countingTodayCalorieUptake];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(rightBarButtonItemClick)];
}

#pragma mark 返回文字
- (NSString *)backBarItemText
{
    return NSLocalizedString(_backItemText, nil);
}

#pragma mark - 添加食物按钮点击事件
- (void)rightBarButtonItemClick
{
    [self.CIconChoosePopView showInView:self.view];
}

#pragma mark - 重设图片
- (void)resetImages
{
    [self.CCalorieIconView setImage:[UIImage imageNamed:IMAGE_NAME(@"calories_icon")]];
}

#pragma mark - 本地化操作
- (void)loaclOperation
{
    self.CCalorieConstLabel1.text = NSLocalizedString(@"今日卡路里摄取", nil);
    self.CCalorieConstLabel2.text = NSLocalizedString(@"卡路里摄取 - 卡路里消耗", nil);
}

#pragma mark - 计算今日卡路里摄取
- (void)countingTodayCalorieUptake
{
    CGFloat totalCalorie = 0;
    for (MNCalorieModel *tempModel in self.cCalorieFoodArr) {
        totalCalorie += tempModel.cCalorieNumber.floatValue;
    }
    self.CCalorieCalculateLabel.text = [NSString stringWithFormat:@"%.1f - %.1f", totalCalorie, _consumeCalorieNumber.floatValue];
    self.CCalorieResultLabel.text = [NSString stringWithFormat:@"%.1f", totalCalorie - _consumeCalorieNumber.floatValue];
}

#pragma mark - 刷新界面并存储数组
- (void)refreshUIAndSaveData
{
    [self.CFoodCollectionView reloadData];
    [self countingTodayCalorieUptake];
    
    //永久保存
    [U_DEFAULTS setObject:[NSKeyedArchiver archivedDataWithRootObject:self.cCalorieFoodArr] forKey:CALORIE_ARRAY_DATA];
    [U_DEFAULTS synchronize];
}

#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //取出用户选择的图片
    UIImage *pickedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        [self.CIconChoosePopView hideSelf];
        
        //添加食物信息
        MNEditFoodViewCtrl *addFoodVC = [[MNEditFoodViewCtrl alloc]initWithNibName:@"MNEditFoodViewCtrl" bundle:nil];
        addFoodVC.editType = FoodEditTypeAdd;
        addFoodVC.cModel = [MNCalorieModel modelWithImageData:UIImagePNGRepresentation(pickedImage) name:@"" calorieNumber:[NSNumber numberWithFloat:0]];
        addFoodVC.didAddCalorieFood = ^(MNCalorieModel *cModel){
            [self.cCalorieFoodArr addObject:cModel];
            [self refreshUIAndSaveData];
        };
        
        _backItemText = @"添加食物";
        [self setUpBackBarItem];
        [self.navigationController pushViewController:addFoodVC animated:YES];
    }];
}

#pragma mark - UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //修改食物信息
    MNEditFoodViewCtrl *changeFoodVC = [[MNEditFoodViewCtrl alloc]initWithNibName:@"MNEditFoodViewCtrl" bundle:nil];
    changeFoodVC.changeIndexPath = indexPath;
    changeFoodVC.editType = FoodEditTypeChange;
    changeFoodVC.cModel = self.cCalorieFoodArr[indexPath.row];
    changeFoodVC.didChangeCalorieFood = ^(MNCalorieModel *cModel,NSIndexPath *changeIndexPath){
        [self.cCalorieFoodArr replaceObjectAtIndex:changeIndexPath.row withObject:cModel];
        [self refreshUIAndSaveData];
    };
    
    _backItemText = @"修改食物";
    [self setUpBackBarItem];
    [self.navigationController pushViewController:changeFoodVC animated:YES];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.cCalorieFoodArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MNCalorieFoodCell *cell = (MNCalorieFoodCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    
    //删除按钮点击事件
    cell.deleteBtnClickBlock = ^(){
        MNAdaptAlertView *alert = [[MNAdaptAlertView alloc]initStyleWithMessage:NSLocalizedString(@"您确定删除该食物吗?",nil) andBlock:^(MNAdaptAlertView *alertView, int buttonIndex) {
            if (buttonIndex == 1) {
                [self.cCalorieFoodArr removeObjectAtIndex:indexPath.row];
                [self refreshUIAndSaveData];
            }
        }];
        [alert show];
    };
    
    cell.cModel = self.cCalorieFoodArr[indexPath.row];
    
    return cell;
}

@end