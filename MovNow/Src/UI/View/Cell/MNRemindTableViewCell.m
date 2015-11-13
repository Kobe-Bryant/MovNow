//
//  MNRemindTableViewCell.m
//  Movnow
//
//  Created by L-Q on 15/4/25.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//

#import "MNRemindTableViewCell.h"

@implementation MNRemindTableViewCell

- (void)awakeFromNib {
    // Initialization code
}


- (void)setOnEditButtonPress:(void (^)())_onEditButtonPress{
    onEditButtonPress = _onEditButtonPress;
}

- (void)setOnDeleteButtonPress:(void (^)())_onDeleteButtonPress{
    onDeleteButtonPress = _onDeleteButtonPress;
}

- (IBAction)onEditButtonPress:(UIButton *)sender {
    if (onEditButtonPress != NULL) {
        onEditButtonPress();
    }
}
- (IBAction)onDeleteButtonPress:(id)sender {
    if (onDeleteButtonPress) {
        onDeleteButtonPress();
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}













@end
