//
//  XDownloadTool.h
//  网络模块
//
//  Created by JW on 15/11/1.
//  Copyright © 2015年 JW All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XDownloadTool : NSObject

/**
 *  获取网络状态
 *
 *  打印 "未知网络"|"未连接网络"|"WiFi"|"蜂窝网络"
 */
+ (void) getReachability;

/**
 *  get数据
 *
 *  @param urlpath  geturl
 *  @param dict     字典  一般为nil
 *  @param success  data->请求到的数据(responseObject)    obj json解析后的字典
 *  @param fail     error
 */
+ (void) Get:(NSString *)urlpath
      param:(NSDictionary *)dict
    success:(void (^)(NSData *data,NSDictionary *obj))success
       fail:(void (^)(NSError *error))fail;

/**
 *  post数据
 *
 *  @param urlpath  posturl
 *  @param dict     post字典
 *  @param success  data->请求到的数据(responseObject)    obj json解析后的字典
 *  @param fail     error
 */
+ (void) Post:(NSString *)urlpath
       param:(NSDictionary *)dict
     success:(void (^)(NSData *data,NSDictionary *obj))success
        fail:(void (^)(NSError *error))fail;


/**
 *  upload数据
 *
 *  @param urlpath   上传的网站
 *  @param dict      post字典  一般为nil
 *  @param filePath  本地文件的位置
 *  @param name      与指定的数据相关联的名称  此参数不能为 'nil'  一般为@"file"
 *  @param fileName  文件名  包括后缀
 *  @param mimeType  mime类型    PNG图像 image/png  |  JPEG图形 image/jpeg  |  普通文本 text/plain
 *  @param success   data->请求到的数据(responseObject)    obj json解析后的字典
 *  @param fail      error
 */
+ (void) UploadPostUrl:(NSString *)urlpath
                 param:(NSDictionary *)dict
              filePath:(NSString *)filePath
                  name:(NSString *)name
              fileName:(NSString *)fileName
              mimeType:(NSString *)mimeType
               success:(void (^)(NSData *data,NSDictionary *obj))success
                  fail:(void (^)(NSError *error))fail;

/**
 *  download数据
 *
 *  @param urlStr   下载网址
 *  @param filePath 下载的路径  包括文件名和类型  如果为nil  默认存到cache中
 *  @param success  下载成功返回路径URL类型
 *  @param fail     下载失败 内部已经打印
 */
+ (void) DownloadUrl:(NSString *)urlStr
            filePath:(NSString *)filePath
             success:(void (^)(NSURL *fileURL))success
                fail:(void (^)())fail;

@end
