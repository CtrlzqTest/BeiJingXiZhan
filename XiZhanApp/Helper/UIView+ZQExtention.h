//
//  UIView+ZQExtention.h
//  XiZhanApp
//
//  Created by zhangqiang on 16/5/10.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ZQExtention)

- (void)setBorderWidth:(CGFloat )borderWidth cornerRadius:(CGFloat)cornerRadius;


/**
 *  设置渐变颜色
 *
 *  @param startColor 其实颜色
 *  @param endColor   终止颜色
 */
- (void)setGradientLayerStartColor:(UIColor *)startColor endColor:(UIColor *)endColor;

@end
