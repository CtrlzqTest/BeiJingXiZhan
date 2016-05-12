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

#define BaseAPI                 @"http://192.168.16.139:8080/bjws/"  // 龙龙

//#define BaseAPI                 @"http://192.168.16.147:8080/onepage/"  // 公司服务器

//#define BaseAPI                 @"http://192.168.16.124:8080/znweb/"    // 赵楠

#define kUpdateDataBaseToHost   @"vote3/test/update.do"

#define kgetCodeAPI         @"app.user/getSmsCode"      // 获取验证码

#define kGoodsListAPI           @"appinfo/slist"       // 购物列表

#define kLoginAPI               @"app.user/login"       // 登录

#define kRegisteAPI             @"app.user/register"         //注册

#define kAppopinion            @"app.opinion/add" //意见反馈

#define kCollectAPI             @"appmyfavorite/save"  //收藏

#define kCollectionListAPI      @"appmyfavorite/findPersonalList"  //收藏列表


//   常量
/**************************************************************************************/

static NSString *const ZQdidLoginNotication = @"didLoginNotication";    // 登录成功

static NSString *const ZQdidLogoutNotication = @"didLogoutNotication"; // 退出登录

/**************************************************************************************/

//   storyboardId
/**************************************************************************************/

static NSString *const ZQLoginViewCotrollerId = @"loginViewCotrollerId";    // 登录控制器Id

static NSString *const ZQServeTabViewControllerId = @"serveTabViewControllerId";    // 服务台信息

static NSString *const ZQServeDetailViewControllerId = @"serveDetailViewControllerId"; // 服务台信息详情

static NSString *const ZQPublishInfoViewControllerId = @"publishInfoViewControllerId"; // 发布消息

/**************************************************************************************/


#endif
