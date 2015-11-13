//
//  MNCalorieFoodCell.m
//  Movnow
//
//  Created by LiuX on 15/5/11.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//

#import "MNCalorieFoodCell.h"
#import "MNCalorieModel.h"

@interface MNCalorieFoodCell ()

@property (weak, nonatomic) IBOutlet UIImageView *foodImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *calorieValueLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@end

@implementation MNCalorieFoodCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.layer.cornerRadius = COMMON_CORNER;
    [self.deleteBtn setImage:[UIImage imageNamed:IMAGE_NAME(@"calorie_delete_btn")] forState:UIControlStateNormal];
    [self.deleteBtn setImage:[UIImage imageNamed:IMAGE_NAME(@"calorie_delete_btn_press")] forState:UIControlStateHighlighted];
}

- (IBAction)deleteBtnClick:(UIButton *)sender
{
    if (_deleteBtnClickBlock) {
        _deleteBtnClickBlock();
    }
}

- (void)setCModel:(MNCalorieModel *)cModel
{
    _cModel = cModel;
    
    if (cModel.cImageData) {
        self.foodImageView.image = [UIImage imageWithData:cModel.cImageData];
    }
    self.nameLabel.text = cModel.cFoodName;
    self.calorieValueLabel.text = cModel.cCalorieNumber.stringValue;
}

@end
