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
static NSString *cellIndentifer = @"msgType1";

@interface MsgType1TabCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *pointImgView;

/**
 *  赋值
 *
 *  @param msgModel msgModel
 */
- (void)writeDataWithModel:(MessageModel *)msgModel;

/**
 *  根据出租车消息赋值
 *
 *  @param taxiModel taxiModel description
 */
- (void)writeDataWithTaxiModel:(TaxiMsgModel *)taxiModel;
@end
