//
//  ZQDatabaseHelper.h
//  SqliteDemo
//
//  Created by zhangqiang on 15/8/11.
//  Copyright (c) 2015年 zhangqiang. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface ZQDatabaseHelper : NSObject


/**
 *  反射获取类所有属性
 *
 *  @param class Model类
 *
 *  @return KEY为属性类型，Value为属性名的字典
 */
+(NSDictionary *)fields:(Class )class;

/**
 *  获得创建表的SQL语句
 *
 *  @param class 需要创建表的类(Model类)
 *
 *  @return SQL语句
 */
+ (NSString *)getCreateSQL:(Class )class;

/**
 *  //获取插入数据SQL语句
 *
 *  @param class 要插入的类(即那张表)
 *
 *  @return SQL语句
 */
+(NSString *)getInsertSQL:(NSObject *)object;

/**
 *  获取表名
 *
 *  @param class model类
 *
 *  @return 表名
 */
+(NSString *)getTableName:(Class )class;

/**
 *  获取删除数据SQL语句
 *
 *  @param class    类(获得表名的作用)
 *  @param propName 列名(作为删除条件)
 *  @param value    通过propName,value确定要删除那一条信息
 *
 *  @return SQL语句
 */
+(NSString *)getDeleteSQL:(Class )class propName:(NSString *)propName value:(id)value;

/**
 *  删除表所有数据
 *
 *  @param class 表对应的类名
 *
 *  @return SQL语句
 */
+(NSString *)getDeleteAllSQL:(Class )class;

/**
 *  修改数据
 *
 *  @param class     类(获得表名的作用)
 *  @param condition 修改条件
 *
 *  @return SQL语句
 */
+(NSString *)getUpdateSQL:(NSObject *)object condition:(NSString *)condition;
@end
