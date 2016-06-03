//
//  MsgType1TabCell.m
//  XiZhanApp
//
//  Created by zhangqiang on 16/5/14.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "MsgType1TabCell.h"
#import "MessageModel.h"
#import "TaxiMsgModel.h"

@implementation MsgType1TabCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)writeDataWithModel:(MessageModel *)msgModel {
    
    if (msgModel.isread) {
        self.pointImgView.hidden = YES;
    }else {
        self.pointImgView.hidden = NO;
    }
    self.titleLabel.text = msgModel.msgtitle;
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
