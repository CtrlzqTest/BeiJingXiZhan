//
//  RequestManager.h
//  网络请求
//
//  Created by apple on 16/5/24.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RequestHelper.h"

@interface RequestManager : NSObject

/**
 *  POST请求
 *
 *  @param urlStr   请求地址
 *  @param paramers 参数
 *  @param success  请求成功
 *  @param failure  请求失败
 *  @param showHUD  是否显示加载中。。。
 */
+ (void)postRequestWithURL:(NSString *)urlStr
                   paramer:(NSDictionary *)paramers
                   success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                   failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
                   showHUD:(BOOL )showHUD;

/**
 *  GET请求
 *
 *  @param urlStr   请求地址
 *  @param paramers 参数
 *  @param success  请求成功
 *  @param failure  请求失败
 *  @param showHUD  是否显示加载中。。。
 */
+ (void)getRequestWithURL:(NSString *)urlStr
                  paramer:(NSDictionary *)paramers
                  success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                  failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
                  showHUD:(BOOL )showHUD;


@end
