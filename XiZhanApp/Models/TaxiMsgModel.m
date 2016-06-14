//
//  TaxiMsgModel.m
//  XiZhanApp
//
//  Created by zhangqiang on 16/6/2.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "TaxiMsgModel.h"

@implementation TaxiMsgModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{
                @"stationId" :  @"ID"
             };
}

@end
