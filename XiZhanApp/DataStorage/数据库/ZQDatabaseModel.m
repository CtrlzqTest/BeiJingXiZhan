//
//  ZQDatabaseModel.m
//  SqliteDemo
//
//  Created by zhangqiang on 15/8/11.
//  Copyright (c) 2015年 zhangqiang. All rights reserved.
//

#import "ZQDatabaseModel.h"

@implementation ZQDatabaseModel
-(instancetype)init
{
    self = [super init];
    if (self) {
//        static dispatch_once_t onceToken;
//        dispatch_once(&onceToken, ^{
//            [[ZQDatabaseManager shareDatabaseManager] createTableWithCalss:[self class]];
//        });
    }
    return self;
}

+(void)load {
    if (self != [ZQDatabaseModel class]) {
        [[ZQDatabaseManager shareDatabaseManager] createTableWithCalss:self];
    }
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
//插入数据
-(void)save
{
    [[ZQDatabaseManager shareDatabaseManager] insertWithClass:self];
}

//删除数据
+(void)deleteWithPropName:(NSString *)propName value:(id)value
{
    [[ZQDatabaseManager shareDatabaseManager] deleteWithCalss:self propName:propName value:value];
}

+ (void)deleteAllDataFromTable {
    [[ZQDatabaseManager shareDatabaseManager] deleteAllDataWithClass:self];
}

//修改数据
-(void)updateWithCondition:(NSString *)condition
{
    [[ZQDatabaseManager shareDatabaseManager] updateDataWithClass:self condition:condition];
}

// 条件查询
+ (NSArray *)getDataWithCondition:(NSString *)condition {
    
    NSArray *tempArray = [[ZQDatabaseManager shareDatabaseManager] getDataWithClass:self condition:condition];
    return tempArray;
    
}

// 获得所有数据
+(NSArray *)getAllDataFromLocal
{
    NSArray *tempArray = [[ZQDatabaseManager shareDatabaseManager] getAllDataWithClass:self];
    
    NSMutableArray *resultArray = [NSMutableArray array];
    for (NSDictionary *dict in tempArray) {
        NSObject *temp = [[self alloc] init];
        [temp setValuesForKeysWithDictionary:dict];
        [resultArray addObject:temp];
    }
    return resultArray;
}

// 分页获取数据
+ (NSArray *)getDataWithPage:(NSInteger )page {
    
    NSArray *tempArray = [[ZQDatabaseManager shareDatabaseManager] getDataWithClass:self page:page];
    return tempArray;
}

@end
