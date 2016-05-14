//
//  Utility.h
//  OATest
//
//  Created by zhangqiang on 15/9/2.
//  Copyright (c) 2015年 zhangqiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utility : NSObject
/**
 *  保存我的消息已读状态
 */
+ (void)saveMyMsgReadState:(BOOL)state;

/**
 *  获取我的消息已读状态
 */
+ (BOOL)getMyMsgReadState;

/**
 *  根据id获取控制器
 */
+ (id)getControllerWithStoryBoardId:(NSString *)storyBoardId;

/**
 *  获取用户信息
 *
 *  @return 用户信息
 */
+(NSDictionary *)getUserInfoFromLocal;

/**
 *  存储用户信息
 *
 *  @param dict 用户信息
 */
+(void)saveUserInfo:(NSDictionary *)dict;

/**
 *  设置登录状态
 *
 *  @param isLogin 是否登录
 */
+(void)setLoginStates:(BOOL )isLogin;

/**
 *  登录状态
 *
 *  @return 是否登录
 */
+(BOOL )isLogin;

/**
 *  版本检测
 *
 *  @param versionCheckBlock 是否有新版本
 */
+(void)checkNewVersion:(void(^)(BOOL hasNewVersion))versionCheckBlock;

/**
  * 正则匹配手机号
  */
+ (BOOL)checkTelNumber:(NSString *) telNumber;

/**
 *  验证密码6-18位数字拼音组合
 */
+ (BOOL)checkPassword:(NSString *) password;


/** 时间戳转时间
 */
+ (NSString *)timeFormat:(NSString *)date format:(NSString *)dateFormat;

/**
 *  字符串转时间戳
 */
+(NSString *)timeIntervalWithDateStr:(NSString *)dateStr;
@end
