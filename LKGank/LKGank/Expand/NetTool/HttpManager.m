//
//  HttpManager.m
//  AFNetworking
//
//  Created by AdminZhiHua on 16/6/1.
//  Copyright © 2016年 AdminZhiHua. All rights reserved.
//

#import "HttpManager.h"
#import "YYCache.h"
#import <CommonCrypto/CommonDigest.h>

#define CacheFolder @"HttpCache"

static HttpManager *manager;

@implementation HttpManager

//定义单例
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [super allocWithZone:zone];
        Reachability *reach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
        manager.reach = reach;
    });
    return manager;
}

+ (instancetype)shareHttpManager {
    if (!manager) {
        manager = [HttpManager new];
        [self initAttributeWith:manager];
    }
    return manager;
}

+ (void)initAttributeWith:(HttpManager *)manager {
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10;
    manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    
    //设置响应的类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"application/json",@"text/json",@"text/javascript",@"text/html", nil];
    
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
    responseSerializer.removesKeysWithNullValues = YES;
    
    manager.responseSerializer = responseSerializer;
    
}

#pragma mark - Get请求

+ (void)BGET:(NSString *)urlString parameters:(id)params success:(SuccessResponse)success failure:(FailureResponse)failure {
    
    [self BGET:urlString parameters:params isCache:NO requestProgress:nil success:success failure:failure];
    
}

+ (void)BGET:(NSString *)urlString parameters:(id)params requestProgress:(RequestProgress)progress success:(SuccessResponse)success failure:(FailureResponse)failure {
    
    [self BGET:urlString parameters:params isCache:NO requestProgress:progress success:success failure:failure];
    
}

+ (void)BGETWithCache:(NSString *)urlString parameters:(id)params success:(SuccessResponse)success failure:(FailureResponse)failure {
    
    [self BGET:urlString parameters:params isCache:YES requestProgress:nil success:success failure:failure];
    
}

+ (void)BGETWithCache:(NSString *)urlString parameters:(id)params requestProgress:(RequestProgress)progress success:(SuccessResponse)success failure:(FailureResponse)failure {
    
    [self BGET:urlString parameters:params isCache:YES requestProgress:progress success:success failure:failure];
    
}

+ (void)BGET:(NSString *)urlString parameters:(id)params isCache:(BOOL)cache requestProgress:(RequestProgress)progress success:(SuccessResponse)success failure:(FailureResponse)failure {
    
    NSString *keyOfCache;
    
    YYCache *yyCache;
    
    if (cache)
    {
        //缓存的key：url+"#参数值"的MD5加密的字符串
        keyOfCache = [self keyWithUrl:urlString params:params];
        
        yyCache = [[YYCache alloc] initWithName:CacheFolder];
        
        yyCache.memoryCache.shouldRemoveAllObjectsOnMemoryWarning = YES;
        yyCache.memoryCache.shouldRemoveAllObjectsWhenEnteringBackground = YES;
        
        NetworkStatus status = [ShareHttpManager.reach currentReachabilityStatus];
        
        //网络判断->没有网络从缓存中获取。
        if (status == NotReachable) {
            
            id data = [yyCache objectForKey:keyOfCache];
            
            if (success)
            {
                success(nil,data);
            }
            return;
        }
        
    }
    
    [ShareHttpManager GET:urlString parameters:params progress:^(NSProgress *downloadProgress) {
        if (progress) {
            progress(downloadProgress);
        }
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success)
        {
            success(task,responseObject);
        }
        if (cache)
        {
            [yyCache setObject:responseObject forKey:keyOfCache];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(task,error);
        }
    }];
    
}

#pragma mark - Post请求

+ (void)BPOST:(NSString *)urlString parameters:(id)params success:(SuccessResponse)success failure:(FailureResponse)failure {
    
    [self BPOST:urlString parameters:params requestProgress:nil success:success failure:failure];
    
}

+ (void)BPOST:(NSString *)urlString parameters:(id)params requestProgress:(RequestProgress)progress success:(SuccessResponse)success failure:(FailureResponse)failure {
    
    [self BPOST:urlString parameters:params isCache:NO requestProgress:progress success:success failure:failure];
    
}

+ (void)BPOSTWithCache:(NSString *)urlString parameters:(id)params success:(SuccessResponse)success failure:(FailureResponse)failure {
    
    [self BPOST:urlString parameters:params isCache:YES requestProgress:nil success:success failure:failure];
    
}

+ (void)BPOSTWithCache:(NSString *)urlString parameters:(id)params requestProgress:(RequestProgress)progress success:(SuccessResponse)success failure:(FailureResponse)failure {
    
    [self BPOST:urlString parameters:params isCache:YES requestProgress:progress success:success failure:failure];
    
}

