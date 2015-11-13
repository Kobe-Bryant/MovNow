//
//  MNUserModel.h
//  Movnow
//
//  Created by baoyx on 15/4/15.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
@interface MNUserModel : JSONModel
+(MNUserModel *)shareInstance;
@property (nonatomic,copy) NSString *nickName; //呢称
@property (nonatomic,copy) NSNumber *sex;      //性别  1 男  0 女
@property (nonatomic,copy) NSString *signature; //签名
@property (nonatomic,copy) NSString *birthday;  //生日 yyyyMMdd
@property (nonatomic,copy) NSNumber *height;   //身高 cm
@property (nonatomic,copy) NSNumber *weight;   //体重 g
@property (nonatomic,copy) NSNumber *proId;    //省份代码
@property (nonatomic,copy) NSNumber *cityId;   //城市代码
@property (nonatomic,copy) NSNumber *districtId; //区域代码
@property (nonatomic,copy) NSNumber *userId;   //用户id
@property (nonatomic,copy) NSString *avatar;   //头像url地址
-(void)gainUser:(NSDictionary *)user;
-(void)saveCache;
-(void)clearCache;
@end
