//
//  MsgType1TabCell.h
//  XiZhanApp
//
//  Created by zhangqiang on 16/5/14.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MenuModel;
@interface MsgType1TabCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *pointImgView;

- (void)writeDataWithModel:(MenuModel *)msgModel;

@end
