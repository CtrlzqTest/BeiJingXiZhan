//
//  MsgType1TabCell.h
//  XiZhanApp
//
//  Created by zhangqiang on 16/5/14.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MessageModel;
@class TaxiMsgModel;

static CGFloat cellHeight = 120.0;
static NSString *cellIndentifer = @"msgType1";

@interface MsgType1TabCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *pointImgView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;

/**
 *  赋值
 *
 *  @param msgModel msgModel
 */
- (void)writeDataWithModel:(MessageModel *)msgModel;

@end
