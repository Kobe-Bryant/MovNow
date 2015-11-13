//
//  MNBaseIconView.m
//  Movnow
//
//  Created by LiuX on 15/4/17.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//

#import "MNBaseIconView.h"

@implementation MNBaseIconView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.layer.cornerRadius = self.frame.size.width/2.f;
        self.clipsToBounds = YES;
    }
    return self;
}

-(void)awakeFromNib
{
    self.layer.cornerRadius = self.frame.size.width/2.f;
    self.clipsToBounds = YES;
}

@end
