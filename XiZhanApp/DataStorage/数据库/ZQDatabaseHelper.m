//
//  ZQDatabaseHelper.m
//  SqliteDemo
//
//  Created by zhangqiang on 15/8/11.
//  Copyright (c) 2015年 zhangqiang. All rights reserved.
//

#import "ZQDatabaseHelper.h"
#import <objc/runtime.h>

@implementation ZQDatabaseHelper

//查询表所有数据
+(NSString *)getAllDataSQL:(Class )class
{
    NSMutableString *querySQL = [NSMutableString string];
    
    return querySQL;
}

//修改数据SQL语句
+(NSString *)getUpdateSQL:(NSObject *)object condition:(NSString *)condition
{
    NSMutableString *updateSQL = [NSMutableString string];
    
//    [updateSQL appendFormat:@"UPDATE %@ SET %@ WHERE %@",[self getTableName:class],string,condition];
    [updateSQL appendFormat:@"UPDATE %@ SET ",[self getTableName:[object class]]];
    
    NSDictionary *props = [self fields:[object class]];
    for (NSString *propName in props) {
        [updateSQL appendFormat:@"%@ = '%@',",[self nameFilter:propName],[object valueForKey:propName]];
    }
    [updateSQL setString:[updateSQL substringToIndex:updateSQL.length - 1]];
    [updateSQL appendFormat:@" WHERE %@",condition];
    NSLog(@"updateSQL:%@",updateSQL);
    return updateSQL;
}

//获得删除数据SQL语句
+(NSString *)getDeleteSQL:(Class )class propName:(NSString *)propName value:(id)value
{
    NSMutableString *deleteSQL = [NSMutableString string];
    [deleteSQL appendFormat:@"DELETE FROM %@ WHERE %@ = '%@'",[self getTableName:class],[self nameFilter:propName],value];
    NSLog(@"deleteSQL:%@",deleteSQL);
    return deleteSQL;
}
// 获得删除所有数据SQL语句
+(NSString *)getDeleteAllSQL:(Class )class {
    NSMutableString *deleteSQL = [NSMutableString string];
    [deleteSQL appendFormat:@"drop table %@",[self getTableName:class]];
    NSLog(@"deleteSQL:%@",deleteSQL);
    return deleteSQL;
}

//获取插入数据SQL语句
+(NSString *)getInsertSQL:(NSObject *)object
{
    NSMutableString *insertSQL = [NSMutableString string];
    [insertSQL appendFormat:@"INSERT INTO %@ (",[self getTableName:[object class]]];
    
    NSDictionary *props = [self fields:[object class]];
    NSMutableString *valueStr = [NSMutableString string];
    for (NSString *propName in props) {
        [insertSQL appendFormat:@"%@,",[self nameFilter:propName]];
        [valueStr appendFormat:@"'%@',",[object valueForKey:propName]];
    }
    [insertSQL setString:[insertSQL substringToIndex:insertSQL.length - 1]];
    [valueStr setString:[valueStr substringToIndex:valueStr.length - 1]];
    [insertSQL appendFormat:@") VALUES (%@)",valueStr];
//    NSLog(@"insertSQL:%@",insertSQL);
    return insertSQL;
}

//获取表名
+(NSString *)getTableName:(Class )class
{
    return [self nameFilter:[NSString stringWithUTF8String:class_getName(class)]];
}

