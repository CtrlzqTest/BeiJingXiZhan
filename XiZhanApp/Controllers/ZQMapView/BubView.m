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
    self.bubImage.layer.cornerRadius = (80 - 16) / 2.0;
    self.bubImage.contentMode = UIViewContentModeScaleAspectFill;
    self.bubImage.backgroundColor = mainColor;
    self.bubImage.image = [UIImage imageNamed:@"default"];
}

- (void)setDataWithModel:(MapModel *)model {
    
    self.titleLabel.text = model.title;
//    self.descLabel.text = model.describe;
    if (model.Imagesurl.length > 0) {
        NSString *imgStr = [BaseXiZhanImgAPI stringByAppendingString:model.Imagesurl];
        [self.bubImage sd_setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:nil];
    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
