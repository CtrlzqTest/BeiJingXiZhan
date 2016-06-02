//
//  PublishViewController.h
//  XiZhanApp
//
//  Created by zhangqiang on 16/5/13.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "LQPhotoPickerViewController.h"
#import "MenuModel.h"
@class MessageModel;
// 通知列表界面刷新
@protocol PublishViewControllerDelegate<NSObject>

- (void)noticeTableViewRefresh:(MessageModel *)model;

@end

@interface PublishViewController : LQPhotoPickerViewController

@property(nonatomic,copy)NSString *parentIdString;
@property(nonatomic,strong)MenuModel *menuModel;
@property(nonatomic,assign)id<PublishViewControllerDelegate> delegate;

@end
