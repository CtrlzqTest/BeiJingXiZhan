//
//  ZQDatabaseManager.h
//  SqliteDemo
//
//  Created by zhangqiang on 15/8/11.
//  Copyright (c) 2015年 zhangqiang. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface ZQDatabaseManager : NSObject

+(ZQDatabaseManager *)shareDatabaseManager;
/**
 *  根据类创建表
 *
 *  @param aClass 需要创建表的模型类(Model)
 */
-(void)createTableWithCalss:(Class )aClass;

/**
 *  插入数据
 *
 *  @param aClass 继承NSObject的类
 */
-(void)insertWithClass:(NSObject *)aClass;

/**
 *  删除数据
 *
 *  @param class    类(获得表名的作用)
 *  @param propName 列名(作为删除条件)
 *  @param value    通过propName,value确定要删除那一条信息
 *
 */
-(void)deleteWithCalss:(Class )aClass propName:(NSString *)propName value:(id )value;

/**
 *  删除某表所有数据
 *
 *  @param aClass 表对应的类名
 */
- (void)deleteAllDataWithClass:(Class )aClass;

/**
 *  修改数据
 *
 *  @param class     类(获得表名的作用)
 *  @param condition 修改条件
 */
-(void)updateDataWithClass:(NSObject *)object condition:(NSString *)condition;

#pragma 数据查询
/**
 *  获取某个表下的所有数据
 *
 *  @param object 类(确定表名)
 *
 *  @return 数据数组
 */
-(NSArray *)getAllDataWithClass:(NSObject *)object;

/**
 *  条件查询
 *
 *  @param object    表名
 *  @param condition 条件
 *
 *  @return 返回数组
 */
- (NSArray *)getDataWithClass:(NSObject *)object condition:(NSString *)condition;

/**
 *  分页查询
 *
 *  @param object    表名
 *  @param page      页数
 *
 *  @return 返回数组
 */
-(NSArray *)getDataWithClass:(NSObject *)object page:(NSInteger )page;

/**
 *  获取某个表下的所有数据并且排序
 *
 *  @param object 类(确定表名)
 *
 *  @return 数据数组
 */
-(NSArray *)getAllDataWithClass:(Class )object orderBy:(NSString *)proName;

/**
 *  分页查询并排序
 *
 *  @param object    表名
 *  @param page      页数
 *
 *  @return 返回数组
 */
-(NSArray *)getDataWithClass:(Class )object page:(NSInteger )page orderBy:(NSString *)proName;

// 所有情况
- (NSArray *)getDataWithClass:(Class )object condition:(NSString *)condition page:(NSInteger )page orderBy:(NSString *)proName;
@end
