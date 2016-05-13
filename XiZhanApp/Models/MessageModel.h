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
@property(nonatomic,assign)long msgdate;
@property(nonatomic,strong)NSString *msgcontent;
@property(nonatomic,strong)NSString *msgtype;
@property(nonatomic,strong)NSString *msgId;
@property(nonatomic,assign)BOOL isread;

+(MessageModel *)shareTestModel;

@end
