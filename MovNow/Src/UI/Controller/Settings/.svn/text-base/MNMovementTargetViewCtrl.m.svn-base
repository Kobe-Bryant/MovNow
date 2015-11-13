//
//  MNMovementTargetViewCtrl.m
//  Movnow
//
//  Created by LiuX on 15/4/23.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//

#import "MNMovementTargetViewCtrl.h"
#import "MNUserService.h"
#import "MNMovementService.h"
@interface MNMovementTargetViewCtrl ()

/**
 *  步数增加按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *MStepAddBtn;
/**
 *  步数减少按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *MStepReduceBtn;
/**
 *  步数图表背景图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *MStepBgImgView;
/**
 *  步数展示图片万位
 */
@property (weak, nonatomic) IBOutlet UIImageView *MStepNumImgView1;
/**
 *  步数展示图片千位
 */
@property (weak, nonatomic) IBOutlet UIImageView *MStepNumImgView2;
/**
 *  步数展示图片百位
 */
@property (weak, nonatomic) IBOutlet UIImageView *MStepNumImgView3;
/**
 *  步数展示图片十位
 */
@property (weak, nonatomic) IBOutlet UIImageView *MStepNumImgView4;
/**
 *  步数展示图片个位
 */
@property (weak, nonatomic) IBOutlet UIImageView *MStepNumImgView5;
/**
 *  活跃分子当前步数背景视图
 */
@property (weak, nonatomic) IBOutlet UIView *MCurrentStepBgView1;
/**
 *  减肥达人当前步数背景视图
 */
@property (weak, nonatomic) IBOutlet UIView *MCurrentStepBgView2;
/**
 *  普普通通当前步数背景视图
 */
@property (weak, nonatomic) IBOutlet UIView *MCurrentStepBgView3;
/**
 *  活跃分子当前步数标签
 */
@property (weak, nonatomic) IBOutlet UILabel *MCurrentStepLabel1;
/**
 *  减肥达人当前步数标签
 */
@property (weak, nonatomic) IBOutlet UILabel *MCurrentStepLabel2;
/**
 *  普普通通当前步数标签
 */
@property (weak, nonatomic) IBOutlet UILabel *MCurrentStepLabel3;
/**
 *  活跃分子按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *MDefaultStepBtn1;
/**
 *  减肥达人按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *MDefaultStepBtn2;
/**
 *  普普通通按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *MDefaultStepBtn3;
/**
 *  当前选择的步数
 */
@property (nonatomic,assign) NSInteger MCurrentChoosedStep;
/**
 *  步数设置引导标签
 */
@property (weak, nonatomic) IBOutlet UILabel *MStepGuideLabel;
/**
 *  活跃分子当前情况文字标签
 */
@property (weak, nonatomic) IBOutlet UILabel *MCurrentStateLabel1;
/**
 *  减肥达人当前情况文字标签
 */
@property (weak, nonatomic) IBOutlet UILabel *MCurrentStateLabel2;
/**
 *  普普通通当前情况文字标签
 */
@property (weak, nonatomic) IBOutlet UILabel *MCurrentStateLabel3;

@end

@implementation MNMovementTargetViewCtrl

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loaclOperation];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setUpRightBarItem];
    
    [self resetImages];
    
    //从单例中获取之前设置过的步数
    _MCurrentChoosedStep = [MNMovementService shareInstance].goalStep;
    
    //确定步数图片的展示状态 确定默认按钮的选中状态
    [self changeNumImageStateAndDefaultBtnStateWithCurrentStep];
}

#pragma mark - 右侧按钮
- (NSString *)rightBarItemText
{
    return NSLocalizedString(@"保存", ni);
}

