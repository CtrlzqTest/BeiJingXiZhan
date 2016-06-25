//
//  ParkTabCell.m
//  XiZhanApp
//
//  Created by zhangqiang on 16/6/14.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "ParkTabCell.h"

@implementation ParkTabCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.carCountLabel.layer.cornerRadius = 5.0;
    self.carCountLabel.layer.masksToBounds = YES;
    self.carCountLabel.layer.borderWidth = 2.0;
    self.carCountLabel.layer.borderColor = colorref;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}

- (void)writeDataWithModel:(ParkMsgModel *)model {
    
    self.nameLabel.text = model.Name;
    self.carCountLabel.text = [NSString stringWithFormat:@"%ld",model.MaxCarCount - model.CarCount];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
