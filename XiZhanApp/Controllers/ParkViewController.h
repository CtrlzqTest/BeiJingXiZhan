//
//  ParkViewController.h
//  XiZhanApp
//
//  Created by zhangqiang on 16/6/14.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "BaseViewController.h"

static NSString *parkVCId = @"parkViewCrotroller";
@class MenuModel;
@interface ParkViewController : BaseViewController

@property(nonatomic,strong)MenuModel *menuModel;

@end
