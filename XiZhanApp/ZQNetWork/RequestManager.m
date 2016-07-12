//
//  RequestManager.m
//  网络请求
//
//  Created by apple on 16/5/24.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "RequestManager.h"

@implementation RequestManager

+ (void)postRequestWithURL:(NSString *)urlStr
                   paramer:(NSDictionary *)paramers
                   success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                   failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
                   showHUD:(BOOL )showHUD{
    
    NSString *str = [BaseAPI stringByAppendingString:urlStr];
    NSString *url = nil;
    if ([Utility checkToSign:str]) {
        url = [[Utility getSecretAPI:str paramDict:nil] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [RequestHelper startRequest:url paramer:paramers method:RequestMethodPost success:success failure:failure showHUD:showHUD];
    }else {
        url = str;
        [RequestHelper startRequest:url paramer:paramers method:RequestMethodPost success:success failure:failure showHUD:showHUD];
    }
//    [RequestHelper startRequest:urlStr paramer:paramers method:RequestMethodPost success:success failure:failure];
    
}

+ (void)getRequestWithURL:(NSString *)urlStr
                  paramer:(NSDictionary *)paramers
                  success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                  failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
                  showHUD:(BOOL )showHUD {
    
    NSString *str = [BaseAPI stringByAppendingString:urlStr];
    NSString *url = nil;
    if ([Utility checkToSign:str]) {
        url = [[Utility getSecretAPI:str paramDict:paramers] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [RequestHelper startRequest:url paramer:paramers method:RequestMethodGet success:success failure:failure showHUD:showHUD];
    }else {
        url = str;
        [RequestHelper startRequest:url paramer:paramers method:RequestMethodGet success:success failure:failure showHUD:showHUD];
    }
//    [RequestHelper startRequest:urlStr paramer:paramers method:RequestMethodGet success:success failure:failure];
    
}


+ (void)uploadFile:(NSData *)postData
 completionHandler:(void(^)(id responseObject))completion
   progressHandler:(void(^)(long long p))progressBlock
    failureHandler:(void(^)(NSError *error))failure {
    
    [RequestHelper uploadFile:postData completionHandler:completion progressHandler:progressBlock failureHandler:failure];
}
@end
