//
//  MNEditOrAddViewCtrl.h
//  Movnow
//
//  Created by L-Q on 15/4/27.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//
typedef NS_ENUM(NSInteger,EditRemindTimeType){
    EditRemindTime_Add = 0,
    EditRemindTime_Edit
};

#import "MNBaseViewCtrl.h"

typedef void (^RemindsArrBlock)(NSArray *RemindsArr);


@interface MNEditOrAddViewCtrl : MNBaseViewCtrl

//@property (nonatomic ,strong) NSMutableArray *tempRemindArr;//临时存储提醒事件的数组
@property (nonatomic,assign) EditRemindTimeType editType;// 添加或编辑状态
@property (nonatomic,assign) NSInteger index;

@end
