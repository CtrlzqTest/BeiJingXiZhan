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
    self.backView.layer.cornerRadius = cornerRadius / 2.0;
    self.backView.clipsToBounds = YES;
    self.backView.backgroundColor = [UIColor colorWithRed:0.082 green:0.627 blue:0.824 alpha:1.000];
    
}

@end
