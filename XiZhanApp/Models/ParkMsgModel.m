//
//  ParkMsgModel.m
//  XiZhanApp
//
//  Created by zhangqiang on 16/6/14.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "ParkMsgModel.h"

@implementation ParkMsgModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{
             @"stationId" :  @"ID"
             };
}

@end
