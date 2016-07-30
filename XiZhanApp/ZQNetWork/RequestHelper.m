//
//  RequestHelper.m
//  网络请求
//
//  Created by apple on 16/5/24.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "RequestHelper.h"
#import <AFNetworking.h>
#import "RestAPI.h"



@implementation RequestHelper

+(AFHTTPSessionManager *)requestManagerWithBaseURL:(NSString *)baseURLString {
    
    NSURL *baseURL = [NSURL URLWithString:baseURLString];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    NSOperationQueue *operationQueue = manager.operationQueue;
    [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWiFi:
                
            case AFNetworkReachabilityStatusReachableViaWWAN:
                [operationQueue setSuspended:NO];
                break;
            case AFNetworkReachabilityStatusNotReachable:
            default:
//                [MBProgressHUD showError:@"无网络连接" toView:nil];
//                [MBProgressHUD hideAllHUDsForView:(UIView*)[[[UIApplication sharedApplication]delegate]window] animated:NO];
//                [operationQueue setSuspended:YES];
                break;
        }
    }];
    [manager.reachabilityManager startMonitoring];
    
    return manager;
}

+ (void)startRequest:(NSString *)url
             paramer:(NSDictionary *)paramers
              method:(RequestMethod)method
             success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
             failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
             showHUD:(BOOL )showHUD{
    
    AFHTTPSessionManager *manager = [self requestManagerWithBaseURL:BaseAPI];
    manager.requestSerializer.timeoutInterval = 10.0f;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //添加一个可以接受的类型，因为有时候返回值不为json
//    NSMutableSet *acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes mutableCopy];
//    [acceptableContentTypes addObject:@"text/json; charset=utf-8"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/xml",@"text/html",@"text/plain", nil];
    
//    NSString *path = [BaseAPI stringByAppendingString:url];
    [MBProgressHUD hideAllHUDsForView:(UIView*)[[[UIApplication sharedApplication]delegate]window] animated:NO];
    if (showHUD) {
        [MBProgressHUD showHUDAddedTo:(UIView*)[[[UIApplication sharedApplication]delegate]window] animated:YES];
    }
    
    if (method == RequestMethodGet) {
        
        [manager GET:url parameters:paramers progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [MBProgressHUD hideAllHUDsForView:(UIView*)[[[UIApplication sharedApplication]delegate]window] animated:YES];
            success(task,responseObject);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [MBProgressHUD hideAllHUDsForView:(UIView*)[[[UIApplication sharedApplication] delegate]window] animated:YES];
            [MBProgressHUD showMessag:@"网络不给力" toView:nil];
            NSLog(@"%@",error.description);
            failure(task,error);
        }];
        
    }else if (method == RequestMethodPost) {
        
        [manager POST:url parameters:paramers progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [MBProgressHUD hideAllHUDsForView:(UIView*)[[[UIApplication sharedApplication]delegate]window] animated:YES];
            success(task,responseObject);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [MBProgressHUD hideAllHUDsForView:(UIView*)[[[UIApplication sharedApplication]delegate]window] animated:YES];
            [MBProgressHUD showMessag:@"网络不给力" toView:nil];
            failure(task,error);
        }];
        
    } else if (method == RequestMethodDelete) {
        
        [manager DELETE:url parameters:paramers success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            [MBProgressHUD hideAllHUDsForView:(UIView*)[[[UIApplication sharedApplication]delegate]window] animated:YES];
            success(task,responseObject);
            
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            [MBProgressHUD hideAllHUDsForView:(UIView*)[[[UIApplication sharedApplication]delegate]window] animated:YES];
            [MBProgressHUD showMessag:@"网络不给力" toView:nil];
            failure(task,error);
        }];
        
    }
}

#warning 上传和下载还不完善,有待修改
+ (void)uploadFile:(NSData *)postData
 completionHandler:(void(^)(id responseObject))completion
   progressHandler:(void(^)(long long p))progressBlock
    failureHandler:(void(^)(NSError *error))failure
           showHUD:(BOOL)showHUD{
    
    if (showHUD) {
        [MBProgressHUD hideAllHUDsForView:(UIView*)[[[UIApplication sharedApplication]delegate]window] animated:NO];
        [MBProgressHUD showHUDAddedTo:(UIView*)[[[UIApplication sharedApplication]delegate]window] animated:YES];
    }
    
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    NSString *path = [BaseXiZhanAPI stringByAppendingString:kUploadFile];
    NSString *urlStr = [Utility getSecretAPI:path paramDict:nil];
    NSMutableURLRequest *request =
    [serializer multipartFormRequestWithMethod:@"POST" URLString:urlStr parameters:@{@"path":@"contentimage"} constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:postData
                                    name:@"bin"
                                fileName:@"image.jpg"
                                mimeType:@"application/octet-stream"];
    } error:nil];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSLog(@"%@ %@", response, responseObject);
            completion(responseObject);
        }
    }];
    [uploadTask resume];
}

+ (void)downloadFileRquestWithFileUrl:(NSString *)fileUrl progress:(void(^)(NSProgress *))progressHander completionHandler:(void(^)(id responseObject))completionHandler failerHandler:(void(^)(NSError *error))failerHandler{
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:fileUrl]];
//    NSProgress *downLoadProgress = nil;
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:progressHander destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
        
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"File downloaded to: %@", filePath);
    }];
    
    [manager setDownloadTaskDidWriteDataBlock:^(NSURLSession * _Nonnull session, NSURLSessionDownloadTask * _Nonnull downloadTask, int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
        
    }];
    
    [downloadTask resume];
    
}

@end