+ (void)BPOST:(NSString *)urlString parameters:(id)params isCache:(BOOL)cache requestProgress:(RequestProgress)progress success:(SuccessResponse)success failure:(FailureResponse)failure {
    
    NSString *keyOfCache;
    
    YYCache *yyCache;
    
    if (cache)
    {
        keyOfCache = [self keyWithUrl:urlString params:params];
        
        yyCache = [[YYCache alloc] initWithName:CacheFolder];
        
        yyCache.memoryCache.shouldRemoveAllObjectsOnMemoryWarning = YES;
        yyCache.memoryCache.shouldRemoveAllObjectsWhenEnteringBackground = YES;
        
        NetworkStatus status = [ShareHttpManager.reach currentReachabilityStatus];
        
        //网络判断->没有网络从缓存中获取。
        if (status == NotReachable) {

            id data = [yyCache objectForKey:keyOfCache];
            
            if (success)
            {
                success(nil,data);
            }
            return;
        }
        
    }
    
    [ShareHttpManager POST:urlString parameters:params progress:^(NSProgress *uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success)
        {
            success(task,responseObject);
        }
        if (cache)
        {
            [yyCache setObject:responseObject forKey:keyOfCache];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(task,error);
        }
    }];
    
}

#pragma mark - Download
+ (NSURLSessionDownloadTask *)download:(NSString *)urlString downloadProgress:(RequestProgress)progress completeHandler:(DownloadHandler)handler {
    
    NSURLRequest *downloadRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    NSURLSessionDownloadTask *downloadTask;
    
    downloadTask = [ShareHttpManager downloadTaskWithRequest:downloadRequest progress:^(NSProgress * downloadProgress) {
        
        if (progress) {
            progress(downloadProgress);
        }
        
    } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
        
        NSString *filePath = [path stringByAppendingPathComponent:response.suggestedFilename];
        
        return [NSURL fileURLWithPath:filePath];
        
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        
        if (handler) {
            handler(response,filePath,error);
        }
        
    }];
    
    [downloadTask resume];
    
    return downloadTask;
}

+ (NSURLSessionDataTask *)uploadImage:(NSString *)urlString parameters:(id)params imageArray:(NSArray *)images uploadProgress:(RequestProgress)progress success:(SuccessResponse)success failure:(FailureResponse)failure {
    
    NSURLSessionDataTask *uploadTask;
    
    uploadTask = [ShareHttpManager POST:urlString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        for (UIImage *image in images) {
            
            NSInteger idx = [images indexOfObject:image];
            
            NSData *imageData = UIImageJPEGRepresentation(image, 1);
            
            [formData appendPartWithFileData:imageData name:[NSString stringWithFormat:@"pic%ld",idx] fileName:@"image.png" mimeType:@"image/jpeg"];
        }
        
    } progress:^(NSProgress *uploadProgress) {
        
        if (progress) {
            progress(uploadProgress);
        }
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if (success) {
            success(task,responseObject);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(task,error);
        }
    }];
    
    return uploadTask;
}

+ (void)httpCancelAllRequest {
    [ShareHttpManager.operationQueue cancelAllOperations];
}

#pragma mark - 网络监听
- (void)startNotifierReachability {
    [self.reach startNotifier];
}

- (void)stopNotifierReachability {
    [self.reach stopNotifier];
}

+ (NSString *)keyWithUrl:(NSString *)urlString params:(NSDictionary *)params
{
    if (params == nil) return nil;
    
    NSMutableArray *paramNames = [NSMutableArray arrayWithArray:[params allKeys]];
    
    // 即是key是我要传输的参数名按ASCII顺序追加起来（再加上固定名称）md5出来的
    NSArray *newParamNames = [paramNames sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        NSString *string1 = (NSString *)obj1;
        NSString *string2 = (NSString *)obj2;
        
        return [string1 compare:string2 options:NSNumericSearch];
    }];
    
    NSMutableString *key = [[NSMutableString alloc] initWithString:urlString];
    
    for (NSString *paramName in newParamNames)
    {
        id paramValue = params[paramName];
        NSString *paramValueString = [NSString stringWithFormat:@"#%@", paramValue];
        [key appendString:paramValueString];
    }
    
    return [self MD5:key];
}

+ (NSString*)MD5:(NSString *)string
{
    // Create pointer to the string as UTF8
    const char *ptr = [string UTF8String];
    
    // Create byte array of unsigned chars
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    
    // Create 16 byte MD5 hash value, store in buffer
    CC_MD5(ptr,(CC_LONG)strlen(ptr), md5Buffer);
    
    // Convert MD5 value in the buffer to NSString of hex values
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x",md5Buffer[i]];
    
    return output;
}


@end
