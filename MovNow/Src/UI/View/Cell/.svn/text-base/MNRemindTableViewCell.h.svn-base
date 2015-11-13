//
//  MNRemindTableViewCell.h
//  Movnow
//
//  Created by L-Q on 15/4/25.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MNRemindTableViewCell : UITableViewCell{

    void(^onEditButtonPress)();
    void(^onDeleteButtonPress)();

}

@property (weak, nonatomic) IBOutlet UIButton *editBUtton;

@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@property (weak, nonatomic) IBOutlet UILabel *drinkWaterTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *weekLabel;

- (void)setOnEditButtonPress:(void (^)())_onEditButtonPress;
- (void)setOnDeleteButtonPress:(void(^)())_onDeleteButtonPress;



@end
