//
//  ImgCell.m
//  JinYeFeiLinOA
//
//  Created by zhangqiang on 16/4/28.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "ImgCell.h"

@implementation ImgCell

- (void)awakeFromNib {
    // Initialization code
    self.imgOfCell.layer.cornerRadius = 100*ProportionWidth / 2.0;
    self.imgOfCell.clipsToBounds = YES;
    
}

@end
