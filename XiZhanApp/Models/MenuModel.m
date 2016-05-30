//
//  MenuModel.m
//  XiZhanApp
//
//  Created by zhangqiang on 16/5/13.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "MenuModel.h"

@implementation MenuModel

+(void)load {
    [super load];
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{
             @"menuId" : @"ID",
             @"menuType" : @"Alias",
             @"imgUrl" : @"ImageUrl",
             };
}

@end
