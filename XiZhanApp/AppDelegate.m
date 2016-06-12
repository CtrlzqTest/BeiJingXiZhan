//
//  AppDelegate.m
//  XiZhanApp
//
//  Created by zhangqiang on 16/5/9.
//  Copyright © 2016年 zhangqiang. All rights reserved.
//

#import "AppDelegate.h"
#import "BaseNaviViewController.h"
#import "LeftSlideViewController.h"
#import "LeftSortsViewController.h"
#import "MessageModel.h"
#import "JPUSHService.h"
#import "MenuModel.h"
#import "InformationDetailViewController.h"
#import "MyInformationsViewController.h"
#import "IQKeyboardManager.h"

@interface AppDelegate ()
{
    NSDictionary *_lunchOptions;
    BOOL _bageIsZero;
    NSInteger _isSkiptoVC;
}
@property(nonatomic,retain)NSMutableDictionary *dictForUserInfo;
@property(nonatomic,copy)NSString *updateURLString;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [NSThread sleepForTimeInterval:1.2];
    // 注册智信
    [Utility registZhixin];
    // 极光推送
    [self setupjPushWithLaunchOptions:launchOptions];
    
    // 检查版本更新
    [Utility checkNewVersion:^(BOOL hasNewVersion,NSDictionary *stringForUpdate) {
        if (hasNewVersion) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"版本更新" message:@"系统检测有新版本" delegate:self cancelButtonTitle:nil otherButtonTitles:@"点击进入下载", nil];
            self.updateURLString = stringForUpdate[@"loadUrl"];
            [alertView show];
        }
    }];

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    self.mainNavi = [mainStoryboard instantiateViewControllerWithIdentifier:@"baseNavigationVC"];
    LeftSortsViewController *leftSortsVC = [[LeftSortsViewController alloc] init];
    
    self.leftSliderVC = [[LeftSlideViewController alloc] initWithLeftView:leftSortsVC andMainView:self.mainNavi];
    
    
    self.window.rootViewController = self.leftSliderVC;
    [self.window makeKeyAndVisible];
    
    return YES;
}
#pragma mark 跳转下载最新版本
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.updateURLString]];
    }
}

#pragma mark 推送消息
-(void)setupjPushWithLaunchOptions:(NSDictionary *)launchOptions
{
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    
    //如不需要使用IDFA，advertisingIdentifier 可为nil
    [JPUSHService setupWithOption:_lunchOptions appKey:AppKey
                          channel:nil
                 apsForProduction:NO
            advertisingIdentifier:nil];

}

#pragma mark 注册用户别名
-(void)tagsAliasCallback:(int)iResCode
                    tags:(NSSet*)tags
                   alias:(NSString*)alias
{
    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}
#pragma mark 获得推送许可，获得推送消息
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [JPUSHService registerDeviceToken:deviceToken];
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{

    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"%@",userInfo);
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo
  completionHandler:(void (^)())completionHandler {
    
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    NSInteger count = --[UIApplication sharedApplication].applicationIconBadgeNumber;
    if (count >= 0) {
        [JPUSHService clearAllLocalNotifications];
        [JPUSHService setBadge:count];
    }
    _bageIsZero = YES;
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"推送消息:%@",userInfo);
    self.dictForUserInfo = [NSMutableDictionary dictionaryWithDictionary:userInfo];
    

    if (application.applicationState == UIApplicationStateActive)
    {
        NSLog(@"前台");
        
    }else if(application.applicationState == UIApplicationStateInactive)
    {
        NSLog(@"刚要进入前台");
        //        [[NSNotificationCenter defaultCenter] postNotificationName:@"push" object:str];
        //        self.pushSting = str;
        
        [self chooseSkipVC];
    }else if (application.applicationState == UIApplicationStateBackground){
        //        NSLog(@"后台");
        [MBProgressHUD showError:@"后台" toView:nil];
    }
}
-(void)chooseSkipVC
{
    [JPUSHService clearAllLocalNotifications];
    [JPUSHService setBadge:0];
    [self gotoInformationDetailVC:self.dictForUserInfo];
}
#pragma mark 跳转至消息列表界面
-(void)gotoInformationDetailVC:(NSDictionary *)dict
{
    MyInformationsViewController *detailList = [[MyInformationsViewController alloc] init];

    MenuModel *model = [MenuModel mj_objectWithKeyValues:dict];
    detailList.menuModel = model;
    detailList.parentIdString = dict[@"parentId"];
    detailList.msgType = dict[@"msgType"];
    [self.mainNavi pushViewController:detailList animated:NO];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    if (!_bageIsZero)
    {
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        [JPUSHService clearAllLocalNotifications];
        [JPUSHService setBadge:0];
    }
    _bageIsZero = NO;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
