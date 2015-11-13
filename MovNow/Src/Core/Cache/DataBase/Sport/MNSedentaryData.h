//
//  MNSedentaryData.h
//  Movnow
//
//  Created by baoyx on 15/5/8.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MNSedentaryData : NSObject

-(void)updateWithSedentary:(NSString *)sedentary withInterval:(NSNumber *)interval withRemindType:(NSNumber *)remindType;
-(NSDictionary *)select;

@end
