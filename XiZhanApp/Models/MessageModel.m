//
//  MessageModel.m
//  XiZhanApp
//
//  Created by zhangqiang on 16/5/12.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "MessageModel.h"

static MessageModel *testModel = nil;
@implementation MessageModel

+(MessageModel *)shareTestModel {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        testModel = [[MessageModel alloc] init];
    });
    return testModel;
}

-(instancetype)init {
    if (self = [super init]) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [MessageModel setUniqueProperty:@"msgdate"];
        });
    }
    return self;
}

+(void)load {
    [[ZQDatabaseManager shareDatabaseManager] createTableWithCalss:[MessageModel class]];
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{
             @"msgid" : @"id",
             @"msgtitle" : @"msgTitle",
             @"msgdate" : @"msgDate",
             @"msgcontent" : @"msgContent",
             @"msgtype" : @"msgType",
             @"isread" : @"isRead",
             @"imgurl":@"imgUrl"
             };
}

// 获取本地数据
-(NSArray *)getAllDataFromLocal {
    NSArray *tempArray = [super getAllDataFromLocal];
    NSMutableArray *resultArray = [NSMutableArray array];
    for (NSDictionary *dict in tempArray) {
        MessageModel *model = [[MessageModel alloc] init];
        [model setValuesForKeysWithDictionary:dict];
        [resultArray addObject:model];
    }
    return resultArray;
}

// 条件查询
-(NSArray *)getDataWithCondition:(NSString *)condition {
    NSArray *tempArray = [super getDataWithCondition:condition];
    NSMutableArray *resultArray = [NSMutableArray array];
    for (NSDictionary *dict in tempArray) {
        MessageModel *model = [[MessageModel alloc] init];
        [model setValuesForKeysWithDictionary:dict];
        [resultArray addObject:model];
    }
    return resultArray;
}

// 分页
- (NSArray *)getDataWithPage:(NSInteger )page {
    NSArray *tempArray = [super getDataWithPage:page];
    NSMutableArray *resultArray = [NSMutableArray array];
    for (NSDictionary *dict in tempArray) {
        MessageModel *model = [[MessageModel alloc] init];
        [model setValuesForKeysWithDictionary:dict];
        [resultArray addObject:model];
    }
    return resultArray;
}

@end
