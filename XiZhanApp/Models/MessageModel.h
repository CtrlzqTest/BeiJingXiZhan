//
//  MessageModel.h
//  XiZhanApp
//
//  Created by zhangqiang on 16/5/12.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZQDatabaseModel.h"

@interface MessageModel : ZQDatabaseModel

@property(nonatomic,strong)NSString *msgtitle;
@property(nonatomic,assign)long long msgdate;
@property(nonatomic,strong)NSString *msgcontent;
@property(nonatomic,strong)NSString *usertype;
@property(nonatomic,strong)NSString *msgid;
@property(nonatomic,copy)NSString *nodeid;
@property(nonatomic,assign)bool isread;
@property(nonatomic,assign)bool issign;
@property(nonatomic,copy)NSString *imgurl;
@property(nonatomic,copy)NSString *userid;
@property(nonatomic,copy)NSString *msgdatestr;
@property(nonatomic,copy)NSString *linkurl;
@property(nonatomic,copy)NSString *submitclient;

+(MessageModel *)shareTestModel;

@end
