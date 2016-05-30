//
//  InfoClassifyViewController.h
//  XiZhanApp
//
//  Created by zhangqiang on 16/5/27.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "BaseViewController.h"
#import "MenuModel.h"

@interface InfoClassifyViewController : BaseViewController

@property (nonatomic,copy)NSString *msgType;
@property (nonatomic,copy)NSString *parentIdString;
@property(nonatomic,strong)MenuModel *menuModel;
@property(nonatomic,assign)NSInteger isSkip;

@end
