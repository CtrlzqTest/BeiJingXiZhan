//
//  ZQDatabaseManager.m
//  SqliteDemo
//
//  Created by zhangqiang on 15/8/11.
//  Copyright (c) 2015年 zhangqiang. All rights reserved.
//

#import "ZQDatabaseManager.h"
#import <FMDB.h>
#import "ZQDatabaseHelper.h"
static ZQDatabaseManager *manager = nil;
@interface ZQDatabaseManager()
{
    FMDatabase *_db;
    NSMutableArray *_tables;
    NSMutableArray *_classes;
    NSInteger _flag;
}
@end

@implementation ZQDatabaseManager
+(ZQDatabaseManager *)shareDatabaseManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ZQDatabaseManager alloc] init];
    });
    return manager;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        //创建数据库
        NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"zq.sqlite"];
        NSLog(@"%@",path);
        _db = [FMDatabase databaseWithPath:path];
        _tables = [NSMutableArray array];
        _classes = [NSMutableArray array];
    }
    return self;
}

//创建表
-(void)createTableWithCalss:(Class )aClass
{
    if ([_db open]) {
        if ([_db executeUpdate:[ZQDatabaseHelper getCreateSQL:aClass]]) {
            NSLog(@"创建表成功！！！");
            [_db close];
        }
    }else{
        NSLog(@"数据库打开失败!!!");
    }
}
//插入数据
-(void)insertWithClass:(NSObject *)aClass
{
    if ([_db open]) {
        if ([_db executeUpdate:[ZQDatabaseHelper getInsertSQL:aClass]]) {

//            [_db close];
        }
    }else{
        NSLog(@"数据库打开失败!!!");
    }
}

//删除数据
-(void)deleteWithCalss:(Class )aClass propName:(NSString *)propName value:(id )value
{
    if ([_db open]) {
        if ([_db executeUpdate:[ZQDatabaseHelper getDeleteSQL:aClass propName:propName value:value]]) {
            NSLog(@"删除成功！！！");
            [_db close];
        }
    }else{
        NSLog(@"数据库打开失败!!!");
    }
}

// 删除所有数据
- (void)deleteAllDataWithClass:(Class )aClass {
    if ([_db open]) {
        if ([_db executeUpdate:[ZQDatabaseHelper getDeleteAllSQL:aClass]]) {
            NSLog(@"删除成功！！！");
            [_db close];
        }
    }else{
        NSLog(@"数据库打开失败!!!");
    }
}

//修改数据
-(void)updateDataWithClass:(NSObject *)object condition:(NSString *)condition
{
    if ([_db open]) {
        if ([_db executeUpdate:[ZQDatabaseHelper getUpdateSQL:object condition:condition]]) {
            NSLog(@"修改成功！！！");
            [_db close];
        }else {
            NSLog(@"修改失败！！！");
        }
    }else{
        NSLog(@"数据库打开失败!!!");
    }
}

//查询数据
 //1,获取所有数据
-(NSArray *)getAllDataWithClass:(NSObject *)object
{
    NSArray *tempArray = nil;
    if ([_db open]) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@",[ZQDatabaseHelper getTableName:[object class]]];
        FMResultSet *set= [_db executeQuery:sql];
        tempArray = [self getDataStrWithSet:set];
    }else{
        NSLog(@"数据库打开失败!!!");
    }
    return tempArray;
}

 //2,条件查询
- (NSArray *)getDataWithClass:(NSObject *)object condition:(NSString *)condition {
    
    NSArray *tempArray = nil;
    NSString *sql = nil;
    if ([_db open]) {
        if (condition.length <= 0) {
            sql = [NSString stringWithFormat:@"SELECT * FROM %@",[ZQDatabaseHelper getTableName:[object class]]];
        }else {
            sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@",[ZQDatabaseHelper getTableName:[object class]],condition];
        }
        
        FMResultSet *set= [_db executeQuery:sql];
        tempArray = [self getDataStrWithSet:set];
    }else{
        NSLog(@"数据库打开失败!!!");
    }
    return tempArray;
    
}

// 3,分页显示
-(NSArray *)getDataWithClass:(NSObject *)object page:(NSInteger )page {
    NSArray *tempArray = nil;
    if ([_db open]) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ limit %ld,20",[ZQDatabaseHelper getTableName:[object class]],(long)page - 1];
        FMResultSet *set= [_db executeQuery:sql];
        tempArray = [self getDataStrWithSet:set];
    }else{
        NSLog(@"数据库打开失败!!!");
    }
    return tempArray;
}

#pragma mark - Private methods
-(NSArray *)getDataStrWithSet:(FMResultSet *)set
{
    NSMutableArray *resultArray = [NSMutableArray array];
    //获得行列
    NSEnumerator *columnNames = [set.columnNameToIndexMap keyEnumerator];
    NSString *tempColumnName = nil;
    NSMutableArray *columnNameArray = [NSMutableArray array];
    while (tempColumnName = [columnNames nextObject]) {
        [columnNameArray addObject:tempColumnName];
    }
//    NSLog(@"%@",columnNameArray);
    while ([set next]) {
        NSMutableDictionary *snycData = [NSMutableDictionary dictionary];
        for (NSString *columnName in columnNameArray) {
            NSString *columnValue = [set stringForColumn:columnName];
            if (columnValue == nil) {
                columnValue = @"";
            }
            [snycData setValue:columnValue forKey:columnName];
        }
        [resultArray addObject:snycData];
    }
    return resultArray;
}
@end
