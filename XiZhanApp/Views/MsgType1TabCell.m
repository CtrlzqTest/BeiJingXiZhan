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
#import <UIImageView+WebCache.h>

@interface MsgType1TabCell()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *back_Top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *back_Buttom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *label_Height;

@end

@implementation MsgType1TabCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    CGFloat height = cellHeight * KHeight / 860.0;
    CGFloat cornerRadius = (height - 10) / 2.0;
    self.iconImgView.layer.cornerRadius = cornerRadius;
    self.iconImgView.clipsToBounds = YES;
    
    self.label_Height.constant = 21 * ProportionHeight;
    self.titleLabel.font = [UIFont systemFontOfSize:17.0 * ProportionWidth];
    self.subTitleLabel.font = [UIFont systemFontOfSize:17.0 * ProportionWidth];
    
}

- (void)writeDataWithModel:(MessageModel *)msgModel {
    
    if (msgModel.isread) {
        self.pointImgView.hidden = YES;
    }else {
        self.pointImgView.hidden = NO;
    }
    self.titleLabel.text = msgModel.msgtitle;
    NSArray *array = [msgModel.imgurl componentsSeparatedByString:@","];
    NSString *urlStr = [BaseXiZhanImgAPI stringByAppendingString:[array firstObject]];
    [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"default"]];
    self.subTitleLabel.text = msgModel.msgdatestr;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
