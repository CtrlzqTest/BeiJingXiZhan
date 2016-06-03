//
//  TaxiMsgModel.h
//  XiZhanApp
//
//  Created by zhangqiang on 16/6/2.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TaxiMsgModel : NSObject

@property(nonatomic,strong)NSString *taxiRankName;
@property(nonatomic,strong)NSString *areaID;
@property(nonatomic,strong)NSString *taxiCount;
@property(nonatomic,copy)NSString *laneCount;
@property(nonatomic,copy)NSString *peopleCount;
@property(nonatomic,copy)NSString *stationId;

@end
