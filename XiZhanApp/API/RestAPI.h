//
//  RestAPI.h
//
//  Created by zhangqiang on 15/8/7.
//  Copyright (c) 2015年 zhangqiang. All rights reserved.
//

#ifndef _____RestAPI_h
#define _____RestAPI_h
#import <UIKit/UIKit.h>

#define BaseAPI                 @"http://192.168.16.139:8080/bjws/"  // 龙龙

//#define BaseAPI                 @"http://124.207.156.101:80/bjws/"  // 龙龙

#define BaseXiZhanAPI           @"http://222.240.172.197:8081/" // 西站测试

#define BaseXiZhanImgAPI        @"http://222.240.172.197/app_31/"

// for首页
#define BaseMainImgAPI          @"http://222.240.172.197/"

//#define BaseAPI                 @"http://222.240.172.197:8081/api/"  // 西站测试

//#define BaseAPI                   @"http://124.207.156.101:80/bjws/"  // 公司服务器

//#define BaseAPI                 @"http://192.168.16.124:8080/znweb/"    // 赵楠

//#define BaseAPI                 @"http://124.207.156.101:80/bjws/"    // 公网

#define kgetCodeAPI             @"app.user/getSmsCode"      // 获取验证码

#define kLoginAPI               @"app.user/login"       // 登录

#define kLogoutAPI               @"app.user/logout"       // 退出登录

#define kResetPwdAPI            @"app.user/repassword"       // 修改密码

#define kRegisteAPI             @"app.user/register"         //注册

#define kGetAreaAPI             @"api/List/GetAreas" //获取区域信息列表

#define kPostOnLine             @"api/Add/OnLine"//志愿者上线接口

#define kPostOffLine            @"api/Update/OffLine" //志愿者下线

#define kGetTaxiRankInfoAPI     @"api/List/GetTaxiRankInfo"  // 获取出租车站点信息

#define kGetTaxiInfoNewDataAPI  @"api/List/GetTaxiInfoNewData" //获取出租车站点新数据

#define KPostTaxiInformation    @"api/Add/PublishTaxiRankInfo" //提交出租车新信息

#define kGetParkInfoNewAPI      @"api/List/GetParkStatusInfoLatestData" // 获取停车场最新数据

#define KPostNewPublishTaxiInfo @"api/Add/PublishTaxiInfo"//出租车运力管理

#define kAppopinion             @"api/Add/CommitFeedback" //意见反馈

//#define kMuenListAPI            @"api/List/GetNodes" //首页菜单

#define kMuenListAPI            @"api/List/GetNodesByParentID" //首页菜单

#define kMessageListAPI         @"api/List/GetContents" //消息列表

//#define kAllMessageAPI          @"app.menu/list" // 所有消息列表

#define kMenuAdd                @"api/Add/PublishContent"   //添加意见

#define kUploadFile             @"api/File/UploadFile"//上传文件

#define kMianzeAPI              @"disclaimer.html"  //免责申明

#define kAboutUs                @"aboutus.html"     //关于我们

#define kRegistZhixinAPI        @"api/AppClient/RegisterDevice"  // 向智信注册设备

#define kGetUUIDSecretAPI       @"api/AppClient/GetDeviceRegisterInfo"  // 获取设备UUIDSecret

#define kCheckNewVersionAPI     @"app.appversion/update"

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
