//
//  MsgType1TabCell.m
//  XiZhanApp
//
//  Created by zhangqiang on 16/5/14.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "MsgType1TabCell.h"
#import "MenuModel.h"

@implementation MsgType1TabCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)writeDataWithModel:(MenuModel *)msgModel {
    
    self.titleLabel.text = msgModel.menuTitle;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
