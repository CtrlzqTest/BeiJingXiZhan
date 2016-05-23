//
//  UIView+ZQExtention.m
//  XiZhanApp
//
//  Created by zhangqiang on 16/5/10.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "UIView+ZQExtention.h"

@implementation UIView (ZQExtention)

- (void)setBorderWidth:(CGFloat )borderWidth cornerRadius:(CGFloat)cornerRadius {
    
    self.layer.borderWidth = borderWidth;
    self.layer.cornerRadius = cornerRadius;
    
}

// 颜色渐变图层
- (void)setGradientLayerStartColor:(UIColor *)startColor endColor:(UIColor *)endColor {
    
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, width, height + 20);
    [gradientLayer setColors:[NSArray arrayWithObjects:(id)(startColor.CGColor),(id)(endColor.CGColor), nil]];
    // 渐变方式,一般X相同,渐变方式为上到下(或下到上),Y相同的话就是左到右(或右到左)
    gradientLayer.startPoint = CGPointMake(0, 0.5);
    gradientLayer.endPoint = CGPointMake(1, 0.5);
    CALayer *layer = self.layer.sublayers[0];
    [layer addSublayer:gradientLayer];
    
}

@end
