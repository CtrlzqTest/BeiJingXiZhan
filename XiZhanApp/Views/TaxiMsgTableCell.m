//
//  TaxiMsgTableCell.m
//  XiZhanApp
//
//  Created by zhangqiang on 16/6/3.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "TaxiMsgTableCell.h"
#import "MessageModel.h"
#import "TaxiMsgModel.h"

@implementation TaxiMsgTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)writeDataWithModel:(TaxiMsgModel *)msgModel
{
    self.layerLabel.layer.cornerRadius = 30.0;
    self.layerLabel.layer.masksToBounds = YES;
    self.layerLabel.layer.borderWidth = 2.0;
    self.layerLabel.layer.borderColor = colorref;
    
    self.taxiStationNameLabel.textColor = mainColor;
    self.taxiStationNameLabel.text = msgModel.taxiRankName;
    self.taxiCountLabel.textColor = mainColor;
    self.taxiCountLabel.text = msgModel.taxiCount;
    
    self.taxiCountLabel.layer.cornerRadius = 15.0;
    self.taxiCountLabel.layer.masksToBounds = YES;
    self.taxiCountLabel.layer.borderWidth = 2.0;
    self.taxiCountLabel.layer.borderColor = colorref;
    
    self.peopleCountLabel.textColor = mainColor;
    
    self.peopleCountLabel.text = msgModel.peopleCount;
    self.peopleCountLabel.layer.cornerRadius = 15.0;
    self.peopleCountLabel.layer.masksToBounds = YES;
    self.peopleCountLabel.layer.borderWidth = 2.0;
    self.peopleCountLabel.layer.borderColor = colorref;
}
@end
