//
//  MNHistoryForWeekDetailCell.m
//  Movnow
//
//  Created by LiuX on 15/5/14.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//

#import "MNHistoryDetailCell.h"
#import "MNHistoryDetailModel.h"

@interface MNHistoryDetailCell ()

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dataLabel;
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;

@end

@implementation MNHistoryDetailCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self.bgImageView setImage:[UIImage imageNamed:IMAGE_NAME(@"history_outside_cell_detail")]];
}

- (void)setModel:(MNHistoryDetailModel *)model
{
    _model = model;
    
    self.nameLabel.text = model.hName;
    self.dataLabel.text = model.hDataString;
    self.unitLabel.text = model.hUnitString;
}

- (void)setSelected:(BOOL)selected
{
    if (self.selected == selected) return;
    
    [super setSelected:selected];
    
    if (selected == YES) {
        _bgImageView.alpha = 1;
        _nameLabel.textColor = [UIColor whiteColor];
        _dataLabel.textColor = [UIColor whiteColor];
        _unitLabel.textColor = [UIColor whiteColor];
    } else {
        _bgImageView.alpha = 0;
        _nameLabel.textColor = NAV_TEXT_COLOR;
        _dataLabel.textColor = NAV_TEXT_COLOR;
        _unitLabel.textColor = NAV_TEXT_COLOR;
    }
}

@end
