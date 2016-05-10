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

@end