- (void)rightBarItemPress:(UIButton *)item
{
    [[MNMovementService shareInstance] setMovementTargetWithSteps:_MCurrentChoosedStep success:^(id result) {
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(id reason) {
        [self.view showHUDWithStr:NSLocalizedString(reason,nil) hideAfterDelay:kAlertWordsInterval];
    }];
}

#pragma mark - 本地化操作
- (void)loaclOperation
{
    self.MCurrentStateLabel1.text = NSLocalizedString(@"当前情况", ni);
    self.MCurrentStateLabel2.text = NSLocalizedString(@"当前情况", ni);
    self.MCurrentStateLabel3.text = NSLocalizedString(@"当前情况", ni);
    self.MStepGuideLabel.text = NSLocalizedString(@"设置每天想要实现的目标", ni);
    [self.MDefaultStepBtn1 setTitle:NSLocalizedString(@"活跃分子", ni) forState:UIControlStateNormal];
    [self.MDefaultStepBtn2 setTitle:NSLocalizedString(@"减肥牛人", ni) forState:UIControlStateNormal];
    [self.MDefaultStepBtn3 setTitle:NSLocalizedString(@"普普通通", ni) forState:UIControlStateNormal];
}

#pragma mark - 重设图片
- (void)resetImages
{
    [self.MStepBgImgView setImage:[UIImage imageNamed:IMAGE_NAME(@"step_background")]];
    [self.MStepAddBtn setImage:[UIImage imageNamed:IMAGE_NAME(@"btn_arrow_up")] forState:UIControlStateNormal];
    [self.MStepAddBtn setImage:[UIImage imageNamed:IMAGE_NAME(@"btn_arrow_up_press")] forState:UIControlStateHighlighted];
    [self.MStepReduceBtn setImage:[UIImage imageNamed:IMAGE_NAME(@"btn_arrow_down")] forState:UIControlStateNormal];
    [self.MStepReduceBtn setImage:[UIImage imageNamed:IMAGE_NAME(@"btn_arrow_down_press")] forState:UIControlStateHighlighted];
    [self.MDefaultStepBtn1 setBackgroundImage:[UIImage imageNamed:IMAGE_NAME(@"goal_aventurn")] forState:UIControlStateNormal];
    [self.MDefaultStepBtn1 setBackgroundImage:[UIImage imageNamed:IMAGE_NAME(@"goal_aventurn_press")] forState:UIControlStateSelected];
    [self.MDefaultStepBtn2 setBackgroundImage:[UIImage imageNamed:IMAGE_NAME(@"goal_niuren")] forState:UIControlStateNormal];
    [self.MDefaultStepBtn2 setBackgroundImage:[UIImage imageNamed:IMAGE_NAME(@"goal_niuren_press")] forState:UIControlStateSelected];
    [self.MDefaultStepBtn3 setBackgroundImage:[UIImage imageNamed:IMAGE_NAME(@"goal_normal")] forState:UIControlStateNormal];
    [self.MDefaultStepBtn3 setBackgroundImage:[UIImage imageNamed:IMAGE_NAME(@"goal_normal_press")] forState:UIControlStateSelected];
}

#pragma mark - 步数增加按钮点击事件
- (IBAction)stepAddBtnClick:(UIButton *)sender
{
    _MCurrentChoosedStep += 100;
    [self changeNumImageStateAndDefaultBtnStateWithCurrentStep];
}

#pragma mark  步数减少按钮点击事件
- (IBAction)stepReduceBtnClick:(UIButton *)sender
{
    _MCurrentChoosedStep -= 100;
    [self changeNumImageStateAndDefaultBtnStateWithCurrentStep];
}

#pragma mark - 默认步数按钮点击事件
- (IBAction)defaultStepBtnClick:(UIButton *)sender
{
    switch (sender.tag) {
        case 100: //活跃分子
        {
            _MCurrentChoosedStep = 12000;
        }
            break;
        case 200: //减肥牛人
        {
            _MCurrentChoosedStep = 17000;
        }
            break;
        case 300: //普普通通
        {
            _MCurrentChoosedStep = 7000;
        }
            break;
        default:
            break;
    }
    [self changeNumImageStateAndDefaultBtnStateWithCurrentStep];
}

#pragma mark - 步数图片万位上滑事件
- (IBAction)stepNumImgView1SwipeTouchUp:(UISwipeGestureRecognizer *)sender
{
    _MCurrentChoosedStep += 10000;
    [self changeNumImageStateAndDefaultBtnStateWithCurrentStep];
}

#pragma mark  步数图片万位下滑事件
- (IBAction)stepNumImgView1SwipeTouchDown:(UISwipeGestureRecognizer *)sender
{
    _MCurrentChoosedStep -= 10000;
    [self changeNumImageStateAndDefaultBtnStateWithCurrentStep];
}

#pragma mark  步数图片千位上滑事件
- (IBAction)stepNumImgView2SwipeTouchUp:(UISwipeGestureRecognizer *)sender
{
    _MCurrentChoosedStep += 1000;
    [self changeNumImageStateAndDefaultBtnStateWithCurrentStep];
}

#pragma mark  步数图片千位下滑事件
- (IBAction)stepNumImgView2SwipeTouchDown:(UISwipeGestureRecognizer *)sender
{
    _MCurrentChoosedStep -= 1000;
    [self changeNumImageStateAndDefaultBtnStateWithCurrentStep];
}

#pragma mark  步数图片百位十位个位上滑事件
- (IBAction)stepNumImgView345SwipeTouchUp:(UISwipeGestureRecognizer *)sender
{
    _MCurrentChoosedStep += 100;
   [self changeNumImageStateAndDefaultBtnStateWithCurrentStep];
}

#pragma mark  步数图片百位十位个位下滑事件
- (IBAction)tepNumImgView345SwipeTouchDown:(UISwipeGestureRecognizer *)sender
{
    _MCurrentChoosedStep -= 100;
    [self changeNumImageStateAndDefaultBtnStateWithCurrentStep];
}

#pragma mark - 根据当前的步数确定步数图片的显示状态和默认步数按钮的选中状态
- (void)changeNumImageStateAndDefaultBtnStateWithCurrentStep
{
    //极限情况判断
    if (_MCurrentChoosedStep < 0) {
        _MCurrentChoosedStep += 100000;
    }else if (_MCurrentChoosedStep >= 100000) {
        _MCurrentChoosedStep -= 100000;
    }
    
    /*
    确定当前步数标签的展示状态
    确定默认步数按钮的选中状态
    确定当前步数背景视图的显示隐藏
    */
    if (_MCurrentChoosedStep < 12000) { //普普通通
        
        self.MDefaultStepBtn1.selected = NO;
        self.MDefaultStepBtn2.selected = NO;
        self.MDefaultStepBtn3.selected = YES;
        
        self.MCurrentStepBgView1.hidden = YES;
        self.MCurrentStepBgView2.hidden = YES;
        self.MCurrentStepBgView3.hidden = NO;
        
        self.MCurrentStepLabel3.text = [NSString stringWithFormat:@"%ld %@",_MCurrentChoosedStep,NSLocalizedString(@"步",nil)];
    }else if (_MCurrentChoosedStep >= 12000&&_MCurrentChoosedStep < 17000){ //活跃分子
        
        self.MDefaultStepBtn1.selected = YES;
        self.MDefaultStepBtn2.selected = NO;
        self.MDefaultStepBtn3.selected = NO;
        
        self.MCurrentStepBgView1.hidden = NO;
        self.MCurrentStepBgView2.hidden = YES;
        self.MCurrentStepBgView3.hidden = YES;
        
        self.MCurrentStepLabel1.text = [NSString stringWithFormat:@"%ld %@",_MCurrentChoosedStep,NSLocalizedString(@"步",nil)];
    }else if (_MCurrentChoosedStep >= 17000){ //减肥牛人
        
        self.MDefaultStepBtn1.selected = NO;
        self.MDefaultStepBtn2.selected = YES;
        self.MDefaultStepBtn3.selected = NO;
        
        self.MCurrentStepBgView1.hidden = YES;
        self.MCurrentStepBgView2.hidden = NO;
        self.MCurrentStepBgView3.hidden = YES;
        
        self.MCurrentStepLabel2.text = [NSString stringWithFormat:@"%ld %@",_MCurrentChoosedStep,NSLocalizedString(@"步",nil)];
    }
    
    //确定当前步数是几位数 然后进行处理
    NSString *stepDigitStr = nil;
    
    switch ([NSString stringWithFormat:@"%ld",_MCurrentChoosedStep].length) {
        case 1:
        {
            stepDigitStr = [NSString stringWithFormat:@"00000"];
        }
            break;
        case 3:
        {
            stepDigitStr = [NSString stringWithFormat:@"00%ld",_MCurrentChoosedStep];
        }
            break;
        case 4:
        {
            stepDigitStr = [NSString stringWithFormat:@"0%ld",_MCurrentChoosedStep];
        }
            break;
        case 5:
        {
            stepDigitStr = [NSString stringWithFormat:@"%ld",_MCurrentChoosedStep];
        }
            break;
        default:
            break;
    }
    
    //提取出步数字符串中的所有字符
    NSMutableArray *stepCutArr = [NSMutableArray array];
    for (NSInteger i = 0; i < stepDigitStr.length; i ++) {
        char ch = [stepDigitStr characterAtIndex:i];
        NSString *stepNumStr = [NSString stringWithFormat:@"%c",ch];
        [stepCutArr addObject:stepNumStr];
    }
    
    //确定每一张步数图片的显示样式
    [self.MStepNumImgView1 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@num_%@",_Image_Prefix,stepCutArr[0]]]];
    [self.MStepNumImgView2 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@num_%@",_Image_Prefix,stepCutArr[1]]]];
    [self.MStepNumImgView3 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@num_%@",_Image_Prefix,stepCutArr[2]]]];
    [self.MStepNumImgView4 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@num_%@",_Image_Prefix,stepCutArr[3]]]];
    [self.MStepNumImgView5 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@num_%@",_Image_Prefix,stepCutArr[4]]]];
}

@end
