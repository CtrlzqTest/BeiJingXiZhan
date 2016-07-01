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
    
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

// 设置字段唯一,防止插入重复插入
+ (void)setUniqueProperty:(NSString *)proName {
    
    [[ZQDatabaseManager shareDatabaseManager] setUniqueClass:self property:proName];
    
}

//插入数据
-(void)save
{
    [[ZQDatabaseManager shareDatabaseManager] insertWithClass:self];
}

//删除数据
-(void)deleteWithPropName:(NSString *)propName value:(id)value
{
    [[ZQDatabaseManager shareDatabaseManager] deleteWithCalss:[self class] propName:propName value:value];
}

- (void)deleteAllDataFromTable {
    [[ZQDatabaseManager shareDatabaseManager] deleteAllDataWithClass:[self class]];
}

//修改数据
-(void)updateWithCondition:(NSString *)condition
{
    [[ZQDatabaseManager shareDatabaseManager] updateDataWithClass:self condition:condition];
}

// 获得所有数据并排序
+(NSArray *)getAllDataFromLocalOrderby:(NSString *)proName
{
    NSArray *tempArray = [[ZQDatabaseManager shareDatabaseManager] getAllDataWithClass:self orderBy:proName];
    NSMutableArray *resultArray = [NSMutableArray array];
    for (NSDictionary *dict in tempArray) {
        NSObject *model = [[self alloc] init];
        [model setValuesForKeysWithDictionary:dict];
        [resultArray addObject:model];
    }
    return resultArray;
}

// 分页查询并排序
+ (NSArray *)getDataWithPage:(NSInteger )page orderBy:(NSString *)proName {
    NSArray *tempArray = [[ZQDatabaseManager shareDatabaseManager] getDataWithClass:self page:page orderBy:proName];
    NSMutableArray *resultArray = [NSMutableArray array];
    for (NSDictionary *dict in tempArray) {
        NSObject *model = [[self alloc] init];
        [model setValuesForKeysWithDictionary:dict];
        [resultArray addObject:model];
    }
    return resultArray;
}

// 条件查询
+ (NSArray *)getDataWithCondition:(NSString *)condition page:(NSInteger )page orderBy:(NSString *)proName{
    
    NSArray *tempArray = [[ZQDatabaseManager shareDatabaseManager] getDataWithClass:self condition:condition page:page orderBy:proName];
    NSMutableArray *resultArray = [NSMutableArray array];
    for (NSDictionary *dict in tempArray) {
        NSObject *model = [[self alloc] init];
        [model setValuesForKeysWithDictionary:dict];
        [resultArray addObject:model];
    }
    return resultArray;
    
}

@end
