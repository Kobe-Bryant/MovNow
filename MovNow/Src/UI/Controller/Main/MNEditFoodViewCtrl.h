//
//  MNEditFoodViewCtrl.h
//  Movnow
//
//  Created by LiuX on 15/5/11.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//

#import "MNBaseViewCtrl.h"
@class MNCalorieModel;

typedef NS_ENUM(NSInteger, FoodEditType){
    FoodEditTypeAdd, //添加
    FoodEditTypeChange //修改
};

@interface MNEditFoodViewCtrl : MNBaseViewCtrl

@property (nonatomic,assign) FoodEditType editType;
@property (nonatomic,strong) MNCalorieModel *cModel;
@property (nonatomic,strong) NSIndexPath *changeIndexPath;

@property (nonatomic,copy) void(^didChangeCalorieFood)(MNCalorieModel *cModel,NSIndexPath *changeIndexPath);
@property (nonatomic,copy) void(^didAddCalorieFood)(MNCalorieModel *cModel);

@end
