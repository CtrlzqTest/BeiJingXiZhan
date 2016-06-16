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
 *  保存志愿者上线状态
 */
+ (void)saveVolunteerState:(BOOL)state;

/**
 *  获取志愿者状态
 */
+ (BOOL)getVolunteerState;

/**
 *  MD5加密
 *
 *  @param str 加密字符串
 *
 *  @return 加密后
 */
+ (NSString *) md5:(NSString *)str;

/**
 *  SHA1加密
 *
 *  @param str 加密字符串
 *
 *  @return 加密后
 */
+ (NSString *) sha1:(NSString *)str;

/**
 *  保存设备唯一标识
 *
 *  @param deviceToken 设备标识
 */
+ (void)saveDeviceToken:(NSString *)deviceToken;

/**
 *  获取设备唯一标识
 */
+ (NSString *)getDeviceToken;
/**
 *  版本检测
 *
 *  @param versionCheckBlock 是否有新版本
 */
+(void)checkNewVersion:(void(^)(BOOL hasNewVersion,NSDictionary *stringForUpdate))versionCheckBlock;

/**
  * 正则匹配手机号
  */
+ (BOOL)checkTelNumber:(NSString *) telNumber;

/**
 *  验证密码6-18位数字拼音组合
 */
+ (BOOL)checkPassword:(NSString *) password;

/**************************************************
        事件处理函数
***************************************************/

/** 时间戳转时间
 */
+ (NSString *)timeFormat:(NSString *)date format:(NSString *)dateFormat;

/**
 *  字符串转时间戳
 */
+(long )timeIntervalWithDateStr:(NSString *)dateStr;

/**
 *  获取系统当前时间
 *
 *  @return 时间字符串
 */
+ (NSString *)getCurrentDateStr;
/**
 *  获取文字的高度,确定宽度
 *
 *  @param str   文字
 *  @param width 宽度
 *
 *  @return 高度
 */
- (CGFloat )getHeightWithString:(NSString *)str width:(CGFloat )width fontSize:(CGFloat )fontSize;

/**
 *  获取文字的宽度,确定高度
 *
 *  @param str   文字
 *  @param width 高度
 *
 *  @return 宽度
 */
- (CGFloat )getWidthWithString:(NSString *)str height:(CGFloat )height fontSize:(CGFloat )fontSize;

/***************************************************************************************************
    智信对接处理
 ***********************************************************************************************/

/**
 *  注册智信
 */
+ (BOOL )registZhixin;

/**
 *  接口加密
 *
 *  @param keyAPI 关键接口action
 *  @param tempDict 其他get参数
 *
 *  @return 返回加密后的API
 */
+ (NSString *)getSecretAPI:(NSString *)keyAPI paramDict:(NSDictionary *)tempDict;

/**
 *  获取GUID
 *
 *  @return 返回GUID
 */
+ (NSString *)createGuidKey;

@end
