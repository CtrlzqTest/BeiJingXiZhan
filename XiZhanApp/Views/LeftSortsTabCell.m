//
//  LeftSortsTabCell.m
//  XiZhanApp
//
//  Created by zhangqiang on 16/5/11.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "LeftSortsTabCell.h"

@implementation LeftSortsTabCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor colorWithRed:0.082 green:0.624 blue:0.820 alpha:1.000];
    self.selectedBackgroundView = view;
    self.titleLabel.textColor = [UIColor grayColor];
    self.titleLabel.font = [UIFont systemFontOfSize:20.0f * ProportionWidth];
    self.rightImgView.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
