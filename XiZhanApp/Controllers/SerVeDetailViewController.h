//
//  SerVeDetailViewController.h
//  XiZhanApp
//
//  Created by zhangqiang on 16/5/11.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "BaseViewController.h"

@class MessageModel;
@interface SerVeDetailViewController : BaseViewController
@property(nonatomic,strong)MessageModel *model;

@property(nonatomic,assign)NSInteger isSkip;
@end
