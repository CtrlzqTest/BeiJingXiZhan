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
@property(nonatomic,assign)NSInteger CarCount;
@property(nonatomic,copy)NSString *createtime;
@property(nonatomic,copy)NSString *CreateUser;
@property(nonatomic,assign)NSInteger MaxCarCount;
@property(nonatomic,copy)NSString *Name;
@property(nonatomic,copy)NSString *msgID;

@end
