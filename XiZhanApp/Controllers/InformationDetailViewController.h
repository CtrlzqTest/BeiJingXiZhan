//
//  InformationDetailViewController.h
//  XiZhanApp
//
//  Created by zhangqiang on 16/5/11.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "BaseViewController.h"

@class MessageModel;
@interface InformationDetailViewController : BaseViewController
@property(nonatomic,copy)NSString *webUrl;

@property(nonatomic,strong)MessageModel *model;

@end