//获的创建表SQL语句
+ (NSString *)getCreateSQL:(Class )class
{
    NSString *tableName = [self nameFilter:[NSString stringWithUTF8String:class_getName(class)]];
    NSMutableString *createSQL = [NSMutableString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (_id INTEGER PRIMARY KEY AUTOINCREMENT",tableName];
    NSDictionary *properties = [self fields:class];
    for (NSString *str in [properties allKeys]) {
        NSString *propName = [self nameFilter:str];
        NSString *propType = [properties objectForKey:str];
//        if (![propName isEqualToString:@"_id"]) {
//            
//        }
        if ([propType isEqualToString:@"i"] || // int
            [propType isEqualToString:@"I"] || // unsigned int
            [propType isEqualToString:@"l"] || // long
            [propType isEqualToString:@"L"] || // usigned long
            [propType isEqualToString:@"q"] || // long long
            [propType isEqualToString:@"Q"] || // unsigned long long
            [propType isEqualToString:@"s"] || // short
            [propType isEqualToString:@"S"] || // unsigned short
            [propType isEqualToString:@"B"] )  // bool or _Bool
        {
            [createSQL appendFormat:@", %@ INTEGER", propName];
        }
        // Character Types
        else if ([propType isEqualToString:@"c"] ||	// char
                 [propType isEqualToString:@"C"] )  // unsigned char
        {
            [createSQL appendFormat:@", %@ INTEGER", propName];
        }
        else if ([propType isEqualToString:@"f"] || // float
                 [propType isEqualToString:@"d"] )  // double
        {
            [createSQL appendFormat:@", %@ REAL", propName];
        }
        else if ([propType hasPrefix:@"@"] ) // Object
        {
            NSString *className = [propType substringWithRange:NSMakeRange(2, [propType length]-3)];
            
            if([className isEqualToString:@"NSString"])
            {
                [createSQL appendFormat:@", %@ TEXT", propName];
            }
            else if([className isEqualToString:@"NSNumber"])
            {
                [createSQL appendFormat:@", %@ REAL", propName];
            }
            else if([className isEqualToString:@"NSDate"])
            {
                [createSQL appendFormat:@", %@ REAL", propName];
            }
            else if([className isEqualToString:@"NSData"])
            {
                [createSQL appendFormat:@", %@ BLOB", propName];
            }
            else
            {
                NSLog(@"Unknow Object Type: %@", className);
            }
        }
    }
    [createSQL appendString:@")"];
    NSLog(@"%@",createSQL);
    return createSQL;
}

/**
 *  反射获取类所有属性,将类型转换成sqlite数据类型
 *
 *  @param class Model类
 *
 *  @return KEY为属性类型，Value为属性名的字典
 */


#pragma mark - Private methods
+ (NSString *)nameFilter:(NSString *)name
{
    NSMutableString *ret = [NSMutableString string];
    
    for (int i = 0; i < name.length; i++)
    {
        NSRange range = NSMakeRange(i, 1);
        NSString *oneChar = [name substringWithRange:range];
        if ([oneChar isEqualToString:[oneChar uppercaseString]] && i > 0)
            [ret appendFormat:@"_%@", [oneChar lowercaseString]];
        else
            [ret appendString:[oneChar lowercaseString]];
    }
    return name;
}
/**
 *  反射获取类所有属性
 *
 *  @param class Model类
 *
 *  @return KEY为属性类型，Value为属性名的字典
 */
+(NSDictionary *)fields:(Class )class
{
#warning 如果父类不是NSObject,数据可能会出现问题
    NSMutableDictionary *theProps;
    if ([class superclass] != [NSObject class])
        theProps = (NSMutableDictionary *)[self fields:[class superclass]];
    else
        theProps = [NSMutableDictionary dictionary];
    
    unsigned int OutCount;
    
    objc_property_t *property_list = class_copyPropertyList(class, &OutCount);
    
    for (int i = 0; i < OutCount; i ++) {
        objc_property_t oneProp = property_list[i];
        NSString *propName = [NSString stringWithUTF8String:property_getName(oneProp)];
        NSString *attrs = [NSString stringWithUTF8String:property_getAttributes(oneProp)];
        NSArray *attrsParts = [attrs componentsSeparatedByString:@","];
        if (attrsParts.count > 0) {
            NSString *propType = [[attrsParts firstObject] substringFromIndex:1];
            [theProps setObject:propType forKey:propName];
        }
    }
    return theProps;
}
@end
