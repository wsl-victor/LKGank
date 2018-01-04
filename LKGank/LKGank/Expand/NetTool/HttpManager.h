//
//  HttpManager.h
//  AFNetworking
//
//  Created by AdminZhiHua on 16/6/1.
//  Copyright © 2016年 AdminZhiHua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "Reachability.h"

#define ShareHttpManager [HttpManager shareHttpManager]
#define kReachabilityStatusChange @"kReachabilityStatusChange"

typedef void(^SuccessResponse)(NSURLSessionDataTask *task,id responseObject);
typedef void(^FailureResponse)(NSURLSessionDataTask *task,NSError *error);
typedef void(^RequestProgress)(NSProgress *progress);
typedef void(^DownloadHandler)(NSURLResponse *response, NSURL *filePath, NSError *error);

@interface HttpManager : AFHTTPSessionManager

//默认开启网络监听
@property (nonatomic,strong) Reachability *reach;

+ (instancetype)shareHttpManager;

#pragma mark - Get请求
//没有缓存Get请求
+ (void)BGET:(NSString *)urlString parameters:(id)params success:(SuccessResponse)success failure:(FailureResponse)failure;

+ (void)BGET:(NSString *)urlString parameters:(id)params requestProgress:(RequestProgress)progress success:(SuccessResponse)success failure:(FailureResponse)failure;

//有缓存的请求
+ (void)BGETWithCache:(NSString *)urlString parameters:(id)params success:(SuccessResponse)success failure:(FailureResponse)failure;

+ (void)BGETWithCache:(NSString *)urlString parameters:(id)params requestProgress:(RequestProgress)progress success:(SuccessResponse)success failure:(FailureResponse)failure;

#pragma mark - Post请求
//没有缓存的Post请求
+ (void)BPOST:(NSString *)urlString parameters:(id)params success:(SuccessResponse)success failure:(FailureResponse)failure;

+ (void)BPOST:(NSString *)urlString parameters:(id)params requestProgress:(RequestProgress)progress success:(SuccessResponse)success failure:(FailureResponse)failure;

//没有缓存的Post请求
+ (void)BPOSTWithCache:(NSString *)urlString parameters:(id)params success:(SuccessResponse)success failure:(FailureResponse)failure;

+ (void)BPOSTWithCache:(NSString *)urlString parameters:(id)params requestProgress:(RequestProgress)progress success:(SuccessResponse)success failure:(FailureResponse)failure;

#pragma mark - 其他请求
// 文件下载
+ (NSURLSessionDownloadTask *)download:(NSString *)urlString downloadProgress:(RequestProgress)progress completeHandler:(DownloadHandler)handler;

//图片上传
+ (NSURLSessionDataTask *)uploadImage:(NSString *)urlString parameters:(id)params imageArray:(NSArray *)images uploadProgress:(RequestProgress)progress success:(SuccessResponse)success failure:(FailureResponse)failure;

//取消请求
+ (void)httpCancelAllRequest;

#pragma mark - 网络监听
- (void)startNotifierReachability;

- (void)stopNotifierReachability;

@end
