//
//  BaseViewController.h
//  91Demo
//
//  Created by zhangqiang on 16/1/15.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    RefreshTypeDrag,
    RefreshTypePull,
} RefreshType;

@interface BaseViewController : UIViewController

// 侧滑显示菜单开关
- (void)canSlideMenu:(BOOL )isSlide;

@end
