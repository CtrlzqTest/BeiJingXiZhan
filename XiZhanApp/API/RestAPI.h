//
//  RestAPI.h
//  美食厨房
//
//  Created by zhangqiang on 15/8/7.
//  Copyright (c) 2015年 zhangqiang. All rights reserved.
//

#ifndef _____RestAPI_h
#define _____RestAPI_h
#import <UIKit/UIKit.h>

//#define BaseAPI                 @"http://192.168.16.147:8080/bjws/"  // 龙龙

#define BaseAPI                 @"http://222.240.172.197:8081/api/"  // 西站测试

//#define BaseAPI                 @"http://124.207.156.101:80/bjws/"  // 公司服务器

//#define BaseAPI                 @"http://192.168.16.124:8080/znweb/"    // 赵楠

#define kgetCodeAPI         @"app.user/getSmsCode"      // 获取验证码

#define kLoginAPI               @"app.user/login"       // 登录

#define kRegisteAPI             @"app.user/register"         //注册

#define kAppopinion            @"app.opinion/add" //意见反馈

#define kMuenListAPI           @"app.menu/getMenu" //首页菜单

#define kAllMessageAPI         @"app.menu/list" // 所有消息列表

#define kMenuAdd               @"app.menu/add"   //添加意见
//   常量
/**************************************************************************************/

static NSString *const ZQdidLoginNotication = @"didLoginNotication";    // 登录成功

static NSString *const ZQdidLogoutNotication = @"didLogoutNotication"; // 退出登录

static NSString *const ZQReadStateDidChangeNotication = @"changeReadStatesNotication"; // 消息已读状态

static NSString *const ZQAddServeInfoNotication = @"addServeInfoNotication"; // 添加服务台消息

static NSString *const ZQAddOtherInfoNotication = @"addOtherInfoNotication"; // 添加其他消息

/**************************************************************************************/

//   storyboardId
/**************************************************************************************/

static NSString *const ZQLoginViewCotrollerId = @"loginViewCotrollerId";    // 登录控制器Id

static NSString *const ZQServeTabViewControllerId = @"serveTabViewControllerId";    // 服务台信息

static NSString *const ZQServeDetailViewControllerId = @"serveDetailViewControllerId"; // 服务台信息详情

static NSString *const ZQPublishInfoViewControllerId = @"publishInfoViewControllerId"; // 发布消息



/**************************************************************************************/

// 推送
#define AppKey @"6816fee48fb77859f7a9011b"

#endif
