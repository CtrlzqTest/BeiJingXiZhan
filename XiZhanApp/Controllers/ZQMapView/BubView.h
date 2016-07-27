//
//  BubView.h
//  XiZhanApp
//
//  Created by zhangqiang on 16/7/15.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MapModel;
@interface BubView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *bubImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

/**
 *  气泡赋值
 *
 *  @param model 模型
 */
- (void)setDataWithModel:(MapModel *)model;

@end
