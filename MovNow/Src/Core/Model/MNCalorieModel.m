//
//  MNCalorieModel.m
//  Movnow
//
//  Created by LiuX on 15/5/11.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//

#import "MNCalorieModel.h"

@implementation MNCalorieModel

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_cImageData forKey:@"cImageData"];
    [aCoder encodeObject:_cFoodName forKey:@"cFoodName"];
    [aCoder encodeObject:_cCalorieNumber forKey:@"cCalorieNumber"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super init]){
        _cImageData = [aDecoder decodeObjectForKey:@"cImageData"];
        _cFoodName = [aDecoder decodeObjectForKey:@"cFoodName"];
        _cCalorieNumber = [aDecoder decodeObjectForKey:@"cCalorieNumber"];
    }
    return  self;
}

+ (MNCalorieModel *)modelWithImageData:(NSData *)data name:(NSString *)name calorieNumber:(NSNumber *)number
{
    MNCalorieModel *model = [[MNCalorieModel alloc]init];
    model.cImageData = data;
    model.cFoodName = name;
    model.cCalorieNumber = number;
    
    return model;
}


+ (instancetype)modelWith: (NSDictionary *) dict{
    MNCalorieModel *model = [[MNCalorieModel alloc] init];
//    model setValue:<#(id)#> forKey:<#(NSString *)#>
    
    return model;
}
@end
