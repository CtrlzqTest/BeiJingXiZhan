//
//  MenuModel.h
//  XiZhanApp
//
//  Created by zhangqiang on 16/5/13.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "ZQDatabaseModel.h"

@interface MenuModel : ZQDatabaseModel

@property(nonatomic,copy)NSString *menuId;
@property(nonatomic,copy)NSString *menuTitle;
@property(nonatomic,copy)NSString *imgUrl;
@property(nonatomic,copy)NSString *alias;
@property(nonatomic,copy)NSString *imageName;

@end
