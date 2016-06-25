//
//  MyInformationsViewController.h
//  XiZhanApp
//
//  Created by zhangqiang on 16/5/10.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "BaseViewController.h"
#import "MenuModel.h"
@interface MyInformationsViewController : BaseViewController

@property (nonatomic,copy)NSString *msgType;
@property (nonatomic,copy)NSString *parentIdString;
@property(nonatomic,strong)MenuModel *menuModel;
@property (nonatomic,assign)BOOL isRemoteNotice; // 是否需要刷新数据

// 通知刷新
- (void)noticeRefreshData;

@end
