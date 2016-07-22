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

// 无数据显示图片
- (void)addNodataViewInView:(UIView *)view;

// 移除没数据图片
- (void)removeNodataView;

// 点击刷新数据
- (void)tapNoDataView;

/** 消失键盘*/
- (void)resignKeyBoardInView:(UIView *)view;
@end
