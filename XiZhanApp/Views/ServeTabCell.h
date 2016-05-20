//
//  ServeTabCell.h
//  XiZhanApp
//
//  Created by zhangqiang on 16/5/10.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MessageModel;

static CGFloat cellHeight = 100.0;

@interface ServeTabCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *msgLabel;
@property (weak, nonatomic) IBOutlet UIImageView *redPointImgView;
@property (weak, nonatomic) IBOutlet UIImageView *backImgView;

- (void)writeDataWithModel:(MessageModel *)msgModel;

@end
