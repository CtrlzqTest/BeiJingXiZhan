//
//  ServeTabCell.m
//  XiZhanApp
//
//  Created by zhangqiang on 16/5/10.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "ServeTabCell.h"
#import "MessageModel.h"

@implementation ServeTabCell

- (void)awakeFromNib {
    [super awakeFromNib];
    CGFloat cornerRadius = (cellHeight - 10) / 2.0;
    self.imgView.layer.cornerRadius = cornerRadius;
    self.imgView.clipsToBounds = YES;
    [self.contentView sendSubviewToBack:self.backImgView];
}

- (void)writeDataWithModel:(MessageModel *)msgModel {
    
    self.titleLabel.text = msgModel.msgtitle;
    if (msgModel.isread) {
        self.redPointImgView.hidden = YES;
    }else {
        self.redPointImgView.hidden = NO;
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
