//
//  MenuType2TabCell.m
//  XiZhanApp
//
//  Created by zhangqiang on 16/5/31.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "MenuType2TabCell.h"
#import "MenuModel.h"

@implementation MenuType2TabCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)writeDataWithModel:(MenuModel *)menuModel {
    
    self.titleLabel.text = menuModel.menuTitle;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
