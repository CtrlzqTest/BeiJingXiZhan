//
//  ParkMsgModel.h
//  XiZhanApp
//
//  Created by zhangqiang on 16/6/14.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParkMsgModel : NSObject

@property(nonatomic,strong)NSString *ParkID;
@property(nonatomic,strong)NSString *CarCount;
@property(nonatomic,copy)NSString *createtime;
@property(nonatomic,copy)NSString *CreateUser;

@end
