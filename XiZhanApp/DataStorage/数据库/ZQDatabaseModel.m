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
#warning 需要重写下面两个方法
// 条件查询
- (NSArray *)getDataWithCondition:(NSString *)condition {
    
    NSArray *tempArray = [[ZQDatabaseManager shareDatabaseManager] getDataWithClass:self condition:condition];
    return tempArray;
    
}

// 获得所有数据
-(NSArray *)getAllDataFromLocal
{
    NSArray *tempArray = [[ZQDatabaseManager shareDatabaseManager] getAllDataWithClass:self];
//    NSMutableArray *resultArray = [NSMutableArray array];
//    for (NSDictionary *dict in tempArray) {
//        TestModel *model = [[TestModel alloc] init];
//        [model setValuesForKeysWithDictionary:dict];
//        [resultArray addObject:model];
//    }
    return tempArray;
}

// 分页获取数据
- (NSArray *)getDataWithPage:(NSInteger )page {
    
    NSArray *tempArray = [[ZQDatabaseManager shareDatabaseManager] getDataWithClass:self page:page];
//    NSMutableArray *resultArray = [NSMutableArray array];
//    for (NSDictionary *dict in tempArray) {
//        NSObject *model = [[self alloc] init];
//        [model setValuesForKeysWithDictionary:dict];
//        [resultArray addObject:model];
//    }
    return tempArray;
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
