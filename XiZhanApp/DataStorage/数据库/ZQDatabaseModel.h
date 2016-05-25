//
//  ZQDatabaseModel.h
//  SqliteDemo
//
//  Created by zhangqiang on 15/8/11.
//  Copyright (c) 2015年 zhangqiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZQDatabaseManager.h"

@interface ZQDatabaseModel : NSObject

// 设置字段唯一,防止插入重复插入
+ (void)setUniqueProperty:(NSString *)proName;

/**
 *  插入数据
 */
-(void)save;

/**
 *  删除数据
 *
 *  @param propName 条件依据(属性名)
 *  @param value    条件(一般是ID的值)
 */
-(void)deleteWithPropName:(NSString *)propName value:(id)value;

/**
 *  删除表所有数据
 */
- (void)deleteAllDataFromTable;

/**
 *  修改数据
 *
 *  @param propName  列名(要修改什么数据)
 *  @param value     修改的值
 *  @param condition 修改条件
 */
-(void)updateWithCondition:(NSString *)condition;

/**
 *  从本地获取数据
 *
 *  @return 数据数组
 */
-(NSArray *)getAllDataFromLocal;

/**
 *  条件查询
 *
 *  @param condition 查询条件
 */
- (NSArray *)getDataWithCondition:(NSString *)condition;

/**
 *  分页查询
 *
 *  @param page 页数
 */
- (NSArray *)getDataWithPage:(NSInteger )page;

/**
 *  从本地获取数据并排序
 *
 *  @return 数据数组
 */
+(NSArray *)getAllDataFromLocalOrderby:(NSString *)proName;

/**
 *  分页查询并排序
 *
 *  @param page 页数
 */
+ (NSArray *)getDataWithPage:(NSInteger )page orderBy:(NSString *)proName;

/**
 *  组合查询
 *
 *  @param condition 特殊条件
 *  @param page      分页
 *  @param proName   根据字段排序
 *
 *  @return 模型数组
 */
+ (NSArray *)getDataWithCondition:(NSString *)condition page:(NSInteger )page orderBy:(NSString *)proName;
@end
