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
 *  修改数据
 *
 *  @param propName  列名(要修改什么数据)
 *  @param value     修改的值
 *  @param condition 修改条件
 */
-(void)updateWithCondition:(NSString *)condition;


@end
