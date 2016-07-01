//
//  RequestHelper.h
//  网络请求
//
//  Created by apple on 16/5/24.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD+Add.h"

typedef NS_ENUM(NSInteger, RequestMethod) {
    RequestMethodGet,
    RequestMethodPost,
    RequestMethodDelete
};

@interface RequestHelper : NSObject

/**
 *  普通GET,POST请求
 *
 *  @param url      请求地址
 *  @param paramers 参数
 *  @param method   请求方式
 *  @param success  返回成功数据
 *  @param failure  返回失败
 */
+ (void)startRequest:(NSString *)url
             paramer:(NSDictionary *)paramers
              method:(RequestMethod)method
             success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
             failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
             showHUD:(BOOL )showHUD;

/**
 *  上传数据到服务器
 *
 *  @param postData      要上传的数据
 *  @param completion    上传成功响应
 *  @param progressBlock 上传进度
 *  @param failure       上传失败响应
 */
+ (void)uploadFile:(NSData *)postData
 completionHandler:(void(^)(id responseObject))completion
   progressHandler:(void(^)(long long p))progressBlock
    failureHandler:(void(^)(NSError *error))failure;

/**
 *  下载数据
 *
 *  @param fileUrl           下载地址
 *  @param progressHander    下载进度
 *  @param completionHandler 下载完成
 *  @param failerHandler     下载失败
 */
+ (void)downloadFileRquestWithFileUrl:(NSString *)fileUrl progress:(void(^)(NSProgress *))progressHander completionHandler:(void(^)(id responseObject))completionHandler failerHandler:(void(^)(NSError *error))failerHandler;
@end
