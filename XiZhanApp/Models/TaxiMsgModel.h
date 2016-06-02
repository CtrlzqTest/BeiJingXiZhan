//
//  TaxiMsgModel.h
//  XiZhanApp
//
//  Created by zhangqiang on 16/6/2.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "ZQDatabaseModel.h"

@interface TaxiMsgModel : ZQDatabaseModel

@property(nonatomic,strong)NSString *taxiMsgName;
@property(nonatomic,assign)long msgdate;
@property(nonatomic,strong)NSString *msgcontent;
//@property(nonatomic,strong)NSString *msgtype;
@property(nonatomic,strong)NSString *msgid;
@property(nonatomic,copy)NSString *nodeid;
@property(nonatomic,assign)BOOL isread;
@property(nonatomic,copy)NSString *imgurl;
@property(nonatomic,copy)NSString *userid;
@property(nonatomic,copy)NSString *msgdatestr;

@end
