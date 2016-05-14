//
//  ServeInfoViewController.h
//  XiZhanApp
//
//  Created by zhangqiang on 16/5/10.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "BaseViewController.h"
#import "MenuModel.h"

@interface ServeInfoViewController : BaseViewController

@property(nonatomic,copy)NSString *parentIdString;
@property(nonatomic,copy)NSString *msgType;
@property(nonatomic,strong)MenuModel *menuModel;
@property(nonatomic,assign)NSInteger isSkip;
@end
