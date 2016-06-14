//
//  TaxiMsgModel.h
//  XiZhanApp
//
//  Created by zhangqiang on 16/6/2.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TaxiMsgModel : NSObject

@property(nonatomic,strong)NSString *TaxiRankID;
@property(nonatomic,strong)NSString *TaxiCount;
@property(nonatomic,copy)NSString *PeopleCount;
@property(nonatomic,copy)NSString *stationId;
@property(nonatomic,copy)NSString *CreateUser;
@property(nonatomic,copy)NSString *Name;
@end
