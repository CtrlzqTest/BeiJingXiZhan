//
//  BubView.m
//  XiZhanApp
//
//  Created by zhangqiang on 16/7/15.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "BubView.h"
#import "MapModel.h"
#import <UIImageView+WebCache.h>

@implementation BubView

-(void)awakeFromNib {
    
    self.layer.cornerRadius = 8;
    
}

- (void)setDataWithModel:(MapModel *)model {
    
    self.titleLabel.text = model.title;
    [self.bubImage sd_setImageWithURL:[NSURL URLWithString:model.Imagesurl] placeholderImage:nil];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
