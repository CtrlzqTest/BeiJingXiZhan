//
//  MainCollCell.m
//  XiZhanApp
//
//  Created by zhangqiang on 16/5/10.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "MainCollCell.h"

@implementation MainCollCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    CGFloat width = KWidth / 2.0 - 40;
    CGFloat cornerRadius  = width - self.headLeft.constant * 2;
    self.headImageView.layer.cornerRadius = cornerRadius / 2.0;
}

@end
