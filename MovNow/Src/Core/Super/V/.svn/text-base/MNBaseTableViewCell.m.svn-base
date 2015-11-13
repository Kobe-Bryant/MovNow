//
//  MNBaseTableViewCell.m
//  MinLED
//
//  Created by Yigol on 14/12/10.
//  Copyright (c) 2014年 injoinow. All rights reserved.
//

#import "MNBaseTableViewCell.h"

@implementation MNBaseTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.textLabel.font = TITLE_FONT;
    self.textLabel.textColor = NAV_TEXT_COLOR;
    self.selectionStyle = UITableViewCellSelectionStyleBlue;
    self.backgroundColor = CELL_BG_COLOR;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.textLabel.font = TITLE_FONT;
        self.textLabel.textColor = NAV_TEXT_COLOR;
        self.selectionStyle = UITableViewCellSelectionStyleBlue;
        self.backgroundColor = CELL_BG_COLOR;
    }
    
    return self;
}

@end
