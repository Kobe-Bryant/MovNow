//
//  MNBMIViewCtrl.m
//  Movnow
//
//  Created by L-Q on 15/4/24.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//

#import "MNBMIViewCtrl.h"
#import "MNRemindService.h"
#import "MNBMITest.h"

@interface MNBMIViewCtrl ()


/**
 *  指数底视图
 */
@property (weak, nonatomic) IBOutlet UIImageView *BMIImgView;
/**
 *  提醒文字底视图
 */
@property (weak, nonatomic) IBOutlet UIImageView *BMITestImgView;
/**
 *  文字箭头底视图
 */
@property (weak, nonatomic) IBOutlet UIImageView *TestArrowImgView;
/**
 *  箭头指向底视图
 */
@property (weak, nonatomic) IBOutlet UIImageView *ArrowPointImgView;
/**
 *  测试按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *TestButton;
/**
 *  数值标示View
 */
@property (weak, nonatomic) IBOutlet UIView *rankView;
/**
 *  BMI值Label
 */
@property (weak, nonatomic) IBOutlet UILabel *BMILabel;
/**
 *  提示语TextView
 */
@property (weak, nonatomic) IBOutlet UITextView *BMIText;

@end


@implementation MNBMIViewCtrl

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    CGFloat bmi = [[MNRemindService shareInstance].bmi floatValue];
    if ([[U_DEFAULTS objectForKey:IS_BRITISH_SYSTEM] isEqualToString:@"1"])
    {
        if (bmi < 18.5) {
            _BMILabel.text = [NSString stringWithFormat:@"%@  %.1f-%@",NSLocalizedString(@"体质指数", nil),bmi,NSLocalizedString(@"偏瘦",nil)];
            _BMIText.text = NSLocalizedString(@"BMI偏瘦", nil);
            //            rankView.frame = CGRectMake(4.0904*bmi+6.3272, 76, 13, 77);
            _rankView.frame = CGRectMake(4.456*bmi, 15, 13, 77);
        }
        else if (bmi < 25) {
            _BMILabel.text = [NSString stringWithFormat:@"%@  %.1f-%@",NSLocalizedString(@"体质指数", nil),bmi,NSLocalizedString(@"正常",nil)];;
            _BMIText.text = NSLocalizedString(@"BMI适中", nil);
            _rankView.frame = CGRectMake(11.094*bmi-123.239, 15, 13, 77);
        }
        else if (bmi < 30) {
            _BMILabel.text = [NSString stringWithFormat:@"%@  %.1f-%@",NSLocalizedString(@"体质指数", nil),bmi,NSLocalizedString(@"偏重",)];;
            _BMIText.text = NSLocalizedString(@"BMI偏胖",nil);
            _rankView.frame = CGRectMake(14.4*bmi-205.56+13, 15, 13, 77);
        }
        else {
            _BMILabel.text = [NSString stringWithFormat:@"%@  %.1f-%@",NSLocalizedString(@"体质指数", nil),bmi,NSLocalizedString(@"肥胖",nil)];;
            _BMIText.text = NSLocalizedString(@"BMI肥胖",nil);
            _rankView.frame = CGRectMake(1.6837*bmi+174.657, 15, 13, 77);
        }

    } else {
        
        if (bmi < 18.5) {
            _BMILabel.text = [NSString stringWithFormat:@"%@  %.1f-%@",NSLocalizedString(@"体质指数", nil),bmi,NSLocalizedString(@"偏瘦",nil)];
            _BMIText.text = NSLocalizedString(@"BMI偏瘦", nil);
            //            rankView.frame = CGRectMake(5.136*bmi+12.987, 76, 13, 77);
            _rankView.frame = CGRectMake(4.456*bmi, 15, 13, 77);
        }
        else if (bmi < 25) {
            _BMILabel.text = [NSString stringWithFormat:@"%@  %.1f-%@",NSLocalizedString(@"体质指数", nil),bmi,NSLocalizedString(@"正常",nil)];;
            _BMIText.text = NSLocalizedString(@"BMI适中", nil);
            _rankView.frame = CGRectMake(11.094*bmi-123.239, 15, 13, 77);
        }
        else if (bmi < 30) {
            _BMILabel.text = [NSString stringWithFormat:@"%@  %.1f-%@",NSLocalizedString(@"体质指数", nil),bmi,NSLocalizedString(@"偏重",)];;
            _BMIText.text = NSLocalizedString(@"BMI偏胖",nil);
            _rankView.frame = CGRectMake(14.4*bmi-205.56+13, 15, 13, 77);
        }
        else {
            _BMILabel.text = [NSString stringWithFormat:@"%@  %.1f-%@",NSLocalizedString(@"体质指数", nil),bmi,NSLocalizedString(@"肥胖",nil)];;
            _BMIText.text = NSLocalizedString(@"BMI肥胖",nil);
            _rankView.frame = CGRectMake(1.0547*bmi+193.464+13, 15, 13, 77);
        }
    }
}



- (void)viewDidLoad {
    [super viewDidLoad];

    [_TestButton setTitle:NSLocalizedString(@"测试", nil) forState:UIControlStateNormal];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;

}

- (IBAction)testButtonClick:(UIButton *)sender {
    
    MNBMITest *test = [[MNBMITest alloc] init];

    [self.navigationController pushViewController:test animated:YES];
}

- (NSString *)backBarItemText
{
    return NSLocalizedString(@"体质指数", nil);
}

@end