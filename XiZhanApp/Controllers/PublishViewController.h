//
//  PublishViewController.h
//  XiZhanApp
//
//  Created by zhangqiang on 16/5/13.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "LQPhotoPickerViewController.h"
#import "MenuModel.h"
@interface PublishViewController : LQPhotoPickerViewController

@property(nonatomic,copy)NSString *parentIdString;
@property(nonatomic,strong)MenuModel *menuModel;

@end
