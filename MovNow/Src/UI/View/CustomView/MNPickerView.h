//
//  MNPickerView.h
//  Q2
//
//  Created by hebing on 14-9-18.
//  Copyright (c) 2014年 hebing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MNPickerScrollView : UITableView

@property NSInteger tagLastSelected;

- (void)dehighlightLastCell;
- (void)highlightCellWithIndexPathRow:(NSUInteger)indexPathRow;

@end


@interface MNPickerView : UIView <UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>

//@property (nonatomic, strong, readonly) NSString *value;
@property (nonatomic, copy) NSString *value;

- (id)initWithFrame:(CGRect)frame andDataArr:(NSArray *)dateArr;

@end
