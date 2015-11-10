//
//  XDownloadTool.m
//  网络模块
//
//  Created by JW on 15/11/1.
//  Copyright © 2015年 JW All rights reserved.
//

#import "XDownloadTool.h"
#import "AFNetworking.h"



@implementation XDownloadTool

+ (void)getReachability
{
    // 检测网络连接状态
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager]setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSArray *array = @[@"未知网络",@"未连接网络",@"蜂窝网络",@"WiFi"];
        NSString *statusStr = array[status + 1];
        NSLog(@"%@",statusStr);
    }];
}

#pragma mark - get
+ (void) Get:(NSString *)urlpath param:(NSDictionary *)dict success:(void (^)(NSData *data,NSDictionary *obj))success fail:(void (^)(NSError *error))fail
{
    //get
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:urlpath parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        //成功
        NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        success(responseObject,obj);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //失败
        fail(error);
    }];
}

#pragma mark - post
+ (void)Post:(NSString *)urlpath param:(NSDictionary *)dict success:(void (^)(NSData *data,NSDictionary *obj))success fail:(void (^)(NSError *error))fail
{
    //post
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:urlpath parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        //成功
        NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        success(responseObject,obj);
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        //失败
        fail(error);
    }];
}

#pragma mark - upload
+ (void) UploadPostUrl:(NSString *)urlpath param:(NSDictionary *)dict filePath:(NSString *)filePath name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType success:(void (^)(NSData *data,NSDictionary *obj))success fail:(void (^)(NSError *error))fail
{
    //upload
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:urlpath parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSError *error = nil;
        [formData appendPartWithFileURL:[NSURL URLWithString:filePath] name:name fileName:fileName mimeType:mimeType error:&error];
        //本地上传时错误
        if (error) {
            fail(error);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        //成功
        NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        success(responseObject,obj);
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        //失败
        fail(error);
    }];
}

#pragma mark - download
+ (void) DownloadUrl:(NSString *)urlStr filePath:(NSString *)filePath success:(void (^)(NSURL *url))success fail:(void (^)())fail
{
    // 汉字转码,根据需要实现
    //    NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]]];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]] progress:nil destination:^ NSURL * (NSURL * targetpath, NSURLResponse * responseObject) {
        //如果没有指定  默认到存cache中
        if (filePath == nil) {
            NSString * cacheDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
            NSString *path = [cacheDir stringByAppendingPathComponent:responseObject.suggestedFilename];
            return [NSURL fileURLWithPath:path];
        }
        else{
            return [NSURL fileURLWithPath:filePath];
        }
        
    } completionHandler:^(NSURLResponse * responseObject, NSURL * filepath, NSError * error) {
        if (error == nil) {
            //下载完成
            success(filepath);
        }
        else{
            //下载失败
            NSLog(@"%@",error);
            fail();
        }
    }];
    [task resume];
}


@end
