//
//  MNWeekPicker.m
//  Movnow
//
//  Created by L-Q on 15/4/27.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//

#import "MNWeekPicker.h"

NSMutableArray *_valueArr;

@implementation MNWeekPicker

- (id)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        
        self.clipsToBounds = YES;
        
        UILabel *title;
        title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 290, 17)];
        title.textColor = [UIColor colorWithRed:98/255.0 green:118/255.0 blue:128/255.0 alpha:1.0];
        title.font = [UIFont systemFontOfSize:16];
        title.text = NSLocalizedString( @"请选择重复周期",nil);
        [self addSubview:title];
        
        _valueArr = [[NSMutableArray alloc] initWithCapacity:7];
        
        NSArray *arr = @[NSLocalizedString(@"日",@"Sun"),NSLocalizedString(@"一",@"Mon"),NSLocalizedString(@"二",@"Tue"), NSLocalizedString(@"三",@"Wed" ), NSLocalizedString(@"四",@"Thu"), NSLocalizedString(@"五",@"Fri" ), NSLocalizedString(@"六",@"Sat")];
        for (int i = 0; i < 7; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(i*41.75, 25, 39.5, 45);
            [button setTitle:arr[i] forState:UIControlStateNormal];
            button.tag = i;
            
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [button setTitleColor:[UIColor colorWithRed:85.0/255 green:99.0/255 blue:124.0/255 alpha:1.0] forState:UIControlStateNormal];
            
            [button setBackgroundImage:[UIImage imageNamed:@"提醒-闹钟_重复周期-.png"] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:@"提醒-闹钟_重复周期-中.png"] forState:UIControlStateSelected];
            
            [button addTarget:self action:@selector(weekPickerValueChange:) forControlEvents:UIControlEventTouchUpInside];
            
            if (i == 0 || i == 6) {
                button.selected = NO;
            } else {
                button.selected = YES;
            }
            [_valueArr addObject:[NSNumber numberWithBool:button.selected]];
            
            [self addSubview:button];
        }
    }
    return self;
}


- (void)weekPickerValueChange:(UIButton *)button{
    button.selected = !button.selected;
    [_valueArr replaceObjectAtIndex:button.tag withObject:[NSNumber numberWithBool:button.selected]];
    //    [self.delegate weekPickerSelectedValue:_valueArr];
    
}


- (NSArray *)getWeekArr{
    return _valueArr;
}



@end
