//
//  TaxiMsgModel.m
//  XiZhanApp
//
//  Created by zhangqiang on 16/6/2.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "TaxiMsgModel.h"

@implementation TaxiMsgModel

+(void)load {
    
    [[ZQDatabaseManager shareDatabaseManager] createTableWithCalss:[TaxiMsgModel class]];
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{
             @"msgid" : @"ID",
             @"msgtitle" : @"Title",
             @"msgdatestr" : @"CreateTime",
             @"msgcontent" : @"Content",
             @"isread" : @"isRead",
             @"imgurl":@"ImageUrl",
             @"nodeid":@"NodeID"
             };
}

@end
