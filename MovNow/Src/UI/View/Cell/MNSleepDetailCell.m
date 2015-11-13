//
//  MNSleepDetailCell.m
//  Movnow
//
//  Created by LiuX on 15/5/14.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//

#import "MNSleepDetailCell.h"

@interface MNSleepDetailCell ()

@property (weak, nonatomic) IBOutlet UIView *insideBgView;
@property (weak, nonatomic) IBOutlet UIImageView *insideBgImageView;
@property (weak, nonatomic) IBOutlet UIImageView *insideIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *insideSleepTextLabel;

@property (weak, nonatomic) IBOutlet UIView *outsideBgView;
@property (weak, nonatomic) IBOutlet UIImageView *outsideBgImageView;
@property (weak, nonatomic) IBOutlet UIImageView *outsideIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *outsideTImeRangeLabel;
@property (weak, nonatomic) IBOutlet UILabel *outsideSleepLabel1;
@property (weak, nonatomic) IBOutlet UILabel *outsideSleepLabel2;
@property (weak, nonatomic) IBOutlet UILabel *outsideSleepLabel3;
@property (weak, nonatomic) IBOutlet UILabel *outsideSleepDataLabel1;
@property (weak, nonatomic) IBOutlet UILabel *outsideSleepDataLabel2;
@property (weak, nonatomic) IBOutlet UILabel *outsideSleepDataLabel3;

@end

@implementation MNSleepDetailCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.layer.cornerRadius = 10.f;
    self.clipsToBounds = YES;
    
    [self.insideBgImageView setImage:[UIImage imageNamed:IMAGE_NAME(@"history_inside_cell_detail")]];
    [self.insideIconImageView setImage:[UIImage imageNamed:IMAGE_NAME(@"history_sleep_cell_big")]];
    self.insideSleepTextLabel.text = NSLocalizedString(@"睡眠", nil);
    
    [self.outsideBgImageView setImage:[UIImage imageNamed:IMAGE_NAME(@"history_outside_cell_detail")]];
    [self.outsideIconImageView setImage:[UIImage imageNamed:IMAGE_NAME(@"history_sleep_cell_small")]];
    self.outsideTImeRangeLabel.text = @"21:00 - 9:00";
    self.outsideSleepLabel1.text = NSLocalizedString(@"睡眠时长", nil);
    self.outsideSleepLabel2.text = NSLocalizedString(@"深睡时长", nil);
    self.outsideSleepLabel3.text = NSLocalizedString(@"浅睡时长", nil);
}

-(void)setSelected:(BOOL)selected
{
    if (self.selected == selected) return;
    
    [super setSelected:selected];
    
    [UIView animateWithDuration:kAnimationInterval animations:^{
        if (selected == YES) {
            [self setTransform:CGAffineTransformIdentity];
        } else{
            [self setTransform:CGAffineTransformMakeScale(0.7, 0.7)];
        }
    }];
}

-(void)setTransform:(CGAffineTransform)transform
{
    [super setTransform:transform];
    
    self.outsideBgView.alpha = (self.selected ? 1:0);
    self.insideBgView.alpha = (self.selected ? 0:1);
}

@end
