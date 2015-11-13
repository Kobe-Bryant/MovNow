//
//  SelectedTimeSection_ViewController.h
//  Q2
//
//  Created by MYBrother on 14-8-14.
//  Copyright (c) 2014年 MYBrother. All rights reserved.
//

@protocol SelectedSectionOfTimeDelagate <NSObject>

- (void)setSectionOfTimeLabelText:(NSString *)text;

@end

#import "MNBaseViewCtrl.h"

@interface MNSelectedTimeSectionVC : MNBaseViewCtrl
@property (nonatomic,weak)id <SelectedSectionOfTimeDelagate> delegate;

@end
