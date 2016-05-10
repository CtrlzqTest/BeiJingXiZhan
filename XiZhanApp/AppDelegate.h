//
//  AppDelegate.h
//  XiZhanApp
//
//  Created by zhangqiang on 16/5/9.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LeftSlideViewController;
@class BaseNaviViewController;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) LeftSlideViewController *leftSliderVC;
@property(nonatomic,strong)BaseNaviViewController *mainNavi;

@end

