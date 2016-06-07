//
//  MenuType2TabCell.m
//  XiZhanApp
//
//  Created by zhangqiang on 16/5/31.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "MenuType2TabCell.h"
#import "MenuModel.h"
#import <UIImageView+WebCache.h>

@implementation MenuType2TabCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.pointImgView.hidden = YES;
    // Initialization code
}

- (void)writeDataWithModel:(MenuModel *)menuModel {
    
    self.titleLabel.text = menuModel.menuTitle;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"http://222.240.172.197/app_31/",menuModel.imgUrl]] placeholderImage:[UIImage imageNamed:@"default"]];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
