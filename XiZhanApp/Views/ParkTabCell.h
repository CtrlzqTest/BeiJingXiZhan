//
//  ParkTabCell.h
//  XiZhanApp
//
//  Created by zhangqiang on 16/6/14.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParkMsgModel.h"

static NSString *cellId = @"parkCellId";
static CGFloat cellHeight = 100.0;

@interface ParkTabCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *parkLabel;
@property (weak, nonatomic) IBOutlet UILabel *carCountLabel;

- (void)writeDataWithModel:(ParkMsgModel *)model;

@end
